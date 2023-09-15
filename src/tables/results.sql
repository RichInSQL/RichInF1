SET
	ANSI_NULLS ON 
	GO
SET
	QUOTED_IDENTIFIER ON 
	GO
CREATE TABLE
	dbo.results (
		resultId INT  NOT NULL,
		raceId INT NOT NULL DEFAULT 0,
		driverId INT NOT NULL,
		constructorId INT NOT NULL,
		number INT NULL,
		grid INT NOT NULL DEFAULT 0,
		position INT,
		positionText varchar(255) NOT NULL,
		positionOrder INT NOT NULL DEFAULT 0,
		points float NOT NULL DEFAULT 0,
		laps INT NOT NULL DEFAULT 0,
		time varchar(255),
		milliseconds INT,
		fastestLap INT,
		rank INT DEFAULT 0,
		fastestLapTime varchar(255),
		fastestLapSpeed varchar(255),
		statusId INT NOT NULL DEFAULT 0,
		positionTextID INT,
		[timeDifference] DATETIME NULL,
		[fastestLapTime_Converted] TIME(3) NULL,
		[fastestLapSpeed_Decimal] DECIMAL(18,3) NULL,
		time_converted time(3),
		CONSTRAINT PK_results_resultId PRIMARY KEY CLUSTERED (resultId ASC)
		WITH
			(
				PAD_INDEX = OFF,
				IGNORE_DUP_KEY = OFF,
				ALLOW_ROW_LOCKS = ON,
				ALLOW_PAGE_LOCKS = ON
			) ON [PRIMARY]
	) ON [PRIMARY] 
	GO