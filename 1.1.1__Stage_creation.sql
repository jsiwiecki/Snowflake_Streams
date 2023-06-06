// Create an internal stage

create or replace stage VHOL_STAGE
FILE_FORMAT = ( TYPE=JSON,STRIP_OUTER_ARRAY=TRUE );

 Create a Staging/Landing Table
create or replace table CC_TRANS_STAGING (RECORD_CONTENT variant);