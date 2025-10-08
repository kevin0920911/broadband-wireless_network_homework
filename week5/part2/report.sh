rm result
for ((i=100; i<=500; i+=100)); do
    avg=$(awk -f avg.awk result$i)
    awk -v rate=$i -v t=$avg -f 90ci.awk result$i >> result
done