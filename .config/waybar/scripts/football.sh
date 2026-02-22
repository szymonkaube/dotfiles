#!/bin/bash

API_KEY=$(cat "/home/szymon/api_keys/rapidapi-football" | tr -d '[:space:]')
TEAM_ID="541" # Real Madrid
TIMEZONE="Europe/Warsaw"
HOST="api-football-v1.p.rapidapi.com"
URL="https://api-football-v1.p.rapidapi.com/v3/fixtures"

fetch_matches() {
    local type=$1  # "last" or "next"
    local count=$2
    
    echo "--- $type $count matches ---"
    
    # Execute API Call
    response=$(curl -s --request GET \
        --url "$URL?$type=$count&team=$TEAM_ID&timezone=$TIMEZONE" \
        --header "X-RapidAPI-Host: $HOST" \
        --header "X-RapidAPI-Key: $API_KEY")
    echo $reponse

    # Check for errors in response
    if [[ $(echo "$response" | jq '.errors | length') -gt 0 ]]; then
        echo "API Error: $(echo "$response" | jq -r '.errors | to_entries[0].value')"
        return
    fi

    # Parse with jq
    # Output format: [Status] Date | Home vs Away | Score/Time | League
    echo "$response" | jq -r '.response[] | 
        "[\(.fixture.status.short)] \(.fixture.date[0:16] | sub("T"; " ")) | \(.teams.home.name) vs \(.teams.away.name) | \(.goals.home // "-")-\(.goals.away // "-") | \(.league.name)"' | \
        column -t -s "|"
}

# Run it
echo "=========================================================================="
echo "REAL MADRID TRACKER"
echo "=========================================================================="
fetch_matches "last" 5
echo ""
fetch_matches "next" 5
echo "=========================================================================="
