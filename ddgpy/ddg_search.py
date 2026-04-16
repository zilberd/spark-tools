#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "ddgs",
# ]
# ///

import sys
import json
from ddgs import DDGS

def search_ddg(query, max_results=10):
    """Search DuckDuckGo for the given query using ddgs"""
    try:
        results = DDGS().text(query, max_results=max_results)
        return results
    except Exception as e:
        print(f"Error during search: {e}", file=sys.stderr)
        return []

def search_ddg_json(query, max_results=10):
    """Search DuckDuckGo and return results as JSON"""
    results = search_ddg(query, max_results)
    return json.dumps(results, indent=2)

def main():
    """Main function to handle command-line arguments"""
    if len(sys.argv) < 2:
        print("Usage: ddg_search.py <query> [max_results]")
        print("Example: ddg_search.py 'python programming' 5")
        sys.exit(1)
    
    query = sys.argv[1]
    max_results = int(sys.argv[2]) if len(sys.argv) > 2 else 10
    
    # Get results as JSON
    results_json = search_ddg_json(query, max_results)
    print(results_json)

if __name__ == "__main__":
    main()
