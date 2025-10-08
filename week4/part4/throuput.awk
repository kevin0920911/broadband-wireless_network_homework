BEGIN {
    # Setting init data 
    for (i=3; i<=13; i+=2) {
        node[i]["flag"] = 0;
        node[i]["start_time"] = 0;
        node[i]["end_time"] = 0;
        node[i]["pkt_byte_sum"] = 0;
    }
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

    if (action=="r" && type=="tcp" && time >= 1.0 && time <= 5.0) {
        if (from == 1 && (to % 2 == 1) && (to >= 3 && to <= 13)) {
            # if start time is not setting, setting start time
            if (node[to]["flag"] == 0) {
                node[to]["start_time"] = time;
                node[to]["flag"] = 1;
            }
            node[to]["pkt_byte_sum"] += pktsize;
            node[to]["end_time"] = time;
        }
    }
}

END {
    for (i=3; i<=13; i+=2) {
        if (node[i]["end_time"] > node[i]["start_time"]) {
            duration = node[i]["end_time"] - node[i]["start_time"];
            throughput = node[i]["pkt_byte_sum"] * 8 / duration / 1000000;
        } 
        else {
            # prevent div by 0 error
            throughput = 0;
        }
        flow = int((i - 3) / 2) + 1;
        printf("flow %d throughput: %.3f Mbps\n", flow, throughput);
    }
}
