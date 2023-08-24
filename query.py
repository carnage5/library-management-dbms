import streamlit as st
from db import sendquery
def inputquery():
    input=st.text_area("enter query")
    if st.button("Execute Query"):
        sendquery(input)
        st.success("query sent")