CREATE DATABASE IF NOT EXISTS Medicare;
USE Medicare;

DROP TABLE Master;

CREATE EXTERNAL TABLE Master (
ProviderID varchar(8), 
HospitalName varchar(52),
Address varchar(52),
City varchar(22),
State varchar(4),
ZIPCode varchar(7),
HospitalOverallRating int,
MortalityNationalComparison varchar(30),
SafetyOfCareNationalComparison varchar(30),
ReadmissionNationalComparison varchar(30),
PatientExperienceNationalComparison varchar(30),
EffectivenessOfCareNationalComparison varchar(30),
TimelinessOfCareNationalComparison varchar(30),
EfficientUseOfMedicalImagingNationalComparison varchar(30),
AverageEffectiveCareScore float, 
AverageReadmissionScore float,
SafetyGrade varchar(2),
YelpRating float
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/master';
