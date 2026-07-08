#!/usr/bin/env python3
import subprocess
import math
import json
import sys

def run_playerctl(args):
    """Executes a playerctl command and returns its output."""
    try:
        # We specify the player directly here
        cmd = ['playerctl', '--player=spotify'] + args
        return subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode('utf-8').strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None

def build_progress_bar(position, length, bar_length=10):
    """Builds a text-based progress bar."""
    if length <= 0:
        return ""
    perc = position / length
    filled = math.floor(perc * bar_length)
    # Using more distinct characters for the progress bar
    bar = '─' * filled + '·' * (bar_length - filled)
    return f"[{bar}]"

def main():
    """Main function to get metadata and print JSON for Waybar."""
    status = run_playerctl(['status'])
    
    # If status is None, Spotify is not running or not playing anything.
    if not status:
        # Output an empty JSON object to hide the module gracefully
        print(json.dumps({"text": "", "tooltip": "", "class": "spotify-hidden"}))
        sys.exit(0)

    # Get metadata
    artist = run_playerctl(['metadata', 'artist'])
    title = run_playerctl(['metadata', 'title'])
    
    if not artist or not title:
        print(json.dumps({"text": "No metadata", "tooltip": "Could not get song info"}))
        sys.exit(0)

    # Get playback position and song length
    position_str = run_playerctl(['position'])
    length_str = run_playerctl(['metadata', 'mpris:length'])
    
    position = float(position_str) if position_str else 0.0
    # mpris:length is in microseconds, convert to seconds
    length = float(length_str) / 1_000_000 if length_str else 0.0

    # Determine icon based on status
    icon = "" # Default Spotify icon
    if status == 'Playing':
        icon = "󰐊" # Play icon
    elif status == 'Paused':
        icon = "󰐎" # Pause icon

    # Build the output for Waybar
    progress = build_progress_bar(position, length)
    full_text = f"{artist} - {title}"
    
    # The text displayed on the bar
    display_text = f"{icon} {full_text} {progress}"
    
    # Prepare data for JSON output
    output_data = {
        "text": display_text,
        "tooltip": f"Spotify: {status}\n{full_text}", # Tooltip shows full info
        "class": f"spotify-{status.lower()}" # e.g., "spotify-playing"
    }
    
    print(json.dumps(output_data))

if __name__ == '__main__':
    main()
