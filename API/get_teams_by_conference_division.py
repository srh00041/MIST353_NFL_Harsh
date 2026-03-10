from get_db_connection import get_db_connection

def get_teams_by_conference_division(conference, division):
    conn = conn.cursor()
    cursor = conn.cursor()
    cursor.execute("EXEC proGetTeamsByConferenceDivision @ConferenceName=?. @DivisionName=?", conference, division)
    teams = cursor.fetchall()
    conn.close()
    return teams