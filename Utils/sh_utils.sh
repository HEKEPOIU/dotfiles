open_pdf_in_browser() {
    if [[ -z "$1" ]]; then
        echo "please get input file"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "file not exist"
        return 1
    fi

    if command -v xdg-open > /dev/null; then # for Linux
        xdg-open "$1" &> /dev/null
    elif command -v open > /dev/null; then # for Mac
        open "$1" &> /dev/null
    else
        echo "can't find default pdf open app"
        return 1
    fi
}

fzt() {
    local p=$(fzf)
    if [[ -z "$p" ]]; then
        echo "No selection made"
        return 1
    fi
    
    local dir=$(dirname "$p")
    echo $dir
    cd $dir || { echo "Failed to change directory to $dir"; return 1; }
}

