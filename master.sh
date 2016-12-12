#! /bin/bash

# Load the master data set into HDFS.
hdfs dfs -mkdir /user/w205/data/master
hdfs dfs -rm /user/w205/data/master/*
hdfs dfs -put Master_Data_Set.csv /user/w205/data/master/

# Load the DDL so Hive can parse the file.
hive -f sql/master_ddl.sql

# Start the Hive server.
hive -service hiveserver2