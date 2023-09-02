SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[qualifying](
	[qualifyId] [int] NOT NULL,
	[raceId] [int] NOT NULL,
	[driverId] [int] NOT NULL,
	[constructorId] [int] NOT NULL,
	[number] [int] NOT NULL,
	[position] [int] NULL,
	[q1] [time](3) NULL,
	[q2] [time](3) NULL,
	[q3] [time](3) NULL,
 CONSTRAINT [PK_qualifying_qualifyId] PRIMARY KEY CLUSTERED 
(
	[qualifyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
