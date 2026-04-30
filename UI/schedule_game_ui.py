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
    team_options = dict(zip(teams_df["team_name"], teams_df["team_id"]))
    stadium_options = dict(zip(stadiums_df["stadium_name"], stadiums_df["stadium_id"]))

    home_team = st.selectbox("Select Home Team", options=team_options.keys())
    away_team = st.selectbox("Select Away Team", options=team_options.keys())
    stadium_name = st.selectbox("Select Stadium", options=stadium_options.keys())
    game_round = st.selectbox("Enter Game Round", options=GAME_ROUNDS)

    game_date = st.date_input("Select Game Date", min_value=date.today())
    game_time = st.time_input("Select Game Start Time", value=time(13, 0))

    if st.button("Schedule Game"):
        parameters = {}
        home_team_id = team_options[home_team_name]
        away_team_id = team_options[away_team_name]
        stadium_id = stadium_options[stadium_name]
        nfl_admin_id = 1  # Assuming a default admin ID for scheduling

        input_data = {
            "home_team_id": home_team_id,
            "away_team_id": away_team_id,
            "game_round": game_round,
            "game_date": game_date.isoformat(),
            "game_start_time": game_time.isoformat(),
            "stadium_id": stadium_id,
            "nfl_admin_id": nfl_admin_id
        }

        response = post_data("schedule_game/", input_data)
        st.write(response.get("status message", "No response from server."))
