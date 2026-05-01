import streamlit as st
from fetch_data import get_data

def get_all_changes_made_by_specific_admin_ui():
      
    admin_name = st.session_state.app_user_fullname
    st.header(f"Changes made by {admin_name}")
    
    input_parameters = {}
    nfl_admin_id = st.text_input("Admin ID", value=st.session_state.app_user_id)
    input_parameters["nfl_admin_id"] = nfl_admin_id
    
    df = get_data("get_all_changes_made_by_specific_admin/", input_parameters)
    
    if df is not None and not df.empty:
        st.dataframe(df, use_container_width=True, hide_index=True)
    
    else:
        st.info(f"No changes found for the specified admin.")