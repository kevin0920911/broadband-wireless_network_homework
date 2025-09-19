#�o�O���qCBR�ʥ]�����]�R�q(average throughput)��awk�{��

BEGIN {
	init=0;
	i=0;
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
   
 	if(action=="r" && from==2 && to==3 && flow_id==1) {
 		pkt_byte_sum[i+1]=pkt_byte_sum[i]+ pktsize;
		
		if(init==0) {
			start_time = time;
			init = 1;
		}
		
		end_time[i] = time;
		i = i+1;
	}
}
END {
#���F�e�Ϧn�ݡA��Ĥ@���O����throughput�]���s�A�H���ܶǿ�}�l
	printf("%.2f\t%.2f\n", end_time[0], 0);
	
	for(j=1 ; j<i ; j++){
#��쬰kbps
		th = pkt_byte_sum[j] / (end_time[j] - start_time)*8/1000;
		printf("%.2f\t%.2f\n", end_time[j], th);
	}
#���F�e�Ϧn�ݡA��ī�@���O����throughput�A�]���s�A�H���ܶǿ鵲��
	printf("%.2f\t%.2f\n", end_time[i-1], 0);
}
