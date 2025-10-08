BEGIN {
	init=0;
    startT=0;
	endT=0;
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

         if(action=="r" && type=="tcp" && time >= 5.0 && time <=10.0 && (from==7 && to==3)) {
         	 if(init==0){
         	 	startT=time;
         	 	init=1;
         	 }
         	 
	         pkt_byte_sum += pktsize;
	         endT=time;
         }
    
         
}
END {
	time=endT-startT;
	throughput=pkt_byte_sum*8/time/1000;
	printf("%f\n", throughput);
}

