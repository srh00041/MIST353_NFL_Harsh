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
