# db_connection.py
# db_connection.py
import mysql.connector
from mysql.connector import Error

class DBConnection:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DBConnection, cls).__new__(cls)
            cls._instance.initialize_connection()
        return cls._instance
    
    def initialize_connection(self):
        self.host = '127.0.0.1'
        self.user = 'root'
        self.password = 'root'
        self.database = 'Library_Mgmt'
        self.port = 3306
        
    def get_connection(self):
        try:
            self.conn = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database,
                port=self.port,
                auth_plugin='mysql_native_password'
            )
            
            if self.conn.is_connected():
                print("Database connection established")
                return self.conn
            print("Connection failed")
            return None
        except Error as e:
            print(f"Connection error: {e}")
            return None

# Singleton instance
db_connection = DBConnection()

# Test the connection
if __name__ == "__main__":
    conn = db_connection.get_connection()
    if conn:
        print(f"Connected to {conn.database}")
        cursor = conn.cursor()
        cursor.execute("SHOW TABLES")
        print("Tables:", cursor.fetchall())
        cursor.close()
        conn.close()