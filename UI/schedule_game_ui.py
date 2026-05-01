import streamlit as st
from fetch_data import post_data, get_data
from datetime import date, time

def schedule_game_ui():
    st.header("Schedule a Game")
    
    parameters = {}
    teams_df = get_data("get_all_teams/", parameters)
    stadiums_df = get_data("get_all_stadiums/", parameters)

    GAME_ROUNDS = ["Wild Card", "Divisional", "Conference", "Super Bowl"]

    #create dropdowns for home team, away team, and stadium
    team_options = dict(zip(teams_df["TeamName"], teams_df["TeamID"]))
    stadium_options = dict(zip(stadiums_df["StadiumName"], stadiums_df["StadiumID"]))

    home_team_name = st.selectbox("Select Home Team", options=team_options.keys())
    away_team_name = st.selectbox("Select Away Team", options=team_options.keys())
    stadium_name = st.selectbox("Select Stadium", options=stadium_options.keys())
    game_round = st.selectbox("Enter Game Round", options=GAME_ROUNDS)

    game_date = st.date_input("Select Game Date", min_value=date.today())
    game_time = st.time_input("Select Game Start Time", value=time(13, 0))

    if st.button("Schedule Game"):
        if home_team_name == away_team_name:
            st.warning("Home Team and Away Team cannot be the same. Please select different teams.")
            return
        
        home_team_id = team_options[home_team_name]
        away_team_id = team_options[away_team_name]
        stadium_id = stadium_options[stadium_name]
        nfl_admin_id = 1  # Assuming a default admin ID for scheduling

        parameters = {}
        parameters["home_team_id"] = home_team_id
        parameters["away_team_id"] = away_team_id
        parameters["game_date"] = game_date.isoformat()
        parameters["game_start_time"] = game_time.isoformat()
        parameters["stadium_id"] = stadium_id
        parameters["game_round"] = game_round
        parameters["nfl_admin_id"] = st.session_state.app_user_id

        input_data = {
            "home_team_id": home_team_id,
            "away_team_id": away_team_id,
            "game_round": game_round,
            "game_date": game_date.isoformat(),
            "game_start_time": game_time.isoformat(),
            "stadium_id": stadium_id,
            "nfl_admin_id": nfl_admin_id
        }

        response = post_data("schedule_game/", parameters)
        if response is not None and "status message" in response:
            st.info(response["status message"])
        else:
            st.error("An error occurred while scheduling the game. Please try again.")
