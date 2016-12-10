USE Medicare;

DROP TABLE Readmissions2;

CREATE TABLE Readmissions2 AS SELECT ProviderID, HospitalName, State, Score, MeasureID, MeasureName from Readmissions where Score <> 'Not Available';
