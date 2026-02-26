-- 3 queries
--1 for each conference division and team tables and 1 join query
use MIST353_NFL_RDB_Harsh;

--show all divisions that are in the AFC conference
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
group by C.Conference, C.Division;

GO

create or alter PROCEDURE procGetTeamsByConferenceDivision
(
@ConferenceName NVARCHAR(50) = null,
@DivisionName NVARCHAR(50) = null
)
AS
begin
select T.TeamName, T.TeamColors, C.Conference, C.Division
from Team as T inner join ConferenceDivision as C
on T.ConferenceDivisionID = C.ConferenceDivisionID
where Conference = IsNull(@ConferenceName, Conference) and Division = IsNull(@DivisionName, Division)
end

GO

create or alter PROCEDURE procGetTeamsByConferenceDivision
(
@ConferenceName NVARCHAR(50) = null,
@DivisionName NVARCHAR(50) = null
@TeamName NVARCHAR(50) = null
)
AS
begin
select T.TeamName, T.TeamColors, C.Conference, C.Division
from Team as T inner join ConferenceDivision as C
    on T.ConferenceDivisionID = C.ConferenceDivisionID
where C.Conference = IsNull(@ConferenceName, C.Conference) 
    and Division = IsNull(@DivisionName, Division)
    and (@TeamName is null or T.ConferenceDivisionID = 
    (select ConferenceDivisionID from Team where TeamName = @TeamName))
end