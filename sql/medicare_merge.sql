USE Medicare;

--DROP TABLE AverageEffectiveCare;

--CREATE TABLE AverageEffectiveCare 
--AS SELECT ProviderID, avg(Score) AS AverageEffectiveCareScore
--FROM EffectiveCare2 GROUP BY ProviderID;

--DROP TABLE AverageReadmissions;

--CREATE TABLE AverageReadmissions 
--AS SELECT ProviderID, avg(Score) AS AverageReadmissionScore 
--FROM Readmissions2 GROUP BY ProviderID;

--DROP TABLE Scores;

--CREATE TABLE Scores
--AS SELECT AverageEffectiveCare.ProviderID, AverageEffectiveCareScore, AverageReadmissionScore
--FROM AverageEffectiveCare INNER JOIN AverageReadmissions 
--ON AverageEffectiveCare.ProviderID = AverageReadmissions.ProviderID;


DROP TABLE Medicare;

CREATE TABLE Medicare
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
"separatorChar" = ",",
"quoteChar" = '"',
"escapeChar" = '\\'
)
STORED AS TEXTFILE
LOCATION '/user/w205/data/medicare'
AS SELECT 
h.ProviderID, 
HospitalName, 
Address, 
City, 
State, 
ZIPCode,
HospitalOverallRating,
MortalityNationalComparison,
SafetyOfCareNationalComparison,
ReadmissionNationalComparison,
PatientExperienceNationalComparison,
EffectivenessOfCareNationalComparison,
TimelinessOfCareNationalComparison,
EfficientUseOfMedicalImagingNationalComparison,
AverageEffectiveCareScore, 
AverageReadmissionScore,
(CASE MortalityNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as MortalityComp,
(CASE SafetyOfCareNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as SafetyOfCareComp,
(CASE ReadmissionNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as ReadmissionComp,
(CASE PatientExperienceNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as PatientExperienceComp,
(CASE EffectivenessOfCareNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as EffectivenessOfCareComp,
(CASE TimelinessOfCareNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as TimelinessOfCareComp,
(CASE EfficientUseOfMedicalImagingNationalComparison WHEN 'Same as the National average' THEN 0 WHEN 'Above the National average' THEN 1 WHEN 'Below the National average' THEN -1 ELSE NULL end) as EfficientUseOfMedicalImagingComp
FROM Scores INNER JOIN 
(SELECT ho.* from Hospitals ho) h
ON Scores.ProviderID = h.ProviderID;

--(SELECT ho.*, p.AverageCoveredCharges, p.AverageTotalPayment, p.AverageMedicarePayments from Hospitals ho INNER JOIN Payment p ON ho.ProviderID = p.ProviderID) h

