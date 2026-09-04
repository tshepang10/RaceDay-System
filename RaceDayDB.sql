CREATE DATABASE RaceDayDB;
GO

USE RaceDayDB;
GO

-- Drop tables in dependency order so the script can be rerun during development.
IF OBJECT_ID('dbo.Result', 'U') IS NOT NULL DROP TABLE dbo.Result;
IF OBJECT_ID('dbo.Enrolment', 'U') IS NOT NULL DROP TABLE dbo.Enrolment;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID('dbo.Event', 'U') IS NOT NULL DROP TABLE dbo.Event;
IF OBJECT_ID('dbo.Participant', 'U') IS NOT NULL DROP TABLE dbo.Participant;
IF OBJECT_ID('dbo.Organiser', 'U') IS NOT NULL DROP TABLE dbo.Organiser;
GO

CREATE TABLE Organiser (
    OrganiserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE Participant (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NULL,
    DateOfBirth DATE NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);
GO

CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    EventName VARCHAR(150) NOT NULL,
    Description VARCHAR(500) NULL,
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    Location VARCHAR(200) NOT NULL,
    DistanceKm DECIMAL(6,2) NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Upcoming',
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Event_Organiser
        FOREIGN KEY (OrganiserID) REFERENCES Organiser(OrganiserID),
    CONSTRAINT CK_Event_Distance
        CHECK (DistanceKm IS NULL OR DistanceKm > 0),
    CONSTRAINT CK_Event_Status
        CHECK (Status IN ('Draft','Upcoming','Completed','Cancelled'))
);
GO

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(6,2) NULL,
    MaximumParticipants INT NULL,
    EntryFee DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT FK_Category_Event
        FOREIGN KEY (EventID) REFERENCES Event(EventID),
    CONSTRAINT UQ_Category_Event_Name
        UNIQUE (EventID, CategoryName),
    CONSTRAINT CK_Category_Distance
        CHECK (DistanceKm IS NULL OR DistanceKm > 0),
    CONSTRAINT CK_Category_MaxParticipants
        CHECK (MaximumParticipants IS NULL OR MaximumParticipants > 0),
    CONSTRAINT CK_Category_EntryFee
        CHECK (EntryFee >= 0)
);
GO

CREATE TABLE Enrolment (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    Status VARCHAR(20) NOT NULL DEFAULT 'Confirmed',
    BibNumber VARCHAR(20) NULL,
    CONSTRAINT FK_Enrolment_Participant
        FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID),
    CONSTRAINT FK_Enrolment_Category
        FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID),
    CONSTRAINT UQ_Enrolment_Participant_Category
        UNIQUE (ParticipantID, CategoryID),
    CONSTRAINT UQ_Enrolment_Bib
        UNIQUE (BibNumber),
    CONSTRAINT CK_Enrolment_Status
        CHECK (Status IN ('Pending','Confirmed','Cancelled'))
);
GO

CREATE TABLE Result (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NULL,
    FinishPosition INT NULL,
    ResultStatus VARCHAR(20) NOT NULL DEFAULT 'Finished',
    RecordedAt DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Result_Enrolment
        FOREIGN KEY (EnrolmentID) REFERENCES Enrolment(EnrolmentID),
    CONSTRAINT CK_Result_Position
        CHECK (FinishPosition IS NULL OR FinishPosition > 0),
    CONSTRAINT CK_Result_Status
        CHECK (ResultStatus IN ('Finished','DNF','DNS','Disqualified'))
);
GO

-- Seed data: 2 organisers, 2 participants, 3 events,
-- categories for every event, sample enrolments and results.
INSERT INTO Organiser (FirstName, LastName, Email, PasswordHash, Phone)
VALUES
('Thabo', 'Mokoena', 'thabo.mokoena@example.com', 'HASHED_PASSWORD_1', '0821111111'),
('Lerato', 'Nkosi', 'lerato.nkosi@example.com', 'HASHED_PASSWORD_2', '0832222222');
GO

INSERT INTO Participant (FirstName, LastName, Email, PasswordHash, Phone, DateOfBirth)
VALUES
('Sipho', 'Dlamini', 'sipho.dlamini@example.com', 'HASHED_PASSWORD_3', '0843333333', '1999-05-14'),
('Amahle', 'Khumalo', 'amahle.khumalo@example.com', 'HASHED_PASSWORD_4', '0854444444', '2001-09-22');
GO

INSERT INTO Event
    (OrganiserID, EventName, Description, EventDate, StartTime, Location, DistanceKm, Status)
VALUES
(1, 'Mbombela City Run', 'Road running event for the local community.',
 '2026-10-18', '07:00', 'Mbombela Stadium', 21.10, 'Upcoming'),
(1, 'Lowveld Charity Walk', 'Community walk supporting local charities.',
 '2026-11-08', '08:00', 'Riverside Park', 10.00, 'Upcoming'),
(2, 'White River Cycle Challenge', 'Road cycling event through the Lowveld.',
 '2026-11-22', '06:30', 'White River Town Centre', 50.00, 'Upcoming');
GO

INSERT INTO Category (EventID, CategoryName, DistanceKm, MaximumParticipants, EntryFee)
VALUES
(1, 'Half Marathon', 21.10, 500, 250.00),
(1, '10 KM Run', 10.00, 700, 180.00),
(2, '10 KM Walk', 10.00, 400, 100.00),
(2, '5 KM Family Walk', 5.00, 600, 60.00),
(3, '50 KM Challenge', 50.00, 300, 350.00),
(3, '20 KM Social Ride', 20.00, 500, 180.00);
GO

INSERT INTO Enrolment (ParticipantID, CategoryID, Status, BibNumber)
VALUES
(1, 1, 'Confirmed', 'MR001'),
(1, 4, 'Confirmed', 'LW001'),
(2, 2, 'Confirmed', 'MR002'),
(2, 5, 'Confirmed', 'WC001');
GO

INSERT INTO Result (EnrolmentID, FinishTime, FinishPosition, ResultStatus)
VALUES
(1, '01:48:32', 12, 'Finished'),
(2, '00:58:41', 8, 'Finished'),
(3, '00:52:19', 21, 'Finished');
GO

-- Basic verification queries.
SELECT * FROM Organiser;
SELECT * FROM Participant;
SELECT * FROM Event;
SELECT * FROM Category;
SELECT * FROM Enrolment;
SELECT * FROM Result;
GO
