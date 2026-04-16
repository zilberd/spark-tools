#!/bin/bash
# DuckDuckGo search wrapper script
# This script is installed at ~/.local/bin/ddg to make the ddg command available globally

cd /home/gx10/tools/ddgpy && uv run ddg_search.py "$@"
