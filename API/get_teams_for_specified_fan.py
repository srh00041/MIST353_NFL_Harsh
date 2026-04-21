from get_db_connection import get_db_connection
import pymssql

def get_teams_for_specified_fan(
    nfl_fan_id: int
):
    conn = get_db_connection()
    #cursor = conn.cursor()
    cursor = conn.cursor(as_dict=True)
    #cursor.execute("{call procGetTeamsForSpecifiedFan(?)}", (nfl_fan_id))
    cursor.execute("exec procGetTeamsForSpecifiedFan %s", (nfl_fan_id))
    rows = cursor.fetchall()
    conn.close()

    results = [
    {
        """"TeamName": row.TeamName,
        "Conference": row.Conference,
        "Division": row.Division"""

        "TeamName": row["TeamName"],
        "Conference": row["Conference"],
        "Division": row["Division"]
    }
    for row in rows
]

    
    return {"data": results}