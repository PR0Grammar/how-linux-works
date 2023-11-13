#!/usr/bin/env bash

# Variables
OUTPUT_F="/tmp/output_shell_io_err.txt"
ERR_F="/tmp/err_shell_io_err.txt"
INPUT_F="test_file.txt"

# Remove the generated file starting off. Ignore errors if file doesn't exist
rm "$OUTPUT_F" 2> /dev/null
rm "${ERR_F}" 2> /dev/null

# Write first to output.txt
echo -e "testing- this should be missing!\n" > "${OUTPUT_F}"

# Now override the contents of it
cat "${INPUT_F}" | grep number > "${OUTPUT_F}"
echo -e "\n" >> "${OUTPUT_F}"

# Now we write testing again (appended!)
echo -e "testing - this gets appended :)" >> "${OUTPUT_F}"
echo -e "\n" >> "${OUTPUT_F}"

# Test out redirecting error output to a file
cat /doesnotexist/a 2> "${ERR_F}"

# First one should send output to output file. Second should send output to err
# Note - (..) matters here for #2!
cat "${INPUT_F}" | grep Barton >> "${OUTPUT_F}" 2>> "${ERR_F}"
echo -e "\n" >> "${OUTPUT_F}"

(cat /doesnotexist/b | grep something) >> "${OUTPUT_F}" 2>> "${ERR_F}"

# Send the errors to the same place as stdout
# INTERESTING NOTE HERE: since stdout is in append mode (>>), the error
# will also be appending!
cat /doesnotexist/c >> "${ERR_F}" 2>&1

# Redirection of stdin
(grep Boy < "${INPUT_F}") >> "${OUTPUT_F}"
echo -e "\n" >> "${OUTPUT_F}"

# Final output

# Total outputs: 4 
echo -e "________________Printing output file\n"
cat "${OUTPUT_F}"

# Total errors: 3 
echo -e "________________Printing error file\n"
cat "${ERR_F}" 
