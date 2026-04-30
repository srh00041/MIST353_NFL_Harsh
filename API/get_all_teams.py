from get_db_connection import get_db_connection
import pymssql

def get_all_teams():
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.callproc("procGetAllTeams")
    rows = cursor.fetchall()
    conn.close()

    #Convert pymssql.Row objects to dicts
    results = [
        {
            "TeamID": row["TeamID"],
            "TeamName": row["TeamName"]
        }
        for row in rows
    ]

    return {"data": results}