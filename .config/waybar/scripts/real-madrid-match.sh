#!/bin/bash

API_KEY=$(cat "/home/szymon/api_keys/football-data-org")
TEAM_ID='86'
URL="https://api.football-data.org/v4/teams/$TEAMID"

response=$(curl -s -w "|%{http_code}" -H "X-Auth-Token: $API_TOKEN" "$URL")
echo $response
body=$(echo "$response" | cut -d'|' -f1)
status=$(echo "$response" | cut -d'|' -f2)

if [ "$status" -eq 200 ]; then
    echo "$body" | jq -r '.matches[] | "\(.utcDate[0:10]) | \(.homeTeam.name) vs \(.awayTeam.name)"'
fi
