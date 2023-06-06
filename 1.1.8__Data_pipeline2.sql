// Creates tasks with dependencies to orchestrate the whole data flow

create or replace task REFINE_TASK2
WAREHOUSE=VHOL_WH
as
insert into CC_TRANS_ALL (select                     
card_id, merchant_id, transaction_id, amount, currency, approved, type, timestamp
from CC_TRANS_STAGING_VIEW_STREAM);

create or replace task PROCESS_FILES_TASK2
WAREHOUSE=VHOL_WH
as
copy into CC_TRANS_STAGING from @VHOL_STAGE PATTERN='.*SNOW_.*';


create or replace task LOAD_TASK
WAREHOUSE=VHOL_WH
SCHEDULE = '1 minute'
COMMENT = 'Full Sequential Orchestration'
as
call SIMULATE_KAFKA_STREAM('@VHOL_STAGE','SNOW_',1000000);

alter task REFINE_TASK2 add after PROCESS_FILES_TASK2;
alter task REFINE_TASK2 RESUME;


alter task PROCESS_FILES_TASK2 add after LOAD_TASK;
alter task PROCESS_FILES_TASK2 RESUME;

alter task LOAD_TASK RESUME;


alter task LOAD_TASK SUSPEND;
create or replace task WAIT_TASK
  WAREHOUSE=VHOL_WH
  after PROCESS_FILES_TASK2
as
  call SYSTEM$wait(1);

alter task WAIT_TASK RESUME;
alter task LOAD_TASK RESUME;

select * from table(information_schema.task_dependents(task_name => 'LOAD_TASK', recursive => true));


alter task LOAD_TASK SUSPEND;
alter task REFINE_TASK2 SUSPEND;
alter task PROCESS_FILES_TASK2 SUSPEND;
alter task WAIT_TASK SUSPEND;