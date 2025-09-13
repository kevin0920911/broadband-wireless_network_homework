BEGIN {
    # Count the lines fulfil the requiement in out.tr
    numOfRequirement = 0
}

{
    if ($1 == "r" && $3 == 0 && $4 == 2 && $5 == "tcp") {
        # if fulfil plus 1 to the varible
        numOfRequirement += 1
    }
}

END {
    # print out to screen
    print numOfRequirement
}