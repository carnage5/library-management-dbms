import streamlit as st
import pandas as pd
from db import view_data
def view(table):
    result=view_data(table)

    # st.write(result)
    if table=="student":
        df=pd.DataFrame(result,columns=['fname','lname','email','studentid'])
    elif table=="library":
        df=pd.DataFrame(result,columns=['library id','library name','location'])
    elif table=="librarian":
        df=pd.DataFrame(result,columns=['librarian id','fname','lname','email','library id'])
    elif table=="publisher":
        df=pd.DataFrame(result,columns=['publisher id','publisher name','address'])
    elif table=="book":
        df=pd.DataFrame(result,columns=['book name','book id','author fname','author lname','genre','isbn','edition','librarianid','publisher id'])
    elif table=="added":
        df=pd.DataFrame(result,columns=['date added','book id','library id'])
    elif table=="borrows returns":
        df=pd.DataFrame(result,columns=['issue date','return date','due date','student id','book id'])
    elif table=="student phone no":
        df=pd.DataFrame(result,columns=['phno','student id'])
    elif table=="librarian phone no":
        df=pd.DataFrame(result,columns=['phno','librarian id'])
    st.dataframe(df)