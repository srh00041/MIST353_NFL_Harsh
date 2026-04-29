import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    fan_name = st.session_state.app_user_fullname
    st.header(f"Teams associated with {fan_name}")
    

    nfl_fan_id = st.number_input("Enter Fan ID", min_value=1, step=1)
    input_parameters = {}
    
    input_parameters["fan_id"] = nfl_fan_id
    
    df = fetch_data("get_teams_for_specified_fan/", input_parameters)
    
    if df is not None and not df.empty:
        #st.success(f"teams for NFL Fan ID {fan_id}:")
        st.dataframe(df, use_container_width=True, hide_index=True)
    else:
        st.info(f"No teams found for the specified fan.")
    

