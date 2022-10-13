
--TO INVESTIGATE THE MOST DEADLY AVIATION TRAGEDY

ALTER TABLE AirplaneCrashes..Aircrash
ADD AdjustedFatalities nvarchar(255);

UPDATE AirplaneCrashes..Aircrash
SET fatalities= SUBSTRING(fatalities,1,CHARINDEX(' ',fatalities)-1);

UPDATE AirplaneCrashes..Aircrash
SET fatalities = 0
WHERE fatalities = '?';

UPDATE AirplaneCrashes..Aircrash
SET fatalities= CAST(fatalities as int);

SELECT
	location,fatalities
FROM
	AirplaneCrashes..Aircrash
ORDER BY
	CAST(fatalities AS INT) DESC;



--TO INVESTIGATE WHICH AIRCRAFT IS THE MOST DANGEROUS

SELECT
	ac_type,SUM(CAST(fatalities as int)) AS Fatalities
FROM
	AirplaneCrashes..Aircrash
GROUP BY
	ac_type
ORDER BY
	SUM(CAST(fatalities as int)) DESC;


-- TO INVESTIGATE WHICH LOCATION IS MORE DANGEROUS

SELECT
	location,SUM(CAST(fatalities as int)) AS Fatalities
FROM
	AirplaneCrashes..Aircrash
GROUP BY
	location
ORDER BY
	SUM(CAST(fatalities as int)) DESC;

---- TO INVESTIGATE WHICH OPERATOR WAS INVOLVED IN MORE ACCIDENTS

SELECT
	operator,SUM(CAST(fatalities as int)) AS Fatalities
FROM
	AirplaneCrashes..Aircrash
GROUP BY
	operator
ORDER BY
	SUM(CAST(fatalities as int)) DESC;

-----------------------------------
--TO ADJUST DATE 

ALTER TABLE AirplaneCrashes..Aircrash
ADD DateOnlyYear nvarchar(255);

UPDATE AirplaneCrashes..Aircrash
SET DateOnlyYear= SUBSTRING(date,CHARINDEX(',',date)+2,LEN(date));

-------------------------
--TO ASSIGN UNIQUE IDs
--ALTER TABLE AirplaneCrashes..Aircrash
--DROP COLUMN Unique_ID;

ALTER TABLE AirplaneCrashes..Aircrash
ADD Unique_id nvarchar(255);

UPDATE AirplaneCrashes..Aircrash
SET Unique_id= newid();
------------------------------------

--TO FIND DEATHS PER ACCIDENT FOR DIFFERENT AIRLINES

With DeathValuesYearByYear AS(
SELECT operator, SUM(CAST(fatalities as int)) AS Deaths, COUNT(operator) AS NumberOfAccidents
FROM 
	AirplaneCrashes..Aircrash
GROUP BY
	operator
)

SELECT
	AA.operator,MAX((D.Deaths / D.NumberOfAccidents)) AS NumberOfDeathsPerAccident
FROM
	AirplaneCrashes..Aircrash AA
	JOIN DeathValuesYearByYear D
	ON AA.operator=D.operator
GROUP BY
	AA.operator
ORDER BY
	NumberOfDeathsPerAccident DESC;


-------------------------------------


