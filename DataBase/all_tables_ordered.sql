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

-- ======================================
-- Departments
-- ======================================
INSERT INTO [dbo].[Department] ([NAME])
VALUES 
('AI'),
('SE'),
('CS');
GO

-- ======================================
-- Courses
-- ======================================
INSERT INTO [dbo].[Course] ([COURSE_CODE], [CATEGORY], [CREDIT_HRS], [Title])
VALUES 
('AI101', 'Core', 3, 'Introduction to AI'),
('AI201', 'Core', 3, 'Machine Learning'),
('SE101', 'Core', 3, 'Software Engineering'),
('SE201', 'Core', 3, 'Agile Methodologies'),
('CS101', 'Core', 3, 'Data Structures'),
('CS201', 'Core', 3, 'Algorithms');
GO

-- ======================================
-- Rooms
-- ======================================
INSERT INTO [dbo].[Room] ([RoomName], [TotalRows], [SeatsPerRow])
VALUES 
('LT1', 5, 8),
('LT2', 6, 10),
('LT3', 4, 6);
GO

-- ======================================
-- Sections
-- ======================================
INSERT INTO [dbo].[Section] ([NAME], [department])
VALUES
('A1', 1),
('A2', 1),
('B1', 2),
('B2', 2),
('C1', 3),
('C2', 3);
GO

-- ======================================
-- Users
-- ======================================
INSERT INTO [dbo].[Users] ([Name], [Gender], [DateOfBirth], [Email], [PhoneNumber], [Role], [profile_image])
VALUES
('Ali Khan', 'Male', '2000-05-10', 'ali.khan@example.com', '03001234567', 'Student', 'profile1.jpg'),
('Sara Ahmed', 'Female', '1999-08-22', 'sara.ahmed@example.com', '03007654321', 'Student', 'profile2.jpg'),
('Bilal Qureshi', 'Male', '1995-03-15', 'bilal.qureshi@example.com', '03009876543', 'Teacher', 'profile3.jpg'),
('Hina Riaz', 'Female', '1994-12-01', 'hina.riaz@example.com', '03002345678', 'Teacher', 'profile4.jpg');
GO

-- ======================================
-- Teacher
-- ======================================
INSERT INTO [dbo].[Teacher] ([userID], [DESIGNATION], [EXPERIENCE_IN_YEARS], [QUALIFICATION])
VALUES
(3, 'Assistant Professor', 5, 'PhD'),
(4, 'Lecturer', 3, 'MSc');
GO

-- ======================================
-- CourseOffering
-- ======================================
INSERT INTO [dbo].[CourseOffering] ([CourseID], [Semester], [DEPARTMENT], [Year], [SESSION])
VALUES
(1, 1, 1, 2026, 'Spring'),
(2, 2, 1, 2026, 'Spring'),
(3, 1, 2, 2026, 'Spring'),
(4, 2, 2, 2026, 'Spring'),
(5, 1, 3, 2026, 'Spring'),
(6, 2, 3, 2026, 'Spring');
GO

-- ======================================
-- CourseAllocation
-- ======================================
INSERT INTO [dbo].[CourseAllocation] ([TeacherID], [OfferingID], [SECTION])
VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 3),
(2, 4, 4),
(1, 5, 5),
(1, 6, 6);
GO

-- ======================================
-- Students
-- ======================================
INSERT INTO [dbo].[Student] ([userID], [CGPA], [Section], [Intake], [YEAR])
VALUES
(1, 3.5, 1, '2022', 3),
(2, 3.7, 2, '2022', 3);
GO

-- ======================================
-- CourseEnrollment
-- ======================================
INSERT INTO [dbo].[CourseEnrollment] ([StudentID], [OfferingID])
VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4);
GO

-- ======================================
-- Exam
-- ======================================
INSERT INTO [dbo].[Exam] ([A_ID], [TITLE], [TOTAL_QUESTIONS], [E_DATE], [START_TIME], [END_TIME], [E_TYPE], [STATUS])
VALUES
(1, 'Midterm AI', 10, '2026-03-15', '10:00', '12:00', 'MCQ', 'Scheduled'),
(2, 'Midterm SE', 8, '2026-03-16', '14:00', '16:00', 'MCQ', 'Scheduled');
GO

-- ======================================
-- ExamRoom
-- ======================================
INSERT INTO [dbo].[ExamRoom] ([ExamID], [RoomID], [E_Date], [E_Time])
VALUES
(1, 1, '2026-03-15', '10:00'),
(2, 2, '2026-03-16', '14:00');
GO

-- ======================================
-- ProctoringEvent
-- ======================================
INSERT INTO [dbo].[ProctoringEvent] ([EX_ID], [S_ID], [EventType])
VALUES
(1, 1, 'Voice'),
(1, 2, 'Camera'),
(2, 1, 'Screen');
GO

-- ======================================
-- VoiceMonitoring
-- ======================================
INSERT INTO [dbo].[VoiceMonitoring] ([EventID], [Transcript])
VALUES
(1, 'Student speaking detected'),
(1, 'Background noise detected');
GO

-- ======================================
-- ScreenMonitoring
-- ======================================
INSERT INTO [dbo].[ScreenMonitoring] ([EventID], [ActionType], [EvidanceImage])
VALUES
(3, 'Switched window', 0x0),
(3, 'Opened prohibited app', 0x0);
GO

-- ======================================
-- CameraMonitoring
-- ======================================
INSERT INTO [dbo].[CameraMonitoring] ([EventID], [IsStudentPresent], [description], [ImageEvidence])
VALUES
(2, 1, 'Student present', 'image1.jpg'),
(2, 0, 'Student left camera view', 'image2.jpg');
GO
