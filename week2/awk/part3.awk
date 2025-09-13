function abs(x){return ((x < 0.0) ? -x : x)}
BEGIN {
    first = -1
    last = -1
    flag = 0
}

{
    if ($1 == "r" && $3 == 0 && $4 == 2 && $5 == "tcp") {
        if (flag == 0) {
            # If have not updated, assign col 2 to first, and update flag varible
            first = $2
            flag = 1
        }
        else {
            # If flag varible if updated to 1, then assign col 2 to last, because latest update is the last ine
            last = $2 
        }
    }
}

END {
    # prihe absoltely value of first and last to screen 
    print abs(first - last)
}