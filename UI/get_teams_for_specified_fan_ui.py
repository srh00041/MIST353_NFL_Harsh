import streamlit as st
from fetch_data import fetch_data

def get_teams_for_specified_fan_ui():
    st.header("Get Teams for Specified Fan")

    nfl_fan_id = st.number_input("Enter Fan ID", min_value=1, step=1)
    if st.button("Fetch Teams"):
        if not nfl_fan_id:
            st.warning("Please Enter a NFL Fan ID")
        else:
            input_params = {}

            input_params["nfl_fan_id"] = nfl_fan_id
            df = fetch_data("get_teams_for_specified_fan/", input_params)

            if df is not None and not df.empty:
                st.subheader(f"teams for NFL Fan ID {nfl_fan_id}:")
                st.dataframe(df, use_container_width=True, hide_index=True)
            else:
                st.info(f"No teams found for NFL Fan ID {nfl_fan_id}. Please check the fan ID and try again.")