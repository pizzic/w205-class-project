USE Medicare;

DROP TABLE AverageEffectiveCare;

CREATE TABLE AverageEffectiveCare 
AS SELECT ProviderID, avg(Score) AS AverageEffectiveCareScore
FROM EffectiveCare2 GROUP BY ProviderID;

DROP TABLE AverageReadmissions;

CREATE TABLE AverageReadmissions 
AS SELECT ProviderID, avg(Score) AS AverageReadmissionScore 
FROM Readmissions2 GROUP BY ProviderID;

DROP TABLE Scores;

CREATE TABLE Scores
AS SELECT AverageEffectiveCare.ProviderID, AverageEffectiveCareScore, AverageReadmissionScore
FROM AverageEffectiveCare INNER JOIN AverageReadmissions 
ON AverageEffectiveCare.ProviderID = AverageReadmissions.ProviderID;

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
AS SELECT Scores.ProviderID, HospitalName, Address, City, State, ZIPCode, AverageEffectiveCareScore, AverageReadmissionScore
FROM Scores INNER JOIN 
(SELECT DISTINCT ProviderID, HospitalName, Address, City, State, ZIPCode from Hospitals) h
ON Scores.ProviderID = h.ProviderID;



