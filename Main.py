# main.py
from Authors import author_menu
from Books import book_menu
from Members import member_menu
from Borrowing import borrowing_menu

def main_menu():
    while True:
        print("\n 🏛️  LIBRARY MANAGEMENT SYSTEM")
        print("1. Authors")
        print("2. Books")
        print("3. Members")
        print("4. Borrowings")
        print("5. Exit System")
        
        choice = input("Enter your choice (1-5): ")
        
        if choice == '1':
            author_menu()
        elif choice == '2':
            book_menu()
        elif choice == '3':
            member_menu()
        elif choice == '4':
            borrowing_menu()
        elif choice == '5':
            print("Exiting Library Management System...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main_menu()