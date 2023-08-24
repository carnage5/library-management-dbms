# Importing pakages
import streamlit as st
from query import inputquery
from create import create
from view import view
from delete import delete
from update import update

def submenucall(table):
    submenu=["add","view","update","delete"]
    choice = st.sidebar.selectbox("crud ", submenu)
    if choice == "view":
        st.subheader("View ")
        view(table)
    elif choice == "add":
        st.subheader("Add")
        create(table)
    elif choice == "update":
        st.subheader("Update")
        update(table)
    elif choice == "delete":
        st.subheader("Delete")
        delete(table)
    

def main():
    st.title("Library Management System")
    menu = ["select","query","student", "library", "librarian", "publisher","book","added","borrows returns","student phone no","librarian phone no"]
    submenu=["add","read","update","delete"]
    choice = st.sidebar.selectbox("Menu", menu)
    # create_table()
    if choice == "select":
        st.subheader("General Information")
        st.text("Select an option from the drop down menu to perform \ncrud operations on any selected table")
        st.text("Click Query to enter a query to perform operations on db")
        st.text("Abishek Deivam , PES1UG20CS012")
    elif choice=="query":
        st.subheader("Enter query")
        inputquery()
    elif choice == "student":
        st.subheader("student table")
        submenucall(choice)
    elif choice == "library":
        st.subheader("library table")
        submenucall(choice)
    elif choice == "librarian":
        st.subheader("librarian table")
        submenucall(choice)
    elif choice == "publisher":
        st.subheader("publisher table")
        submenucall(choice)
    elif choice == "book":
        st.subheader("book table")
        submenucall(choice)

    elif choice == "added":
        st.subheader("added table")
        submenucall(choice)
    elif choice == "borrows returns":
        st.subheader("borrow returns table")
        submenucall(choice)

    elif choice == "student phone no":
        st.subheader("student phone number table")
        submenucall(choice)

    elif choice == "librarian phone no":
        st.subheader("librarian phone number table")
        submenucall(choice)

    else:
        st.subheader("invalid")


if __name__ == '__main__':
    main()