USE Medicare;

DROP TABLE EffectiveCare2;

CREATE TABLE EffectiveCare2 
AS SELECT 
ProviderID, 
HospitalName, Address, City, State, ZIPCode, 
Score, MeasureID, MeasureName 
from EffectiveCare where length(score) < 5;
