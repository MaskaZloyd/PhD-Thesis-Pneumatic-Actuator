#!/bin/bash

# Check if a filename was provided
if [ $# -eq 0 ]; then
    echo "Please provide a .tex file name (without extension)"
    exit 1
fi

# Set the main file name
MAIN_FILE="$1"

# Function to run a command and display a spinner
run_with_spinner() {
    local command="$1"
    local message="$2"
    echo -n "$message "

    # Create a temporary file to store the command output
    local temp_file=$(mktemp)

    # Start the command in the background, redirecting output to the temp file
    eval "$command" > "$temp_file" 2>&1 &

    # Get the PID of the command
    local pid=$!

    # Display a spinner while the command is running
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 4 ))
        printf "\r$message ${spin:$i:1}"
        sleep .1
    done

    # Wait for the command to finish and get its exit status
    wait $pid
    local exit_status=$?

    # Print a newline
    echo

    # If the command failed, display its output
    if [ $exit_status -ne 0 ]; then
        echo "Error occurred. Command output:"
        cat "$temp_file"
    fi

    # Remove the temporary file
    rm "$temp_file"

    return $exit_status
}

# Check if the file exists
if [ ! -f "${MAIN_FILE}.tex" ]; then
    echo "Error: File ${MAIN_FILE}.tex not found."
    exit 1
fi

# Main compilation loop
max_iterations=3
iteration=0
success=false

while [ $iteration -lt $max_iterations ] && [ "$success" = false ]; do
    ((iteration++))
    echo "Compilation iteration $iteration"

    # Run XeLaTeX
    if run_with_spinner "xelatex -synctex=1 -interaction=nonstopmode ${MAIN_FILE}.tex" "Running XeLaTeX..."; then
        # Run Biber
        if run_with_spinner "biber ${MAIN_FILE}" "Running Biber..."; then
            # Run XeLaTeX again
            if run_with_spinner "xelatex -synctex=1 -interaction=nonstopmode ${MAIN_FILE}.tex" "Running XeLaTeX again..."; then
                success=true
            fi
        fi
    fi
done

if [ "$success" = true ]; then
    echo "Compilation of ${MAIN_FILE}.tex completed successfully."
    if [ ! -d "output" ]; then
        mkdir "output"
    fi
    mv "${MAIN_FILE}.pdf" "output/${MAIN_FILE}.pdf"
else
    echo "Warning: Compilation completed with potential issues."
    echo "Please check the ${MAIN_FILE}.log file for more details."

    #check if file exists and move it to output
    if [ -f "${MAIN_FILE}.pdf" ]; then
        if [ ! -d "output" ]; then
            mkdir "output"
        fi
        cp "${MAIN_FILE}.pdf" "output/${MAIN_FILE}.pdf"
    fi

    read -p "Do you want to open the log file? (Y/N) " open_log
    if [[ $open_log =~ ^[Yy]$ ]]; then
        cygstart "${MAIN_FILE}.log"
    fi
fi

read -n 1 -s -r -p "Press any key to continue..."
echo
