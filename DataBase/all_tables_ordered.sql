CREATE TABLE [dbo].[Course] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [COURSE_CODE] VARCHAR (9)   NOT NULL,
    [CATEGORY]    VARCHAR (20)  NOT NULL,
    [CREDIT_HRS]  INT           NOT NULL,
    [Title]       NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

GO

CREATE TABLE [dbo].[Department] (
    [ID]   INT         IDENTITY (1, 1) NOT NULL,
    [NAME] VARCHAR (2) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

GO

CREATE TABLE [dbo].[CourseOffering] (
    [ID]         INT          IDENTITY (1, 1) NOT NULL,
    [CourseID]   INT          NOT NULL,
    [Semester]   INT          NOT NULL,
    [DEPARTMENT] INT          NULL,
    [Year]       INT          NOT NULL,
    [SESSION]    VARCHAR (10) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([CourseID]) REFERENCES [dbo].[Course] ([ID]),
    FOREIGN KEY ([DEPARTMENT]) REFERENCES [dbo].[Department] ([ID])
);


GO

GO

CREATE TABLE [dbo].[Section] (
    [ID]         INT         IDENTITY (1, 1) NOT NULL,
    [NAME]       VARCHAR (7) NULL,
    [department] INT         NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([department]) REFERENCES [dbo].[Department] ([ID])
);


GO

GO

CREATE TABLE [dbo].[Users] (
    [ID]              INT             IDENTITY (1, 1) NOT NULL,
    [Name]            VARCHAR (100)   NOT NULL,
    [Gender]          VARCHAR (20)    NOT NULL,
    [DateOfBirth]     DATE            NOT NULL,
    [Email]           VARCHAR (150)   NOT NULL,
    [PhoneNumber]     VARCHAR (20)    NOT NULL,
    [Role]            VARCHAR (50)    NOT NULL,
    [profile_image]   NVARCHAR (MAX)  NOT NULL,
    [image_embedding] VARBINARY (MAX) NULL,
    [identity_no]     INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    UNIQUE NONCLUSTERED ([Email] ASC)
);


GO

GO

CREATE TABLE [dbo].[Teacher] (
    [ID]                  INT          IDENTITY (1, 1) NOT NULL,
    [userID]              INT          NULL,
    [DESIGNATION]         VARCHAR (30) NOT NULL,
    [EXPERIENCE_IN_YEARS] INT          NULL,
    [QUALIFICATION]       VARCHAR (30) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([userID]) REFERENCES [dbo].[Users] ([ID])
);


GO

GO

CREATE TABLE [dbo].[CourseAllocation] (
    [ID]             INT  IDENTITY (1, 1) NOT NULL,
    [TeacherID]      INT  NOT NULL,
    [OfferingID]     INT  NOT NULL,
    [SECTION]        INT  NULL,
    [AllocationDate] DATE DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([OfferingID]) REFERENCES [dbo].[CourseOffering] ([ID]),
    FOREIGN KEY ([SECTION]) REFERENCES [dbo].[Section] ([ID]),
    FOREIGN KEY ([TeacherID]) REFERENCES [dbo].[Teacher] ([ID])
);


GO

GO

CREATE TABLE [dbo].[Exam] (
    [ID]              INT          IDENTITY (1, 1) NOT NULL,
    [A_ID]            INT          NULL,
    [TITLE]           VARCHAR (50) NOT NULL,
    [TOTAL_QUESTIONS] INT          NULL,
    [E_DATE]          DATE         NULL,
    [START_TIME]      VARCHAR (10) NULL,
    [END_TIME]        VARCHAR (10) NULL,
    [E_TYPE]          VARCHAR (6)  NULL,
    [STATUS]          VARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([A_ID]) REFERENCES [dbo].[CourseAllocation] ([ID])
);


GO

GO

CREATE TABLE [dbo].[Room] (
    [ID]          INT         IDENTITY (1, 1) NOT NULL,
    [RoomName]    VARCHAR (7) NOT NULL,
    [TotalRows]   INT         NOT NULL,
    [SeatsPerRow] INT         NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO

GO

CREATE TABLE [dbo].[ExamRoom] (
    [ID]     INT      IDENTITY (1, 1) NOT NULL,
    [ExamID] INT      NULL,
    [RoomID] INT      NULL,
    [E_Date] DATE     NULL,
    [E_Time] TIME (7) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ExamID]) REFERENCES [dbo].[Exam] ([ID]),
    FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Room] ([ID])
);


GO

GO

CREATE TABLE [dbo].[Student] (
    [StudentID] INT          IDENTITY (1, 1) NOT NULL,
    [userID]    INT          NULL,
    [CGPA]      FLOAT (53)   NULL,
    [Section]   INT          NULL,
    [Intake]    VARCHAR (20) NULL,
    [YEAR]      INT          NULL,
    PRIMARY KEY CLUSTERED ([StudentID] ASC),
    FOREIGN KEY ([Section]) REFERENCES [dbo].[Section] ([ID]),
    FOREIGN KEY ([userID]) REFERENCES [dbo].[Users] ([ID])
);


GO

GO

CREATE TABLE [dbo].[ExamMCQ] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [E_ID]        INT           NULL,
    [DESCRIPTION] VARCHAR (MAX) NULL,
    [MARKS]       INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([E_ID]) REFERENCES [dbo].[Exam] ([ID])
);


GO

GO

CREATE TABLE [dbo].[McqOption] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [M_ID]        INT           NULL,
    [OPTION_TEXT] VARCHAR (MAX) NULL,
    [IS_CORRECT]  BIT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([M_ID]) REFERENCES [dbo].[ExamMCQ] ([ID])
);


GO

GO

CREATE TABLE [dbo].[McqAns] (
    [ID]   INT IDENTITY (1, 1) NOT NULL,
    [M_ID] INT NULL,
    [S_ID] INT NULL,
    [O_ID] INT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([M_ID]) REFERENCES [dbo].[ExamMCQ] ([ID]),
    FOREIGN KEY ([O_ID]) REFERENCES [dbo].[McqOption] ([ID]),
    FOREIGN KEY ([S_ID]) REFERENCES [dbo].[Student] ([StudentID])
);


GO

GO

CREATE TABLE [dbo].[ExamDescQues] (
    [ID]          INT           IDENTITY (1, 1) NOT NULL,
    [E_ID]        INT           NULL,
    [DESCRIPTION] VARCHAR (MAX) NULL,
    [MARKS]       INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([E_ID]) REFERENCES [dbo].[Exam] ([ID])
);


GO

GO

CREATE TABLE [dbo].[DesAns] (
    [ID]      INT           IDENTITY (1, 1) NOT NULL,
    [Q_ID]    INT           NULL,
    [S_ID]    INT           NULL,
    [ANSWERS] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([Q_ID]) REFERENCES [dbo].[ExamDescQues] ([ID]),
    FOREIGN KEY ([S_ID]) REFERENCES [dbo].[Student] ([StudentID])
);


GO

GO

CREATE TABLE [dbo].[ProctoringEvent] (
    [ID]        INT          IDENTITY (1, 1) NOT NULL,
    [EX_ID]     INT          NULL,
    [S_ID]      INT          NULL,
    [EventType] VARCHAR (50) NOT NULL,
    [EventTime] DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([EX_ID]) REFERENCES [dbo].[Exam] ([ID]),
    FOREIGN KEY ([S_ID]) REFERENCES [dbo].[Student] ([StudentID])
);


GO

GO

CREATE TABLE [dbo].[VoiceMonitoring] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [EventID]    INT           NULL,
    [Transcript] VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([EventID]) REFERENCES [dbo].[ProctoringEvent] ([ID])
);


GO

GO

CREATE TABLE [dbo].[TeacherRoomAssignment] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [TeacherID]  INT NOT NULL,
    [ExamRoomID] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ExamRoomID]) REFERENCES [dbo].[ExamRoom] ([ID]),
    FOREIGN KEY ([TeacherID]) REFERENCES [dbo].[Teacher] ([ID]),
    CONSTRAINT [UQ_Teacher_Per_Exam] UNIQUE NONCLUSTERED ([TeacherID] ASC, [ExamRoomID] ASC)
);


GO

GO

CREATE TABLE [dbo].[CourseEnrollment] (
    [ID]             INT          IDENTITY (1, 1) NOT NULL,
    [StudentID]      INT          NOT NULL,
    [OfferingID]     INT          NOT NULL,
    [EnrollmentDate] DATE         DEFAULT (getdate()) NULL,
    [Status]         VARCHAR (20) DEFAULT ('Enrolled') NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([OfferingID]) REFERENCES [dbo].[CourseOffering] ([ID]),
    FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Student] ([StudentID]),
    UNIQUE NONCLUSTERED ([StudentID] ASC, [OfferingID] ASC)
);


GO

GO

CREATE TABLE [dbo].[ScreenMonitoring] (
    [ID]            INT             IDENTITY (1, 1) NOT NULL,
    [EventID]       INT             NULL,
    [ActionType]    VARCHAR (50)    NULL,
    [EvidanceImage] VARBINARY (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([EventID]) REFERENCES [dbo].[ProctoringEvent] ([ID])
);


GO

GO

CREATE TABLE [dbo].[StudentBreak] (
    [BreakID]        INT          IDENTITY (1, 1) NOT NULL,
    [StudentID]      INT          NOT NULL,
    [ExamID]         INT          NOT NULL,
    [TeacherID]      INT          NOT NULL,
    [BreakStartTime] DATETIME     DEFAULT (getdate()) NOT NULL,
    [BreakEndTime]   DATETIME     NULL,
    [BreakType]      VARCHAR (20) NULL,
    PRIMARY KEY CLUSTERED ([BreakID] ASC),
    CONSTRAINT [FK_StudentBreak_Exam] FOREIGN KEY ([ExamID]) REFERENCES [dbo].[Exam] ([ID]),
    CONSTRAINT [FK_StudentBreak_Student] FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Student] ([StudentID]),
    CONSTRAINT [FK_StudentBreak_Teacher] FOREIGN KEY ([TeacherID]) REFERENCES [dbo].[Teacher] ([ID])
);


GO

GO

CREATE TABLE [dbo].[CameraMonitoring] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [EventID]          INT            NULL,
    [IsStudentPresent] INT            NULL,
    [description]      VARCHAR (MAX)  NULL,
    [ImageEvidence]    NVARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([EventID]) REFERENCES [dbo].[ProctoringEvent] ([ID])
);


GO

GO

CREATE TABLE [dbo].[StudentSeating] (
    [ID]         INT IDENTITY (1, 1) NOT NULL,
    [StudentID]  INT NOT NULL,
    [RoomID]     INT NOT NULL,
    [ExamID]     INT NOT NULL,
    [RowNumber]  INT NOT NULL,
    [SeatNumber] INT NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([ExamID]) REFERENCES [dbo].[Exam] ([ID]),
    FOREIGN KEY ([RoomID]) REFERENCES [dbo].[Room] ([ID]),
    FOREIGN KEY ([StudentID]) REFERENCES [dbo].[Student] ([StudentID]),
    UNIQUE NONCLUSTERED ([RoomID] ASC, [ExamID] ASC, [RowNumber] ASC, [SeatNumber] ASC)
);


GO

GO

