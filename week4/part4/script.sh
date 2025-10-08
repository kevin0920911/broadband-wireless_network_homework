for i in 0 1 2 3 4 5
do 
    echo $i | awk -f throuput_plot.awk out.tr > th$i
done    