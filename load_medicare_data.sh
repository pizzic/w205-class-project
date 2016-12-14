#! /bin/bash

# Download the data.
mkdir data

cd data
wget -O hospital_compare.zip "https://data.medicare.gov/views/bg9k-emty/files/a24d7358-cadb-4d3e-bebc-ecf41e8a74b9?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_FlatFiles.zip"
wget -O payment.csv "https://data.cms.gov/api/views/97k6-zzx3/rows.csv?accessType=DOWNLOAD"
#wget -O physician_compare.zip "https://data.medicare.gov/views/bg9k-emty/files/16507c55-86f8-4a37-b9c0-838fb76c6111?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Physician_Compare.zip"

# Create a directory in HDFS to put the files.
hdfs dfs -mkdir /user/w205/data

# Unzip the file.
unzip -uo hospital_compare.zip
#unzip -uo physician_compare.zip

# Replace spaces in names with underscores.
for f in *\ *; do mv "$f" "${f// /_}"; done

# Trim header line and rename
tail -n +2 Hospital_General_Information.csv > ./hospitals.csv
#tail -n +2 Measure_Dates.csv > ./measures.csv
tail -n +2 Readmissions_and_Deaths_-_Hospital.csv > ./readmissions.csv
tail -n +2 Timely_and_Effective_Care_-_Hospital.csv > ./effective_care.csv
#tail -n +2 hvbp_hcahps_08_26_2016.csv > ./survey_responses.csv

# Load the files into HDFS.
hdfs dfs -put *.csv /user/w205/data

hdfs dfs -mkdir /user/w205/data/hospitals
#hdfs dfs -mkdir /user/w205/data/measures
hdfs dfs -mkdir /user/w205/data/readmissions
#hdfs dfs -mkdir /user/w205/data/survey_responses
hdfs dfs -mkdir /user/w205/data/effective_care
hdfs dfs -mkdir /user/w205/data/payment
hdfs dfs -mkdir /user/w205/data/medicare

hdfs dfs -put hospitals.csv /user/w205/data/hospitals
#hdfs dfs -put measures.csv /user/w205/data/measures
hdfs dfs -put readmissions.csv /user/w205/data/readmissions
#hdfs dfs -put survey_responses.csv /user/w205/data/survey_responses
hdfs dfs -put effective_care.csv /user/w205/data/effective_care
hdfs dfs -put payment.csv /user/w205/data/payment

cd ..
hive -f sql/hive_base_ddl.sql
hive -f sql/effective_care_ddl.sql
hive -f sql/readmissions_ddl.sql
#hive -f sql/survey_responses_ddl.sql
hive -f sql/medicare_merge.sql

hdfs dfs -get /user/w205/data/medicare/000000_0 medicare.csv 


