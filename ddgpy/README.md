# DuckDuckGo Search Tool (ddgs)

This directory contains a DuckDuckGo search integration tool using the ddgs Python library.

## Usage

### Command Line (with uv)

```bash
# Basic search
uv run ddg_search.py "your search query"

# Search with specific number of results
uv run ddg_search.py "your search query" 5
```

### From anywhere

Since this is in your tools directory, you can add it to your PATH or use the full path:

```bash
# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$PATH:/home/gx10/tools/ddgpy"

# Then you can run from anywhere
uv run ddg_search.py "your search query"
```

### Python Code

```python
from ddgs import DDGS

# Search for results
results = DDGS().text("python programming", max_results=10)

# Print results
for result in results:
    print(f"Title: {result['title']}")
    print(f"URL: {result['href']}")
    print(f"Snippet: {result['body']}")
    print("---")
```

## Output Format

The tool returns results as JSON with the following structure:
```json
[
  {
    "title": "Result title",
    "href": "https://example.com",
    "body": "Result description snippet"
  }
]
```

## Notes

- This uses the ddgs library which is a metasearch library that aggregates results from diverse web search services
- ddgs supports multiple search engines including DuckDuckGo, Google, Bing, and more
- Results may vary in quality and consistency depending on the search engine backends

## Setup Instructions (for future sessions)

This tool is configured to work globally from any project folder. Here's how it's set up:

### 1. Wrapper Script (Primary Method)
- **Location**: `~/.local/bin/ddg`
- **Usage**: Simply run `ddg "search query" [max_results]` from anywhere
- **How it works**: The script is in `~/.local/bin` which is already in your PATH

### 2. Bash Alias (Alternative)
- **Location**: Added to `~/.bashrc`
- **Usage**: Run `ddg_alias "search query" [max_results]` from anywhere
- **How it works**: The alias changes to the tools directory and runs uv

### 3. Direct Execution
- **Location**: `~/tools/ddgpy/ddg_search.py`
- **Usage**: `uv run ddg_search.py "search query" [max_results]`
- **How it works**: Uses inline script metadata with uv to manage dependencies

### 4. Tools Registry
- **Location**: `~/tools/registry.txt`
- **Purpose**: Documents all available tools for future sessions

### How to Use in Future Sessions
1. Open a new terminal or VS Code session
2. The wrapper script `ddg` will be available globally
3. Run: `ddg "your search query" 5`
4. Results will be returned in JSON format

### Troubleshooting
- If `ddg` command not found, ensure `~/.local/bin` is in your PATH
- Run `source ~/.bashrc` to reload aliases if needed
- Check `~/tools/registry.txt` for tool documentation

### Wrapper Script Content

The wrapper script at `~/.local/bin/ddg` contains:

```bash
#!/bin/bash
# DuckDuckGo search wrapper script
cd /home/gx10/tools/ddgpy && uv run ddg_search.py "$@"
```

This script is what makes the `ddg` command available globally from any project folder.
