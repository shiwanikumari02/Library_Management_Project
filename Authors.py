# Authors.py
from db_connection import db_connection
from mysql.connector import Error

class Author:
    def __init__(self):
        self.conn = db_connection.get_connection()
    
    def create(self, author_id, author_name):
        try:
            cursor = self.conn.cursor()
            query = "INSERT INTO Authors (Author_ID, Author_Name) VALUES (%s, %s)"
            cursor.execute(query, (author_id, author_name))
            self.conn.commit()
            print("Author created successfully")
            return True
        except Error as e:
            print(f"Error creating author: {e}")
            return False
    
    def read(self):
        try:
            cursor = self.conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM Authors")
            authors = cursor.fetchall()
            print("\n📚 Authors List:")
            for author in authors:
                print(f"ID: {author['Author_ID']}, Name: {author['Author_Name']}")
            return authors
        except Error as e:
            print(f"Error reading authors: {e}")
            return []
    
    def update(self, author_id, new_name):
        try:
            cursor = self.conn.cursor()
            query = "UPDATE Authors SET Author_Name = %s WHERE Author_ID = %s"
            cursor.execute(query, (new_name, author_id))
            self.conn.commit()
            print("Author updated successfully")
            return True
        except Error as e:
            print(f"Error updating author: {e}")
            return False
    
    def delete(self, author_id):
        try:
            cursor = self.conn.cursor()
            query = "DELETE FROM Authors WHERE Author_ID = %s"
            cursor.execute(query, (author_id,))
            self.conn.commit()
            print("Author deleted successfully")
            return True
        except Error as e:
            print(f"Error deleting author: {e}")
            return False

def author_menu():
    author = Author()
    while True:
        print("\n📖 AUTHOR MENU")
        print("1. Add Author")
        print("2. View Authors")
        print("3. Update Author")
        print("4. Delete Author")
        print("5. Exit")
        
        choice = input("Enter your choice (1-5): ")
        
        if choice == '1':
            author_id = input("Enter Author ID: ")
            author_name = input("Enter Author Name: ")
            author.create(author_id, author_name)
        
        elif choice == '2':
            author.read()
        
        elif choice == '3':
            author_id = input("Enter Author ID to update: ")
            new_name = input("Enter new Author Name: ")
            author.update(author_id, new_name)
        
        elif choice == '4':
            author_id = input("Enter Author ID to delete: ")
            author.delete(author_id)
        
        elif choice == '5':
            print("Exiting Author Menu...")
            break
        
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    author_menu()