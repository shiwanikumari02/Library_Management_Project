# Borrowing.py
from db_connection import db_connection
from mysql.connector import Error
from datetime import datetime, timedelta

class Borrowing:
    def __init__(self):
        self.conn = db_connection.get_connection()
    
    def create(self, member_id, book_id, borrow_date=None, due_days=14):
        try:
            cursor = self.conn.cursor()
            borrow_date = borrow_date or datetime.now().date()
            due_date = borrow_date + timedelta(days=due_days)
            
            query = """INSERT INTO Borrowing 
                      (Member_ID, Book_ID, Borrow_Date, Return_Date) 
                      VALUES (%s, %s, %s, %s)"""
            cursor.execute(query, (member_id, book_id, borrow_date, None))
            self.conn.commit()
            print("Book borrowed successfully")
            return True
        except Error as e:
            print(f"Error borrowing book: {e}")
            return False
    
    def read(self):
        try:
            cursor = self.conn.cursor(dictionary=True)
            query = """SELECT br.*, m.Member_Name, b.Title 
                      FROM Borrowing br
                      JOIN Members m ON br.Member_ID = m.Member_ID
                      JOIN Books b ON br.Book_ID = b.Book_ID"""
            cursor.execute(query)
            borrowings = cursor.fetchall()
            print("\n📚 Borrowings List:")
            for borrow in borrowings:
                status = "Returned" if borrow['Return_Date'] else "Active"
                print(f"ID: {borrow['Borrow_ID']}, Member: {borrow['Member_Name']}, Book: {borrow['Title']}, Status: {status}")
            return borrowings
        except Error as e:
            print(f"Error reading borrowings: {e}")
            return []
    
    def update_return_date(self, borrow_id, return_date=None):
        try:
            cursor = self.conn.cursor()
            return_date = return_date or datetime.now().date()
            query = "UPDATE Borrowing SET Return_Date = %s WHERE Borrow_ID = %s"
            cursor.execute(query, (return_date, borrow_id))
            self.conn.commit()
            print("Return date updated successfully")
            return True
        except Error as e:
            print(f"Error updating return date: {e}")
            return False
    
    def delete(self, borrow_id):
        try:
            cursor = self.conn.cursor()
            query = "DELETE FROM Borrowing WHERE Borrow_ID = %s"
            cursor.execute(query, (borrow_id,))
            self.conn.commit()
            print("Borrowing record deleted successfully")
            return True
        except Error as e:
            print(f"Error deleting borrowing record: {e}")
            return False

def borrowing_menu():
    borrowing = Borrowing()
    while True:
        print("\n📚 BORROWING MENU")
        print("1. Borrow Book")
        print("2. View Borrowings")
        print("3. Return Book")
        print("4. Delete Borrowing Record")
        print("5. Exit")
        
        choice = input("Enter your choice (1-5): ")
        
        if choice == '1':
            member_id = input("Enter Member ID: ")
            book_id = input("Enter Book ID: ")
            borrowing.create(member_id, book_id)
        
        elif choice == '2':
            borrowing.read()
        
        elif choice == '3':
            borrow_id = input("Enter Borrow ID to return: ")
            borrowing.update_return_date(borrow_id)
        
        elif choice == '4':
            borrow_id = input("Enter Borrow ID to delete: ")
            borrowing.delete(borrow_id)
        
        elif choice == '5':
            print("Exiting Borrowing Menu...")
            break
        
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    borrowing_menu()