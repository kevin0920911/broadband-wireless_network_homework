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

#setting receiver
set r [$ns node]
#setting delivery
set d [$ns node]
# Link Setting
$ns duplex-link $r $d 2Mb 10ms DropTail
# Queue Limit 
$ns queue-limit $r $d 10

# TCP agent 
set tcp [new Agent/TCP]
$ns attach-agent $r $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $d $sink
$ns connect $tcp $sink
$tcp set fid_ 1

# Add Application 
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

$ns at 1.0 "$ftp start"
$ns at 4.0 "$ftp stop"

# When Program end run finish marco 
$ns at 5.0 "finish"

$ns run
