# Books.py
from db_connection import db_connection
from mysql.connector import Error

class Book:
    def __init__(self):
        self.conn = db_connection.get_connection()
    
    def create(self, book_id, title, author_id, category, price):
        try:
            cursor = self.conn.cursor()
            query = """INSERT INTO Books 
                      (Book_ID, Title, Author_ID, Category, Price) 
                      VALUES (%s, %s, %s, %s, %s)"""
            cursor.execute(query, (book_id, title, author_id, category, price))
            self.conn.commit()
            print("Book added successfully")
            return True
        except Error as e:
            print(f"Error adding book: {e}")
            return False
    
    def read(self):
        try:
            cursor = self.conn.cursor(dictionary=True)
            query = """SELECT b.*, a.Author_Name 
                      FROM Books b JOIN Authors a ON b.Author_ID = a.Author_ID"""
            cursor.execute(query)
            books = cursor.fetchall()
            print("\n📚 Books List:")
            for book in books:
                print(f"ID: {book['Book_ID']}, Title: {book['Title']}, Author: {book['Author_Name']}, Price: ${book['Price']}")
            return books
        except Error as e:
            print(f"Error reading books: {e}")
            return []
    
    def update(self, book_id, **kwargs):
        try:
            cursor = self.conn.cursor()
            set_clause = ", ".join([f"{k} = %s" for k in kwargs])
            query = f"UPDATE Books SET {set_clause} WHERE Book_ID = %s"
            values = list(kwargs.values()) + [book_id]
            cursor.execute(query, values)
            self.conn.commit()
            print("Book updated successfully")
            return True
        except Error as e:
            print(f"Error updating book: {e}")
            return False
    
    def delete(self, book_id):
        try:
            cursor = self.conn.cursor()
            query = "DELETE FROM Books WHERE Book_ID = %s"
            cursor.execute(query, (book_id,))
            self.conn.commit()
            print("Book deleted successfully")
            return True
        except Error as e:
            print(f"Error deleting book: {e}")
            return False

def book_menu():
    book = Book()
    while True:
        print("\n📖 BOOK MENU")
        print("1. Add Book")
        print("2. View Books")
        print("3. Update Book")
        print("4. Delete Book")
        print("5. Exit")
        
        choice = input("Enter your choice (1-5): ")
        
        if choice == '1':
            book_id = input("Enter Book ID: ")
            title = input("Enter Title: ")
            author_id = input("Enter Author ID: ")
            category = input("Enter Category: ")
            price = float(input("Enter Price: "))
            book.create(book_id, title, author_id, category, price)
        
        elif choice == '2':
            book.read()
        
        elif choice == '3':
            book_id = input("Enter Book ID to update: ")
            print("Enter new values (leave blank to keep current):")
            title = input("Title: ")
            author_id = input("Author ID: ")
            category = input("Category: ")
            price = input("Price: ")
            
            updates = {}
            if title: updates['Title'] = title
            if author_id: updates['Author_ID'] = author_id
            if category: updates['Category'] = category
            if price: updates['Price'] = float(price)
            
            if updates:
                book.update(book_id, **updates)
            else:
                print("No updates provided")
        
        elif choice == '4':
            book_id = input("Enter Book ID to delete: ")
            book.delete(book_id)
        
        elif choice == '5':
            print("Exiting Book Menu...")
            break
        
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    book_menu()