#!/bin/bash
echo
source .SMdownloadervenv/bin/activate
cd app-files
xdg-open http://127.0.0.1:5000
python3 SMdownloader.py
