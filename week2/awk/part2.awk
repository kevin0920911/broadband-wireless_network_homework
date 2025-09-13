BEGIN {
    # The Summation of col 6
    summation = 0
}

{
    if ($1 == "r" && $3 == 0 && $4 == 2 && $5 == "tcp") {
        # if fulfil above situation then add $6 to summation varibe
        summation += $6
    }
}

END {
    # print the ans to screen
    print summation
}