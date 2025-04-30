# This script reads the content of a given csv file and extracts the first and last row
# of a specified column

# In the context of this project, we use this feature to read the first and last timestamp values
# to define the x-range in the graphical plots


##########     SETTINGS     ##########


# CSV_FILE_PATH="./Generated_CSV"
COLUMN_NR=1 # Get the left-most column
ROWS_NUM=2 # Get the header and the first numerical row


##########     FUNCTIONS     ##########


# ARGS:
#   - $1: Path to CSV file to manipulate
getFirstRow() {
    firstRow=$(sort -n -k ${COLUMN_NR} "${1}.csv" | head -n ${ROWS_NUM})
    arrSplit=(${firstRow//;/ })

    firstVal=${arrSplit[3]}
    echo "${firstVal}"
}

# ARGS:
#   - $1: Path to CSV file to manipulate
getLastRow() {
    lastRows=$(sort -r -k ${COLUMN_NR} "${1}.csv" | head -n ${ROWS_NUM})
    arrSplit2=(${lastRows//;/ })

    secondVal=${arrSplit2[3]}
    echo "${secondVal}"
}