--create database for NFL app
--use master;
--CREATE DATABASE MIST353_NFL_RDB_Harsh;
--DROP database NFL_RDB_Harsh;

--create tables for first iteration
--use MIST353_NFL_RDB_Harsh;

use[mist353-nfl-harsh];



/*CREATE USER NandaSurendra

FOR LOGIN APILogin;

-- Step 4: Grant EXECUTE permission on all stored procedures and UDFs

GRANT EXECUTE TO NandaSurendra;

-- Read access to all tables

GRANT SELECT TO NandaSurendra;

create user 
for login APILogin



grant execute to APIUser;
grant select to APIUser;

use master;
create login APILogin
with PASSWORD = 'MI$T353Instructor';*/




if (OBJECT_ID('FanTeam') is not null)
    drop table FanTeam;
if (OBJECT_ID('NFLFan') is not null)
    drop table NFLFan;
if (OBJECT_ID('NFLAdmin') is not null)
    drop table NFLAdmin;
if(OBJECT_ID('Team') is not null)
    drop table Team;
if(OBJECT_ID('ConferenceDivision') is not null)
    drop table ConferenceDivision;
if (OBJECT_ID('AppUser') is not null)
    drop table AppUser;




go
create TABLE ConferenceDivision (
    ConferenceDivisionID INT identity(1,1)
        constraint PK_ConfeenceDivision PRIMARY KEY,
    Conference NVARCHAR(50) NOT NULL
        constraint CK_ConferenceNames CHECK (Conference IN ('AFC', 'NFC')),
    Division NVARCHAR(50) NOT NULL
        constraint CK_DivisionNames CHECK (Division IN ('East', 'North', 'South', 'West')),
    constraint UK_ConferenceDiVision UNIQUE (Conference, Division)
);
/*
alter table ConferenceDivision
    NOCHECK CONSTRAINT CK_ConferenceNames;

alter table ConferenceDivision
    CHECK CONSTRAINT CK_DivisionNames;
    */

go
create TABLE Team (
    TeamID INT identity(1,1)
        constraint PK_Team PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL,
    TeamCityState NVARCHAR(50) NOT NULL,
    TeamColors NVARCHAR(100) NOT NULL,
    ConferenceDivisionID INT NOT NULL  
        constraint FK_Team_ConferenceDivision FOREIGN KEY REFERENCES ConferenceDivision(ConferenceDivisionID)
);

GO
--create table for second iteration

create TABLE AppUser(
    AppUserID INT identity(1,1)
        constraint PK_AppUser PRIMARY KEY,
    FirstName NVARCHAR (50) NOT NULL,
    LastName NVARCHAR (50) NOT NULL,
    Email NVARCHAR(100) NOT NULL
        constraint UK_AppUserEmail UNIQUE,
    PasswordHash VARBINARY(200) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    UserRole NVARCHAR(20) NOT NULL
        constraint CK_AppUserRole CHECK (UserRole IN (N'NFLAdmin', N'NFLFan'))
    
);

GO

create table NFLFan(
    NFLFanID INT 
        constraint PK_NFLFan PRIMARY KEY
        constraint FK_NFLFan_AppUser FOREIGN KEY REFERENCES AppUser(AppUserID)
    
);

GO

create table NFLAdmin(
    NFLAdminID INT
        constraint PK_NFLAdmin PRIMARY KEY
        constraint FK_NFLAdmin_AppUser FOREIGN KEY REFERENCES AppUser(AppUserID)
);

GO

create table FanTeam(
    FanTeamID INT identity(1,1)
        constraint PK_FanTeam PRIMARY KEY,
    NFLFanID INT NOT NULL
        constraint FK_FanTeam_NFLFan FOREIGN KEY REFERENCES NFLFan(NFLFanID),
    TeamID INT NOT NULL
        constraint FK_FanTeam_Team FOREIGN KEY REFERENCES Team(TeamID),
        constraint UK_FanTeam UNIQUE (NFLFanID, TeamID),
    PrimaryTeam BIT NOT NULL
);