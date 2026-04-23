import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    fan_name = st.session_state.app_user_name
    st.header(f"Teams associated with {fan_name}")
    

    #nfl_fan_id = st.number_input("Enter Fan ID", min_value=1, step=1)
    input_params = {}
    nfl_fan_id = st.text_input("Enter Fan ID", value = st.session_state.app_user_id, disabled=True)
    input_params["nfl_fan_id"] = nfl_fan_id
    df = fetch_data("get_teams_for_specified_fan/", input_params)
    
    if df is not None and not df.empty:
        st.success(f"teams for NFL Fan ID {nfl_fan_id}:")
        st.dataframe(df, use_container_width=True, hide_index=True)
    else:
        st.info(f"No teams found for NFL Fan ID {nfl_fan_id}. Please check the fan ID and try again.")