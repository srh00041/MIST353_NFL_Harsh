import streamlit as st
from get_teams_by_conference_division_ui import get_teams_by_conference_division_ui
from get_teams_in_same_conference_division_as_specified_team_ui import get_teams_in_same_conference_division_as_specified_team_ui
from validate_user_ui import validate_user_ui
from get_teams_for_specified_fan_ui import get_teams_for_specified_fan_ui
from schedule_game_ui import schedule_game_ui
from get_all_changes_made_by_specified_admin_ui import get_all_changes_made_by_specific_admin_ui



st.title("NFL Playoffs App")
st.write("Welcome to the NFL Playoffs App! Use the sidebar to navigate through different features and explore information about NFL teams, players, and playoff matchups.")



#Creating a sidebar for navigation
#Dropdown for nfl playoff functionalities

with st.sidebar:

  st.title("NFL Playoff Functionalities")



  api_endpoint = st.selectbox(
    "Select a functionality:",
    ["Get Teams by Conference and Division", 
     "Get Teams in Same Conference and Division as Specified Team", 
     "Validate User",
     "Get Teams for Specified Fan",
     "Schedule a Game",
     "Get All Changes Made by Specified Admin"]
  )


if api_endpoint == "Get Teams by Conference and Division":
   get_teams_by_conference_division_ui()


elif api_endpoint == "Get Teams in Same Conference and Division as Specified Team":
   get_teams_in_same_conference_division_as_specified_team_ui()

elif api_endpoint == "Validate User":
   validate_user_ui()

elif api_endpoint == "Get Teams for Specified Fan":
    get_teams_for_specified_fan_ui()

elif api_endpoint == "Schedule a Game":
      if "app_user_id" not in st.session_state:
        st.warning("Please log in to access this Schedule a Game functionality.")
      elif st.session_state.app_user_role != "NFLAdmin":
         st.warning("Only NFL Admin users can access the Schedule a Game functionality.")
      else:
         schedule_game_ui()


elif api_endpoint == "Get All Changes Made by Specified Admin":
    get_all_changes_made_by_specific_admin_ui()
