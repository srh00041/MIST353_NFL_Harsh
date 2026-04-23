from get_db_connection import get_db_connection
import pymssql

def validate_user(
        email: str, 
        password_hash: str
    ):
    conn = get_db_connection()
    #cursor = conn.cursor()
    cursor = conn.cursor(as_dict=True)
    #cursor.execute("{call procValidateUser(?, ?)}", (email, password_hash))
    cursor.callproc("procValidateUser", (email, password_hash))
    rows = cursor.fetchall()
    conn.close()

    #covert pyodbc. row objects to dictionaries
    results = [
        {
            #"AppUserID": row.AppUserID,
            #"FullName": row.FullName,
            #"UserRole": row.UserRole

            "AppUserID": row["AppUserID"],
            "FullName": row["FullName"],
            "UserRole": row["UserRole"]
        }
        for row in rows
    ]

    return {"data": results}