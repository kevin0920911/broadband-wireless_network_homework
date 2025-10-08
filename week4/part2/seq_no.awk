BEGIN {
}
{
    action = $1;
    time = $2;
    from = $3;
    to = $4;
    type = $5;
    pktsize = $6;
    flow_id = $8;
    src = $9;
    dst = $10;
    seq_no = $11;
    packet_id = $12;
   
    if(action=="r" && from==0 && to==1 && flow_id==1) {
        printf("%.2f\t%d\n", time, seq_no);
    }
}
END {
}
