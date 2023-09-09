UPDATE d 

SET d.nationalityID = n.nationalityID 

FROM [dbo].[drivers] d

INNER JOIN [dbo].[nationalities] n ON d.nationality = n.nationality

GO

UPDATE c 

 SET c.nationalityID = n.nationalityID 

FROM [dbo].[constructors] c

INNER JOIN dbo.nationalities n ON c.nationality = n.nationality

GO

UPDATE r 

 SET r.positionTextID = pt.positionTextID 

FROM [dbo].[results] r

INNER JOIN [dbo].[positionText] pt ON r.[positionText] = pt.[positioncode]

GO

UPDATE sr 

 SET sr.positionTextID = pt.positionTextID 

FROM [dbo].[sprintResults] sr

INNER JOIN dbo.positionText pt ON sr.positionText = pt.positionText

GO

UPDATE cir

 SET cir.countryID = c.countryID 

FROM [dbo].[circuits] cir

INNER JOIN [dbo].[countries] c ON cir.[country] = c.[country]

GO

UPDATE cir

 SET cir.locationID = l.locationID 

FROM [dbo].[circuits] cir

INNER JOIN [dbo].[locations] l ON cir.[location] = l.[locationName]
 
GO

UPDATE c SET 

c.circuitDirectionID = tc.circuitDirectionID,
c.circuitTypeID = tc.circuitTypeID

FROM 
	[dbo].[tempCircuits] tc

INNER JOIN [dbo].[circuits] c ON c.name = tc.circuit

GO

DROP TABLE [dbo].[tempCircuits]

GO

UPDATE
	[dbo].[constructorResults]

	SET positionTextID = 600

WHERE 
	status = 'D'

GO

UPDATE cr

SET 
	cr.positionTextID = pt.positionTextID

FROM 
	[dbo].[constructorResults] cr

INNER JOIN [dbo].[positionText] pt 
	ON cr.[status] = pt.[positionText]

GO

UPDATE ds

SET 
	ds.positionTextID = pt.positionTextID

FROM 
	[dbo].[driverStandings] ds

INNER JOIN [dbo].[positionText] pt 
	ON ds.[positionText] = pt.[positionText]

GO

UPDATE cs

SET 
	cs.positionTextID = pt.positionTextID

FROM 
	[dbo].[constructorStandings] cs

INNER JOIN [dbo].[positionText] pt 
	ON cs.[positionText] = pt.[positionText]

GO

;WITH LeadingResults AS
(
	SELECT 

	raceID,
	positionOrder,
	dateadd(ms, milliseconds, '19800101') as LeadTime

	FROM 
		[dbo].[results]	
	WHERE 
		positionOrder = 1
),
DataOutput AS 
(
	SELECT 
		resultID,
		r.raceID,
		r.positionOrder,
		milliseconds,
		time,
		dateadd(ms, r.milliseconds, '19800101') - CASE 
													WHEN r.positionOrder = 1 THEN LAG(dateadd(ms, r.milliseconds, '19800101')) OVER( ORDER BY r.raceID,r.positionOrder) 
													WHEN r.positionOrder != 1 THEN lr.LeadTime 
												END AS Diff
	FROM							
		[dbo].[results]	r
		
		INNER JOIN LeadingResults lr 
			ON r.raceId = lr.raceId
)

UPDATE r
	SET 
		r.TimeDifference = do.Diff
	FROM 
		[dbo].[results] r

		INNER JOIN DataOutput DO 
			ON r.resultId = do.resultId

GO

UPDATE [dbo].[results]
	SET
		fastestLapTime_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(fastestLapTime, ':', '')), 10), 5, 0, ':'), 3, 0, ':')) 

/*sprintResults*/

;WITH LeadingResults AS
(
SELECT 

raceID,
positionOrder,
dateadd(ms, milliseconds, '19800101') as LeadTime

FROM 
	[dbo].[sprintResults]	
WHERE 
	positionOrder = 1
),
DataOutput AS 
(
SELECT 
	resultID,
	r.raceID,
	r.positionOrder,
	milliseconds,
	time,
	dateadd(ms, r.milliseconds, '19800101') - CASE 
												WHEN r.positionOrder = 1 THEN LAG(dateadd(ms, r.milliseconds, '19800101')) OVER( ORDER BY r.raceID,r.positionOrder) 
												WHEN r.positionOrder != 1 THEN lr.LeadTime 
											END AS Diff
FROM							
	[dbo].[sprintResults]	r
	
	INNER JOIN LeadingResults lr 
		ON r.raceId = lr.raceId
)

UPDATE r
	SET 
		r.TimeDifference = do.Diff

	FROM 
		[dbo].[sprintResults] r

		INNER JOIN DataOutput DO ON r.resultId = do.resultId
GO

UPDATE [dbo].[sprintResults]
	SET
		fastestLapTime_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(fastestLapTime, ':', '')), 10), 5, 0, ':'), 3, 0, ':')) 

GO

UPDATE [dbo].[results]
	SET
		fastestLapTime_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(fastestLapTime, ':', '')), 10), 5, 0, ':'), 3, 0, ':')) 

GO

UPDATE [dbo].[results]
	SET 
		fastestLapSpeed_Decimal = TRY_CONVERT(decimal(18,3),fastestLapSpeed) 

GO

UPDATE [dbo].[pitStops] 
	SET
		duration_converted = TRY_CONVERT(decimal(18,3),duration)

UPDATE [dbo].[qualifying]
	SET
		q1_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(q1, ':', '')), 10), 5, 0, ':'), 3, 0, ':')),
		q2_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(q2, ':', '')), 10), 5, 0, ':'), 3, 0, ':')),
		q3_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(q3, ':', '')), 10), 5, 0, ':'), 3, 0, ':'));

GO

UPDATE [dbo].[lapTimes]
	SET
		time_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(time, ':', '')), 10), 5, 0, ':'), 3, 0, ':')); 

GO

UPDATE [dbo].[results] 
	SET 
		time_converted = TRY_CONVERT(time(3),[time]) WHERE position = 1;

GO

UPDATE [dbo].[results] 
	SET 
		time_converted = TRY_CONVERT(time(3),[TimeDifference]) WHERE position != 1;

GO

UPDATE [dbo].[sprintResults] SET time_converted = TRY_CONVERT(time, STUFF(STUFF(RIGHT(CONCAT('000000', REPLACE(time, ':', '')), 10), 5, 0, ':'), 3, 0, ':'))  WHERE position = 1;

GO

UPDATE [dbo].[sprintResults] SET time_converted = TRY_CONVERT(time(3),[TimeDifference]) WHERE position != 1

GO

WITH driverConstructorInput AS (
    SELECT
        r.[year],
        r.[raceId],
        re.[driverId],
        re.[constructorId],
        r.[date]
    FROM 
        [dbo].[races] r
    INNER JOIN [dbo].[results] re 
        ON r.raceId = re.raceId
    UNION
    SELECT
        r.[year],
        r.[raceId],
        re.[driverId],
        re.[constructorId],
        r.[date]
    FROM 
        [dbo].[races] r
    INNER JOIN [dbo].[sprintResults] re 
        ON r.raceId = re.raceId
)

, DriverConstructorChanges AS (
    SELECT
        [year],
        [raceId],
        [driverId],
        [constructorId],
        [date],
        LAG(constructorId) OVER (PARTITION BY driverId, [year] ORDER BY raceId) AS previousConstructorId
    FROM
        driverConstructorInput
)

, DriverSpans AS (
    SELECT
        [year],
        [raceId],
        [driverId],
        [constructorId],
        date,
        CASE
            WHEN constructorId <> previousConstructorId OR previousConstructorId IS NULL THEN 1
            ELSE 0
        END AS isNewSpan
    FROM
        DriverConstructorChanges
)

, DriverSpanRanges AS (
    SELECT
        [year],
        [raceId],
        [driverId],
        [constructorId],
        [date],
        SUM(isNewSpan) OVER (PARTITION BY driverId, [year] ORDER BY raceId) AS SpanIdentifier
    FROM
        DriverSpans
)

,DriverSpanRangesResult AS (
SELECT
    [year],
    MIN(raceId) AS RangeFrom,
    MAX(raceId) AS RangeTo,
    [driverId],
    [constructorId],
    MIN(date) AS RangeStartDate,
    MAX(date) AS RangeEndDate
FROM
    DriverSpanRanges
GROUP BY
    [year],
    [driverId],
    [constructorId],
    [SpanIdentifier]
)

INSERT INTO [dbo].[driverConstructor] ([driverID],[constructorId],[season],[StartDate],[EndDate])
SELECT 
	[driverid],
	[constructorId],
	[year],
	[RangeStartDate],
	[RangeEndDate]
FROM 	
	DriverSpanRangesResult 

GO

ALTER TABLE [dbo].[constructors] DROP COLUMN [nationality]; 

ALTER TABLE [dbo].[circuits] DROP COLUMN [location]; 
ALTER TABLE [dbo].[circuits] DROP COLUMN [country]; 

ALTER TABLE [dbo].[results] DROP COLUMN [positionText];
ALTER TABLE [dbo].[results] DROP COLUMN [fastestLapTime];
ALTER TABLE [dbo].[results] DROP COLUMN [fastestLapSpeed];

ALTER TABLE [dbo].[qualifying] DROP COLUMN q1;
ALTER TABLE [dbo].[qualifying] DROP COLUMN q2;
ALTER TABLE [dbo].[qualifying] DROP COLUMN q3;

ALTER TABLE [dbo].[results] DROP COLUMN [time];
ALTER TABLE [dbo].[results] DROP COLUMN [timeDifference];
ALTER TABLE [dbo].[results] DROP COLUMN [constructorId];

ALTER TABLE [dbo].[drivers] DROP COLUMN [nationality]; 

ALTER TABLE [dbo].[positionText] DROP COLUMN [positionCode];
ALTER TABLE [dbo].[constructorResults] DROP COLUMN [status];
ALTER TABLE [dbo].[constructorStandings] DROP COLUMN [positionText];
ALTER TABLE [dbo].[driverStandings] DROP COLUMN [positionText];
ALTER TABLE [dbo].[pitStops] DROP COLUMN [duration];
ALTER TABLE [dbo].[lapTimes] DROP COLUMN [time];

ALTER TABLE [dbo].[sprintResults] DROP COLUMN [fastestLapTime];
ALTER TABLE [dbo].[sprintResults] DROP COLUMN [positionText];
ALTER TABLE [dbo].[sprintResults] DROP COLUMN [timeDifference];
ALTER TABLE [dbo].[sprintResults] DROP COLUMN [time];
ALTER TABLE [dbo].[sprintResults] DROP COLUMN [constructorId];

EXEC sp_rename 'dbo.sprintResults.fastestLapTime_converted', 'fastestLapTime', 'COLUMN';
EXEC sp_rename 'dbo.results.fastestLapTime_converted', 'fastestLapTime', 'COLUMN';
EXEC sp_rename 'dbo.results.fastestLapSpeed_Decimal', 'fastestLapSpeed', 'COLUMN';
EXEC sp_rename 'dbo.pitStops.duration_converted', 'duration', 'COLUMN';
EXEC sp_rename 'dbo.qualifying.q1_converted', 'q1', 'COLUMN';
EXEC sp_rename 'dbo.qualifying.q2_converted', 'q2', 'COLUMN';
EXEC sp_rename 'dbo.qualifying.q3_converted', 'q3', 'COLUMN';
EXEC sp_rename 'dbo.lapTimes.time_converted', 'time', 'COLUMN';
EXEC sp_rename 'dbo.results.time_converted', 'time', 'COLUMN';
EXEC sp_rename 'dbo.sprintResults.time_converted', 'time', 'COLUMN';