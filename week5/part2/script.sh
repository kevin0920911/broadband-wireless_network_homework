for ((i=100; i<=500; i+=100)); do
    for ((j=1; j<=300; j++)); do
        ns lab.tcl "$i" "$j"
        f1="tmp/out${i}-${j}.tr"
        f2="result${i}"
        awk -f 5T.awk "$f1" >> "$f2"
        echo ""
    done
    echo ""
done