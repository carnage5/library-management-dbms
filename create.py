import streamlit as st
from db import insert_data
def create(table):
    col1, col2 = st.columns(2)
    if table=="student":
        with col1:
            fname = st.text_input("first name")
            email = st.text_input("email")
        with col2:
            lname = st.text_input("last name")
            studentid = st.text_input("student id")
        if st.button("Add student"):
            insert_data(table,fname,lname,email,studentid)
            st.success("succesfully inserted")
    elif table=="library":
        with col1:
            libid=st.text_input("library id")
            location=st.text_input("location")
        with col2:
            libname=st.text_input("library name")
        if st.button("add library"):
            insert_data(table,libid,libname,location)
            st.success("succesfully inserted")
    elif table=="librarian":
        with col1:
            fname = st.text_input("first name")
            email = st.text_input("email")
            libid=st.text_input("library id")
        with col2:
            lname = st.text_input("last name")
            librarianid = st.text_input("librarian id")
        if st.button("Add librarian"):
            insert_data(table,librarianid,fname,lname,email,libid)
            st.success("succesfully inserted")
    elif table=="publisher":
        with col1:
            pname=st.text_input("Publisher name")
            pid=st.text_input("publisher id")
        with col2:
            paddress=st.text_area("publisher address")
        if st.button("add publisher"):
            insert_data(table,pid,pname,paddress)
            st.success("succesfully inserted")
    elif table=="book":
        with col1:
            bname=st.text_input("book name")
            bafname=st.text_input("author fname")
            genre=st.text_input("genre")
            edition=st.text_input("edition")
            pubid=st.text_input("publisher id")
        with col2:
            bid=st.text_input("book id")
            balname=st.text_input("author lname")
            isbn=st.text_input("isbn")
            librarianid=st.text_input("librarian id")
        if st.button("add book"):
            insert_data(table,bname,bid,bafname,balname,genre,isbn,edition,librarianid,pubid)
            st.success("succesfully inserted")
    elif table=="added":
        with col1:
            bookid=st.text_input("book id")
            date=st.date_input("date of addition")
        with col2:
            libid=st.text_input("library id")
        if st.button("add book"):
            insert_data(table,date,bookid,libid)
            st.success("succesfully inserted")
    elif table=="borrows returns":
        with col1:
            bookid=st.text_input("book id")
            studentid=st.text_input("student id")
        with col2:
            issuedate=st.date_input("issue date")
            returndate=st.date_input("return date")
            duedate=st.date_input("due date")
        if st.button("add to borrows and returns"):
            insert_data(table,issuedate,returndate,duedate,studentid,bookid)
            st.success("succesfully inserted")
    elif table=="student phone no":
        with col1:
            studentid=st.text_input("student id")
        with col2:
            phno=st.text_input("phone no")
        if st.button("add number"):
            insert_data(table,phno,studentid)
            st.success("succesfully inserted")
    elif table=="librarian phone no":
        with col1:
            librarianid=st.text_input("librarian id")
        with col2:
            phno=st.text_input("phone no")
        if st.button("add number"):
            insert_data(table,phno,librarianid)
            st.success("succesfully inserted")