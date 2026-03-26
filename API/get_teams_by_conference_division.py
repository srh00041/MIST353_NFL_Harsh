from get_db_connection import get_db_connection

def get_teams_by_conference_division(
        conference: str = None, 
        division: str = None
    ):
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("{call proGetTeamsByConferenceDivision(?, ?)}", (conference, division))
    rows = cursor.fetchall()
    conn.close()

    #covert pyodbc. row objects to dictionaries
    results = [
        {
            "TeamName": row.TeamName,
            "Conference": row.Conference,
            "Division": row.Division,
            "TeamColors": row.TeamColors
        }
        for row in rows
    ]

    return {"data": results}