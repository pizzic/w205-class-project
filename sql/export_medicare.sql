USE Medicare;

INSERT OVERWRITE LOCAL DIRECTORY 'data/medicare.csv' ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' SELECT * FROM Medicare;


