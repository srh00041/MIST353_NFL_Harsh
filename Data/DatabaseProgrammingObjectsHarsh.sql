-- 3 queries
--1 for each conference division and team tables and 1 join query
--use MIST353_NFL_RDB_Harsh;

use[mist353-nfl-harsh];

/*--show all divisions that are in the AFC conference
select ConferenceDivisionID, Conference, Division
from ConferenceDivision
where Conference = 'AFC'
order by ConferenceDivisionID;

--show all the teams that are located in new jersy
select TeamName, TeamCityState, TeamColors
from Team
where TeamCityState LIKE '%, Nj'
order by TeamID;

-- counts how many teams are in each conference and division
select C.Conference, C.Division, COUNT(T.TeamID) as 'Number of Teams'
from ConferenceDivision as C
inner join Team as T on C.ConferenceDivisionID = T.ConferenceDivisionID
group by C.Conference, C.Division;*/

GO

create or alter PROCEDURE procGetTeamsByConferenceDivision
(
    @ConferenceName NVARCHAR(50) = null,
    @DivisionName NVARCHAR(50) = null
)
AS
begin
    select T.TeamName, T.TeamColors, C.Conference, C.Division
    from Team T inner join ConferenceDivision C
        on T.ConferenceDivisionID = C.ConferenceDivisionID
    where Conference = IsNull(@ConferenceName, Conference) 
        and Division = IsNull(@DivisionName, Division)
end

GO
/*execute procGetTeamsByConferenceDivision
    @ConferenceName = 'AFC',
    @DivisionName = 'North';*/


create or alter procedure procGetTeamsInSameConferenceDivisionAsSpecifiedTeam
(
    @TeamName NVARCHAR(50)   
)
AS
BEGIN
    SELECT OtherTeam.TeamName, CD.Conference, CD.Division
FROM Team MyTeam INNER JOIN Team OtherTeam
    ON MyTeam.ConferenceDivisionID = OtherTeam.ConferenceDivisionID
INNER JOIN ConferenceDivision CD
    ON MyTeam.ConferenceDivisionID = CD.ConferenceDivisionID
WHERE 
    MyTeam.TeamName = @TeamName
    AND OtherTeam.TeamName != @TeamName;
END
--EXECUTE procGetTeamsInSameConferenceDivisionAsSpecifiedTeamTeam @TeamName = 'Baltimore Ravens'


GO

create or alter procedure procValidateUser
(
    @Email NVARCHAR(100),
    @PasswordHash NVARCHAR(200)
)
AS
BEGIN
    select AppUserID, FirstName + ' ' + LastName as FullName, UserRole
    from AppUser
    where Email = @Email AND
    PasswordHash = convert(VARBINARY(200), @PasswordHash, 1);
END
-- execute procValidateUser @Email = 'tom.brady@example.com', @PasswordHash = '0x01';

GO

create or alter procedure procGetTeamsForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    SELECT 
        T.TeamName, CD.Conference, CD.Division, T.TeamColors
    FROM NFLFan F
        INNER JOIN Team T
            ON F.NFLFanID = T.TeamID
        INNER JOIN ConferenceDivision CD
            ON T.ConferenceDivisionID = CD.ConferenceDivisionID
    WHERE F.NFLFanID = @NFLFanID;
END;
-- execute procGetTeamsForSpecifiedFan @NFLFanID = 1;
-- execute procGetTeamsForSpecifiedFan @NFLFanID = 2;

go

/*create or alter procedure procGetTeamsByFanID
(
    @NFLFanID INT
)
AS
BEGIN
    SELECT 
        T.TeamName, CD.Conference, CD.Division, T.TeamColors
    FROM NFLFan F
        INNER JOIN Team T
            ON F.NFLFanID = T.TeamID
        INNER JOIN ConferenceDivision CD
            ON T.ConferenceDivisionID = CD.ConferenceDivisionID
    WHERE F.NFLFanID = @NFLFanID;
END;*/

create or alter procedure procScheduleGame
(
    @HomeTeamID INT,
    @AwayTeamID INT,
    @GameRound NVARCHAR(20),
    @GameDate Date,
    @GameStartTime Time,
    @StadiumID INT,
    @NFLAdminID INT
)
AS
BEGIN
    declare @contect VARBINARY(128) = cast(@NFLAdminID as VARBINARY(128));
    SET context_info @contect;

    INSERT INTO Game (HomeTeamID, AwayTeamID, GameRound, GameDate, GameStartTime, StadiumID, NFLAdminID)
    VALUES (@HomeTeamID, @AwayTeamID, @GameRound, @GameDate, @GameStartTime, @StadiumID, @NFLAdminID);
END;

/*
execute procScheduleGame
    @HomeTeamID = 22,
    @AwayTeamID = 30,
    @GameRound = 'Wild Card',
    @GameDate = '2026-01-10',
    @GameStartTime = '16:30',
    @StadiumID = 22,
    @NFLAdminID = 5;

execute procScheduleGame
    @HomeTeamID = 17,
    @AwayTeamID = 19,  
    @GameRound = 'Wild Card',
    @GameDate = '2026-01-10',
    @GameStartTime = '20:00',
    @StadiumID = 17,
    @NFLAdminID = 6;

execute procScheduleGame
    @HomeTeamID = 13, -- Denver Broncos
    @AwayTeamID = 11, -- New England Patriots
    @GameRound = 'Conference',
    @GameDate = '2026-01-25',
    @GameStartTime = '15:00',
    @StadiumID = 13, -- Empower Field at Mile High
    @NFLAdminID = 5; -- Bill Belichick


    @GameID = 11, 
    @HomeTeamScore = 7,
    @AwayTeamScore = 10,
    @NFLAdminID = 6; -- Sean McVay

   

    select * from Game order by GameID desc;
    select * from AdminChangesTracker order by AdminChangesTrackerID desc;
*/


go

create or alter trigger trgTrackChangesOnSchedulingGame
ON Game
AFTER INSERT
AS
BEGIN
    declare @NFLAdminID INT;
    declare @GameID INT;
    declare @ChangeType NVARCHAR(50);
    declare @ChangeDescription NVARCHAR(500);
    declare @GameRound NVARCHAR(50);
    declare @GameDate DATE;
    declare @GameStartTime TIME;
    declare @HomeTeamID INT;
    declare @AwayTeamID INT;
    declare @HomeTeamName NVARCHAR(50);
    declare @AwayTeamName NVARCHAR(50);

    set @NFLAdminID = convert(int, convert(binary(4), context_info()));

    select @GameID = GameID, @GameRound = GameRound, @GameDate = GameDate, @GameStartTime = GameStartTime, 
        @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID, @StadiumID = StadiumID
    from inserted;
    select @HomeTeamName = TeamName from Team where TeamID = @HomeTeamID;
    select @AwayTeamName = TeamName from Team where TeamID = @AwayTeamID;
    select @StadiumName = StadiumName from Stadium where StadiumID = @StadiumID;

    set @ChangeType = 'Insert';
    set @ChangeDescription = 'Scheduled a new game with GameID ' + cast(@GameID as nvarchar(10))
         + ': ' + @HomeTeamName + ' vs ' + @AwayTeamName + ' on ' + cast(@GameDate as nvarchar(20))
        + ' at ' + cast(@GameStartTime as nvarchar(50)) + ' in stadium ' + @StadiumName
        + '. Game round: ' + @GameRound;
    
    set @ChangeType = 'Insert';
    set @ChangeDescription = 'Scheduled a new game with GameID ' + cast(@GameID as nvarchar(50))
         + ': ' + @HomeTeamName + ' vs ' + @AwayTeamName + ' on ' + cast(@GameDate as nvarchar(50))
        + ' at ' + cast(@GameStartTime as nvarchar(50)) + ' in stadium ' + @StadiumName
        + '. Game round: ' + @GameRound;

    INSERT INTO AdminChangesTracker (NFLAdminID, GameID, ChangeType, ChangeDescription)
    VALUES (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
END

go

create or alter procedure procEnterScores
(
    @GameID INT,
    @HomeTeamScore INT,
    @AwayTeamScore INT,
    @NFLAdminID INT
)



go

create or alter trigger trgTrackChangesOnEnteringScores
on Game
after update
as
begin
    declare @NFLAdminID INT;
    declare @GameID INT;
    declare @ChangeType NVARCHAR(50);
    declare @ChangeDescription NVARCHAR(500);
    declare @HomeTeamScore INT;
    declare @AwayTeamScore INT;
    declare @WinningTeamID INT;
    declare @HomeTeamID INT;
    declare @AwayTeamID INT;
    declare @HomeTeamName NVARCHAR(50);
    declare @AwayTeamName NVARCHAR(50);

    set @NFLAdminID = convert(int, convert(binary(4), context_info()));

    select @GameID = GameID, @HomeTeamScore = HomeTeamScore, @AwayTeamScore = AwayTeamScore,
        @WinningTeamID = WinningTeamID, @HomeTeamID = HomeTeamID, @AwayTeamID = AwayTeamID
    from inserted;

    select @HomeTeamName = TeamName from Team where TeamID = @HomeTeamID;
    select @AwayTeamName = TeamName from Team where TeamID = @AwayTeamID;

    set @ChangeType = 'Update';
    set @ChangeDescription = 'Scores updated by Admin with NFLAdminID=' + cast(@NFLAdminID as nvarchar(10))
        + ' for GameID=' + cast(@GameID as nvarchar(10)) + ': Home=' + @HomeTeamName + ' (' + cast(@HomeTeamScore as nvarchar(10)) + ')'
        + ', Away=' + @AwayTeamName + ' (' + cast(@AwayTeamScore as nvarchar(10)) + ')'
        + ', WinningTeam=' + case when @WinningTeamID is not null then (select TeamName from Team where TeamID = @WinningTeamID) else 'TBD' end;

    INSERT INTO AdminChangesTracker (NFLAdminID, GameID, ChangeType, ChangeDescription)
    VALUES (@NFLAdminID, @GameID, @ChangeType, @ChangeDescription);
END

--the trigger needs to delete the data and inserting data
--before next class - create trigger and insert info into stored procedures and trigger
go

create or alter procedure procGetAllChangesMadeBySpecifiedAdmin
(
    @NFLAdminID INT
)
as
begin
    select ACT.ChangeDateTime, ACT.ChangeType, ACT.ChangeDescription,
    G.GameRound, G.GameDate, G.GameStartTime,
    HT.TeamName as HomeTeam, AT.TeamName as AwayTeam, S.StadiumName
    from AdminChangesTracker ACT inner join Game G
        on ACT.GameID = G.GameID
        inner join Team HT
        on G.HomeTeamID = HT.TeamID
        inner join Team AT
        on G.AwayTeamID = AT.TeamID
        inner join Stadium S
        on G.StadiumID = S.StadiumID
    where ACT.NFLAdminID = @NFLAdminID
    order by ACT.ChangeDateTime desc;

end

go
-- execute procGetAllChangesMadeBySpecifiedAdmin @NFLAdminID = 5; -- Bill Belichick

-- To create dropdown lists for the NFLAdmin to select Teams and Stadiums to schedule games.

create or alter procedure procGetAllTeams
as
begin
    select TeamID, TeamName
    from Team
end
-- execute procGetAllTeams;

go

create or alter procedure procGetAllStadiums
as
begin
    select StadiumID, StadiumName
    from Stadium
end
-- execute procGetAllStadiums;

go

-- To get all changes made by a specified (logged in NFLAdmin).

create or alter procedure procGetAllChangesMadeBySpecifiedAdmin
(
    @NFLAdminID INT
)
as
begin
    select ACT.ChangeDateTime, ACT.ChangeType, ACT.ChangeDescription, 
    G.GameRound, G.GameDate, G.GameStartTime,
    HT.TeamName as HomeTeam, AT.TeamName as AwayTeam, S.StadiumName
    from AdminChangesTracker ACT inner join Game G
        on ACT.GameID = G.GameID
        inner join Team HT
        on G.HomeTeamID = HT.TeamID
        inner join Team AT
        on G.AwayTeamID = AT.TeamID
        inner join Stadium S
        on G.StadiumID = S.StadiumID
    where ACT.NFLAdminID = @NFLAdminID
    order by ACT.ChangeDateTime desc;
end

-- execute procGetAllChangesMadeBySpecifiedAdmin @NFLAdminID = 5; -- Bill Belichick
go

-- Disabling and enabling triggers on the Game table. When and Why?

-- disable trigger trgTrackChangesOnSchedulingGame on Game;
-- disable trigger all on Game;

-- enable trigger trgTrackChangesOnSchedulingGame on Game;
-- enable trigger all on Game;

go

-- Adding TeamLogo column to Team table and creating stored procedure to get teams with logos for a specified fan

alter table Team
add TeamLogo VARBINARY(MAX);

go

create or alter procedure procGetTeamsWithLogosForSpecifiedFan
(
    @NFLFanID INT
)
AS
BEGIN
    select T.TeamName, CD.Conference, CD.Division, T.TeamColors, FT.PrimaryTeam, T.TeamLogo
    from FanTeam FT inner join Team T
        on FT.TeamID = T.TeamID
        inner join ConferenceDivision CD
        on T.ConferenceDivisionID = CD.ConferenceDivisionID
    where FT.NFLFanID = @NFLFanID;
end;
-- execute procGetTeamsWithLogosForSpecifiedFan @NFLFanID = 1;

go