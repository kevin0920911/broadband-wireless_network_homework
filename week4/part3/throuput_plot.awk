BEGIN {
    # Setting init data 
    flag = 0;
    idx = 0;

    getline fid < "/dev/stdin"; 
}

{
    action = $1;
    time = $2;
    from = $3;
    to = $4;
    type = $5;
    pktsize = $6;
    flow_id = $8;
    node_1_address = $9;
    node_2_address = $10;
    seq_no = $11;
    packet_id = $12;

    # statistics from 1 to (fid*2 + 3)

    if(action=="r" && from==1 && to==fid*2+3 && flow_id==fid)  {
        pkt_byte_sum[idx+1]=pkt_byte_sum[idx]+ pktsize;

        if(flag==0) {
            start_time = time;
            flag = 1;
        }

        end_time[idx] = time;
        idx = idx + 1;
    }
}

END {
    printf("%.2f\t%.2f\n", end_time[0], 0);

    for(j=1 ; j<idx ; j++){
        th = pkt_byte_sum[j] / (end_time[j] - start_time)*8/1000;
        printf("%.2f\t%.2f\n", end_time[j], th);
    }

    printf("%.2f\t%.2f\n", end_time[idx-1], 0);
}
