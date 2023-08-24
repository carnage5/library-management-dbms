import streamlit as st
from db import delete_data

def delete(table):
   id=st.text_input("enter id")
   if(st.button("delete")):
      delete_data(table,id)
      st.success("deleted")