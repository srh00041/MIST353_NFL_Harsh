from get_db_connection import get_db_connection
import pymssql

def get_all_stadiums():
    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)
    cursor.callproc("procGetAllStadiums")
    rows = cursor.fetchall()
    conn.close()

    #Convert pymssql.Row objects to dicts
    results = [
        {
            "StadiumID": row["StadiumID"],
            "StadiumName": row["StadiumName"]
        }
        for row in rows
    ]

    return {"data": results}