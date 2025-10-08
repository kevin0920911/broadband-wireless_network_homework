BEGIN {
    FS="\t";
}
{
    ln++;
    d=$0-t;
    s2=s2+d*d;
} 
END {
    s=sqrt(s2/(ln-1)); 
    Z = 1.96*s/sqrt(ln);

    print rate " " t " " Z
}
