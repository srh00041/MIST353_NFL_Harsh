import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.session_state.setdefault("app_user_fullname", "")
    fan_name = st.session_state["app_user_fullname"]
    st.session_state.setdefault("app_user_id", "")
    nfl_fan_id = st.session_state["app_user_id"]

   
    fan_name = st.session_state.app_user_fullname
    st.header(f"Teams associated with {fan_name}")
    
    input_parameters = {}
    nfl_fan_id = st.text_input("Fan ID", value=st.session_state.app_user_id)
    input_parameters["nfl_fan_id"] = nfl_fan_id
    
    df = fetch_data("get_teams_for_specified_fan/", input_parameters)
    
    if df is not None and not df.empty:
        st.dataframe(df, use_container_width=True, hide_index=True)
    
    else:
        st.info(f"No teams found for the specified fan.")


