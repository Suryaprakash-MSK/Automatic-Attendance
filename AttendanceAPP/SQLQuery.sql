﻿CREATE TABLE [dbo].[Attendance] (
    [Date]        DATE            DEFAULT (CONVERT([date],getdate())) NOT NULL,
    [UserId]      INT             NOT NULL,
    [Username]    NVARCHAR (100)  NOT NULL,
    [Gender]      NVARCHAR (10)   NOT NULL,
    [Age]         INT             NOT NULL,
    [EnterTime]   TIME (7)        NOT NULL,
    [ExitTime]    TIME (7)        NULL,
    [WorkedHours] AS              (datediff(minute,[EnterTime],[ExitTime])/(60.0)) PERSISTED,
    [ImageData]   VARBINARY (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([Date] ASC, [UserId] ASC)
);


CREATE TABLE [dbo].[Users] (
    [UserId]   INT            NOT NULL,
    [UserName] NVARCHAR (100) NOT NULL,
    [Gender]   NVARCHAR (10)  NOT NULL,
    [Age]      INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([UserId] ASC),
    UNIQUE NONCLUSTERED ([UserName] ASC)
);

CREATE TABLE [dbo].[UserFaceFeatures] (
    [FeatureId]   INT             IDENTITY (1, 1) NOT NULL,
    [UserId]      INT             NOT NULL,
    [FeatureData] VARBINARY (MAX) NOT NULL,
    PRIMARY KEY CLUSTERED ([FeatureId] ASC),
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users] ([UserId]) ON DELETE CASCADE
);

DECLARE @SelectedDate DATE = '2025-04-18'; -- Change to your desired date

SELECT 
    u.UserId,
    u.UserName,
    CASE 
        WHEN a.UserId IS NOT NULL THEN 'Present'
        ELSE 'Absent'
    END AS Status
FROM Users u
LEFT JOIN Attendance a
    ON u.UserId = a.UserId AND a.Date = @SelectedDate
ORDER BY u.UserName;
