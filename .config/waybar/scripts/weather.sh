#!/bin/bash

LAT="51.11"
LON="17.03"

weather=$(curl -sf "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m&wind_speed_unit=ms")

if [ $? -ne 0 ]; then
    echo '{"text": "Error", "tooltip": "Weather API unreachable"}'
    exit 1
fi

temp=$(echo "$weather" | jq '.current.temperature_2m')
apparent=$(echo "$weather" | jq '.current.apparent_temperature')
humidity=$(echo "$weather" | jq '.current.relative_humidity_2m')
wind=$(echo "$weather" | jq '.current.wind_speed_10m')
code=$(echo "$weather" | jq '.current.weather_code')

case $code in
    0) desc="Clear sky"; icon="☀️";;
    1) desc="Mainly clear"; icon="🌤️";;
    2) desc="Partly cloudy"; icon="⛅";;
    3) desc="Overcast"; icon="☁️";;
    45|48) desc="Fog"; icon="🌫️";;
    51|53|55) desc="Drizzle"; icon="🌧️";;
    56|57) desc="Freezing Drizzle"; icon="❄️🌧️";;
    61|63|65) desc="Rain"; icon="🌧️";;
    66|67) desc="Freezing Rain"; icon="🧊🌧️";;
    71|73|75) desc="Snow fall"; icon="❄️";;
    77) desc="Snow grains"; icon="❄️";;
    80|81|82) desc="Rain showers"; icon="🌦️";;
    85|86) desc="Snow showers"; icon="🌨️";;
    95) desc="Thunderstorm"; icon="🌩️";;
    96|99) desc="Thunderstorm with hail"; icon="⛈️";;
    *) desc="Unknown"; icon="❓";;
esac

tooltip="<b>$desc</b>\n"
tooltip+="Feels like: ${apparent}°C\n"
tooltip+="Humidity: ${humidity}%\n"
tooltip+="Wind: ${wind} m/s"

echo "{\"text\": \"$icon $temp°C\", \"tooltip\": \"$tooltip\"}"
