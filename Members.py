# Members.py
from db_connection import db_connection
from mysql.connector import Error
from datetime import datetime

class Member:
    def __init__(self):
        self.conn = db_connection.get_connection()
    
    def create(self, member_id, member_name, doj=None):
        try:
            cursor = self.conn.cursor()
            doj = doj or datetime.now().date()
            query = "INSERT INTO Members (Member_ID, Member_Name, DOJ) VALUES (%s, %s, %s)"
            cursor.execute(query, (member_id, member_name, doj))
            self.conn.commit()
            print("Member added successfully")
            return True
        except Error as e:
            print(f"Error adding member: {e}")
            return False
    
    def read(self):
        try:
            cursor = self.conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM Members")
            members = cursor.fetchall()
            print("\n👥 Members List:")
            for member in members:
                print(f"ID: {member['Member_ID']}, Name: {member['Member_Name']}, Joined: {member['DOJ']}")
            return members
        except Error as e:
            print(f"Error reading members: {e}")
            return []
    
    def update(self, member_id, **kwargs):
        try:
            cursor = self.conn.cursor()
            set_clause = ", ".join([f"{k} = %s" for k in kwargs])
            query = f"UPDATE Members SET {set_clause} WHERE Member_ID = %s"
            values = list(kwargs.values()) + [member_id]
            cursor.execute(query, values)
            self.conn.commit()
            print("Member updated successfully")
            return True
        except Error as e:
            print(f"Error updating member: {e}")
            return False
    
    def delete(self, member_id):
        try:
            cursor = self.conn.cursor()
            query = "DELETE FROM Members WHERE Member_ID = %s"
            cursor.execute(query, (member_id,))
            self.conn.commit()
            print("Member deleted successfully")
            return True
        except Error as e:
            print(f"Error deleting member: {e}")
            return False

def member_menu():
    member = Member()
    while True:
        print("\n👥 MEMBER MENU")
        print("1. Add Member")
        print("2. View Members")
        print("3. Update Member")
        print("4. Delete Member")
        print("5. Exit")
        
        choice = input("Enter your choice (1-5): ")
        
        if choice == '1':
            member_id = input("Enter Member ID: ")
            member_name = input("Enter Member Name: ")
            member.create(member_id, member_name)
        
        elif choice == '2':
            member.read()
        
        elif choice == '3':
            member_id = input("Enter Member ID to update: ")
            print("Enter new values (leave blank to keep current):")
            member_name = input("Name: ")
            doj = input("Date of Joining (YYYY-MM-DD): ")
            
            updates = {}
            if member_name: updates['Member_Name'] = member_name
            if doj: updates['DOJ'] = doj
            
            if updates:
                member.update(member_id, **updates)
            else:
                print("No updates provided")
        
        elif choice == '4':
            member_id = input("Enter Member ID to delete: ")
            member.delete(member_id)
        
        elif choice == '5':
            print("Exiting Member Menu...")
            break
        
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    member_menu()