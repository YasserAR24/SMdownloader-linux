# SMdownloader

Social Media downloader

## Make this for first time (one time)

- First, make `install-config-update.sh` and `runSMdownloader.sh` executable by typing this command in a terminal (note: you must open the current folder in the terminal):  
  `chmod +x install-config-update.sh runSMdownloader.sh`
- Right click `install-config-update.sh` and **Run as a Program** 
	- Type your password
	- Wait until you see “Press Enter to exit...”, then press Enter to close the window.

## How to run and use it

- Right-click `runSMdownloader.sh` and choose **Run as a Program**.
- A window will open in your default browser. This window contains the app’s GUI.

## Features

- Download a single video or pick videos from a playlist (first 200 items are listed)
- Quality options:
	- Youtube: High (best available), 2160p (4K), 1440p (2K), 1080p, 720p, 480p, 360p, or Audio only (MP3, 192 kbps)
	- Other Platforms: Hight (best available), Audio only (MP3, 192 kbps)
- Video output is always MP4
- Clip a section of a video with a timeline slider or manual start/end times
- Optional custom file name; playlist downloads can use a custom folder name
- English subtitles (YouTube only), embedded into the MP4
- Queue with live progress, speed, ETA, pause/resume, cancel, retry, and "retry without subtitles"
- Open or move finished files from the page
- Configurable download folder and maximum simultaneous downloads (default 3)
- Downloads are sorted into subfolders by platform: YouTube, Instagram, Facebook, TikTok, LinkedIn. Other sites supported by yt-dlp are saved in the root download folder.

## Note

You can update the program by running the `install-config-update.sh` file again.

## Technical stuf

 - **HTML, CSS, and JavaScript:** front end.
 - **python**: back end
	 - **yt-dlp:** handles the downloading
	 - **Flask:** the web server.
- **FFmpeg:** processes the downloaded files. It merges separate video and audio streams into one MP4, converts audio to MP3, and embeds subtitles into the video.

- **Local Host** : for hosting the server


