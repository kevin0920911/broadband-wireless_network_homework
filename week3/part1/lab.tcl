# Create Simulator
set ns [new Simulator]
# Create Trace file
set nd [open out.tr w]
$ns trace-all $nd
# Close all file when this program is finish 
proc finish {} {
        global ns nd
        $ns flush-trace
        close $nd 
        exit 0
}

#setting send1, send2
set s1 [$ns node]
set s2 [$ns node]
#setting receiver
set r [$ns node]
#setting delivery
set d [$ns node]
# Link Setting
$ns duplex-link $s1 $r 2Mb 10ms DropTail
$ns duplex-link $s2 $r 2Mb 10ms DropTail
$ns duplex-link $r $d 1.7Mb 20ms DropTail
# Queue Limit 
$ns queue-limit $r $d 10

# TCP agent 
set tcp [new Agent/TCP]
$ns attach-agent $s1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $d $sink
$ns connect $tcp $sink
$tcp set fid_ 1

# UDP angent 
set udp [new Agent/UDP]
$ns attach-agent $s2 $udp
set null [new Agent/Null]
$ns attach-agent $d $null
$ns connect $udp $null
$udp set fid_ 2

# Add Application 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 1mb
$cbr set random_ false

$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr stop"

# When Program end run finish marco 
$ns at 5.0 "finish"

$ns run
