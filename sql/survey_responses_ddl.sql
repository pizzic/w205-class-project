USE Medicare;

DROP TABLE SurveyResponses2;

CREATE TABLE SurveyResponses2 AS SELECT ProviderNumber AS ProviderID, cast(split(OverallRatingOfHospitalAchievementPoints,' out of 10')[0] as int) AS OverallRatingAP, cast(split(OverallRatingOfHospitalImprovementPoints,' out of 9')[0] as int) AS OverallRatingIP, cast(split(OverallRatingOfHospitalDimensionScore,' out of 10')[0] as int) AS OverallRatingDS from SurveyResponses;
