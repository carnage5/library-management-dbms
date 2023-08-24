import mysql.connector
import streamlit as st
import pandas as pd
mydb = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="library_management_system"
)
c = mydb.cursor()

def sendquery(query):
    c.execute(query)
    if query[0:6]=="SELECT":
        data=c.fetchall()
        st.dataframe(data)
        

def insert_data(*fields):
    if fields[0]=="student":
        c.execute("INSERT INTO student VALUES (%s,%s,%s,%s)",(fields[1],fields[2],fields[3],fields[4]))
        mydb.commit()
    elif fields[0]=="library":
        c.execute("INSERT INTO library VALUES (%s,%s,%s)",(fields[1],fields[2],fields[3]))
        mydb.commit()
    elif fields[0]=="librarian":
        c.execute("INSERT INTO librarian VALUES (%s,%s,%s,%s,%s)",(fields[1],fields[2],fields[3],fields[4],fields[5]))
        mydb.commit()
    elif fields[0]=="publisher":
        c.execute("INSERT INTO publisher VALUES (%s,%s,%s)",(fields[1],fields[2],fields[3]))
        mydb.commit()
    elif fields[0]=="book":
        c.execute("INSERT INTO book VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s)",(fields[1],fields[2],fields[3],fields[4],fields[5],fields[6],fields[7],fields[8],fields[9]))
        mydb.commit()
    elif fields[0]=="added":
        c.execute("INSERT INTO added VALUES (%s,%s,%s)",(fields[1],fields[2],fields[3]))
        mydb.commit()
    elif fields[0]=="borrows returns":
        c.execute("INSERT INTO borrows_return VALUES (%s,%s,%s,%s,%s)",(fields[1],fields[2],fields[3],fields[4],fields[5]))
        mydb.commit()
    elif fields[0]=="student phone no":
        c.execute("INSERT INTO student_phone_no VALUES  (%s,%s)",(fields[1],fields[2]))
        mydb.commit()
    elif fields[0]=="librarian phone no":
        c.execute("INSERT INTO librarian_phone_no VALUES  (%s,%s)",(fields[1],fields[2]))
        mydb.commit()
def view_data(*fields):
    if fields[0]=="student":
        c.execute("SELECT * FROM student")
    elif fields[0]=="library":
        c.execute("SELECT * FROM library")
    elif fields[0]=="librarian":
        c.execute("SELECT * FROM librarian")
    elif fields[0]=="publisher":
        c.execute("SELECT * FROM publisher")
    elif fields[0]=="book":
        c.execute("SELECT * FROM book")
    elif fields[0]=="added":
        c.execute("SELECT * FROM added")
    elif fields[0]=="borrows returns":
        c.execute("SELECT * FROM borrows_return")
    elif fields[0]=="student phone no":
        c.execute("SELECT * FROM student_phone_no")
    elif fields[0]=="librarian phone no":
        c.execute("SELECT * FROM librarian_phone_no")
    data=c.fetchall()
    return data
def delete_data(*fields):
    if fields[0]=="student":
        c.execute('DELETE FROM student WHERE Student_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="library":
        c.execute('DELETE FROM library WHERE Lib_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="librarian":
        c.execute('DELETE FROM librarian WHERE Librarian_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="publisher":
        c.execute('DELETE FROM publisher WHERE Publisher_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="book":
        c.execute('DELETE FROM book WHERE Book_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="added":
        c.execute('DELETE FROM added WHERE  Book_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="borrows returns":
        c.execute('DELETE FROM borrows_return WHERE Book_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="student phone no":
        c.execute('DELETE FROM student_phone_no WHERE Student_id="{}"'.format(fields[1]))
        mydb.commit()
    elif fields[0]=="librarian phone no":
        c.execute('DELETE FROM librarian_phone_no WHERE Librarian_id="{}"'.format(fields[1]))
        mydb.commit()
def update_data(*fields):
    if fields[0]=="student":
        c.execute('SELECT * FROM student WHERE Student_id ="{}"'.format(fields[4]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE student SET fname = %s , lname = %s , email = %s WHERE Student_id = %s',(temp[0],temp[1],temp[2],temp[3]))
        mydb.commit()
    elif fields[0]=="library":
        c.execute('SELECT * FROM library WHERE Lib_id ="{}"'.format(fields[1]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE library SET Lib_name = %s , Location = %s WHERE Lib_id = %s ',(temp[1],temp[2],temp[0]))
        mydb.commit()     
    elif fields[0]=="librarian":
        c.execute('SELECT * FROM librarian WHERE Librarian_id ="{}"'.format(fields[1]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE librarian SET fname = %s , lname = %s , email = %s , Lib_id = %s WHERE Librarian_id = %s ',(temp[1],temp[2],temp[3],temp[4],temp[0]))
        mydb.commit()   
    elif fields[0]=="publisher":
        c.execute('SELECT * FROM publisher WHERE Publisher_id ="{}"'.format(fields[1]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE Publisher SET publisher_name = %s , publisher_address = %s WHERE Publisher_id = %s ',(temp[1],temp[2],temp[0]))
        mydb.commit()
    elif fields[0]=="book":
        c.execute('SELECT * FROM book WHERE Book_id ="{}"'.format(fields[2]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE book SET book_name = %s , author_fname = %s , author_lname = %s , genre = %s , isbn = %s , edition = %s , Librarian_id = %s , Publisher_id=%s  WHERE Book_id = %s ',(temp[0],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[1]))
        mydb.commit()
    elif fields[0]=="added":
        c.execute('SELECT * FROM added WHERE Book_id ="{}"'.format(fields[2]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(str(fields[i]))>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE added SET Date_of_addition = %s , Lib_id = %s WHERE Book_id = %s ',(temp[0],temp[2],temp[1]))
        mydb.commit()
    elif fields[0]=="borrows returns":
        c.execute('SELECT * FROM borrows_return WHERE Book_id ="{}"'.format(fields[4]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(str(fields[i]))>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE borrows_return SET issue_date = %s , return_date = %s , due_date = %s , Student_id= %s  WHERE Book_id = %s ',(temp[0],temp[1],temp[2],temp[3],temp[4]))
        mydb.commit()
    elif fields[0]=="student phone no":
        c.execute('SELECT * FROM student_phone_no WHERE Student_id ="{}"'.format(fields[2]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE student SET phone_no = %s WHERE Student_id = %s',(temp[0],temp[1]))
        mydb.commit()
    elif fields[0]=="librarian phone no":
        c.execute('SELECT * FROM librarian_phone_no WHERE Librarian_id ="{}"'.format(fields[2]))
        data=c.fetchone()
        temp=list(data)
        for i in range(1,len(fields)):
            if(len(fields[i])>0):
                temp[i-1]=fields[i]
        c.execute('UPDATE student SET phone_no = %s WHERE Librarian_id = %s',(temp[0],temp[1]))
        mydb.commit()
