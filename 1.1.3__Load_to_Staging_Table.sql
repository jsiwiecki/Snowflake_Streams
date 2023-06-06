copy into CC_TRANS_STAGING from @VHOL_STAGE PATTERN='.*SNOW_.*';


/* Test queries to peek the data
select count(*) from CC_TRANS_STAGING;
select * from CC_TRANS_STAGING limit 10;
select RECORD_CONTENT:card:number as card_id from CC_TRANS_STAGING limit 10;

RECORD_CONTENT:card:number::varchar,
RECORD_CONTENT:merchant:id::varchar,
RECORD_CONTENT:transaction:id::varchar,
RECORD_CONTENT:transaction:amount::float,
RECORD_CONTENT:transaction:currency::varchar,
RECORD_CONTENT:transaction:approved::boolean,
RECORD_CONTENT:transaction:type::varchar,
RECORD_CONTENT:transaction:timestamp::datetime
from CC_TRANS_STAGING
where RECORD_CONTENT:transaction:amount::float < 600 limit 10;
*/
