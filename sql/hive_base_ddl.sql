CREATE DATABASE IF NOT EXISTS Medicare;
USE Medicare;

DROP TABLE Hospitals;

CREATE EXTERNAL TABLE Hospitals (
ProviderID varchar(8), 
HospitalName varchar(52),
Address varchar(52),
City varchar(22),
State varchar(4),
ZIPCode varchar(7),
CountyName varchar(22),
PhoneNumber varchar(12),
HospitalType varchar(27),
HospitalOwnership varchar(45),
EmergencyServices varchar(5),
MeetsCriteriaForMeaningfulUseOfEHRs varchar(2),
HospitalOverallRating int,
HospitalOverallRatingFootnote varchar(141),
MortalityNationalComparison varchar(30),
MortalityNationalComparisonFootnote varchar(141),
SafetyOfCareNationalComparison varchar(30),
SafetyOfCareNationalComparisonFootnote varchar(141),
ReadmissionNationalComparison varchar(30),
ReadmissionNationalComparisonFootnote varchar(141),
PatientExperienceNationalComparison varchar(30),
PatientExperienceNationalComparisonFootnote varchar(141),
EffectivenessOfCareNationalComparison varchar(30),
EffectivenessOfCareNationalComparisonFootnote varchar(141),
TimelinessOfCareNationalComparison varchar(30),
TimelinessOfCareNationalComparisonFootnote varchar(141),
EfficientUseOfMedicalImagingNationalComparison varchar(30),
EfficientUseOfMedicalImagingNationalComparisonFootnote varchar(141)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/hospitals';

DROP TABLE Payment;

CREATE EXTERNAL TABLE Payment (
DRGDefinition varchar(255),
ProviderID varchar(8),
HospitalName varchar(52),
Address varchar(52),
City varchar(22),
State varchar(4),
ZIPCode varchar(7),
HospitalReferralRegionDescription varchar(255), 
TotalDischarges varchar(255), 
AverageCoveredCharges varchar(255), 
AverageTotalPayments varchar(255),
AverageMedicarePayments varchar(255)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/payment';

DROP TABLE Measures;

CREATE EXTERNAL TABLE Measures (
MeasureName varchar(52),
MeasureID varchar(8),
MeasureStartQuarter varchar(255),
MeasureStartDate varchar(12),
MeasureEndQuarter varchar(255),
MeasureEndDate varchar(12)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/measures';

DROP TABLE Readmissions;

CREATE EXTERNAL TABLE Readmissions (
ProviderID varchar(8),
HospitalName varchar(255),
Address varchar(255),
City varchar(255),
State varchar(255),
ZIPCode int,
CountyName varchar(255),
PhoneNumber varchar(255),
MeasureName varchar(255),
MeasureID varchar(255),
ComparedtoNational varchar(255),
Denominator int,
Score float,
LowerEstimate float,
HigherEstimate float,
Footnote varchar(255),
MeasureStartDate varchar(12),
MeasureEndDate varchar(12)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/readmissions';

DROP TABLE EffectiveCare;

CREATE EXTERNAL TABLE EffectiveCare (
ProviderID varchar(8),
HospitalName varchar(52),
Address varchar(46),
City varchar(22),
State varchar(4),
ZIPCode varchar(7),
CountyName varchar(22),
PhoneNumber varchar(12),
Condition varchar(37),
MeasureID varchar(18),
MeasureName varchar(137),
Score int,
Sample int,
Footnote varchar(181),
MeasureStartDate varchar(12),
MeasureEndDate varchar(12)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/effective_care';

DROP TABLE SurveyResponses;

CREATE EXTERNAL TABLE SurveyResponses (
ProviderNumber varchar(8),
HospitalName varchar(52),
Address varchar(46),
City varchar(22),
State varchar(4),
ZIPCode varchar(7),
CountyName varchar(22),
CommunicationwithNursesAchievementPoints varchar(15),
CommunicationwithNursesImprovementPoints varchar(15),
CommunicationwithNursesDimensionScore varchar(15),
CommunicationwithDoctorsAchievementPoints varchar(15),
CommunicationwithDoctorsImprovementPoints varchar(15),
CommunicationwithDoctorsDimensionScore varchar(15),
ResponsivenessofHospitalStaffAchievementPoints varchar(15),
ResponsivenessofHospitalStaffImprovementPoints varchar(15),
ResponsivenessofHospitalStaffDimensionScore varchar(15),
PainManagementAchievementPoints varchar(15),
PainManagementImprovementPoints varchar(15),
PainManagementDimensionScore varchar(15),
CommunicationaboutMedicinesAchievementPoints varchar(15),
CommunicationaboutMedicinesImprovementPoints varchar(15),
CommunicationaboutMedicinesDimensionScore varchar(15),
CleanlinessandQuietnessofHospitalEnvironmentAchievementPoints varchar(15),
CleanlinessandQuietnessofHospitalEnvironmentImprovementPoints varchar(15),
CleanlinessandQuietnessofHospitalEnvironmentDimensionScore varchar(15),
DischargeInformationAchievementPoints varchar(15),
DischargeInformationImprovementPoints varchar(15),
DischargeInformationDimensionScore varchar(15),
OverallRatingofHospitalAchievementPoints varchar(15),
OverallRatingofHospitalImprovementPoints varchar(15),
OverallRatingofHospitalDimensionScore varchar(15),
HCAHPSBaseScore int,
HCAHPSConsistencyScore int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' 
WITH SERDEPROPERTIES (
"separatorChar" = ",", 
"quoteChar" = '"',
"escapeChar" = '\\' 
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/survey_responses';

