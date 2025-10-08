# get argument
if {$argc !=2} {
	puts "Usage: ns exp5.tcl rate_ no_"
	exit
}
set par1 [lindex $argv 0]
set par2 [lindex $argv 1]

# Part1: init network enviorment
# init network simulator
set ns [new Simulator]
set nd [open tmp/out$par1-$par2.tr w]
$ns trace-all $nd
proc finish {} {
        global ns nd
        $ns flush-trace
        close $nd 
        exit 0
}


# init network graph
set s1 [$ns node]
set s2 [$ns node]
set s3 [$ns node]
set d1 [$ns node]
set d2 [$ns node]
set d3 [$ns node]
set r1 [$ns node]
set r2 [$ns node]

$ns duplex-link $s1 $r1 10Mb 1ms DropTail
$ns duplex-link $s2 $r1 10Mb 1ms DropTail
$ns duplex-link $s3 $r1 10Mb 1ms DropTail
$ns duplex-link $r1 $r2 1Mb 10ms DropTail
$ns duplex-link $r2 $d1 10Mb 1ms DropTail
$ns duplex-link $r2 $d2 10Mb 1ms DropTail
$ns duplex-link $r2 $d3 10Mb 1ms DropTail

# Part2: setting agent
# s1 -> d1 (TCP)
set tcp1 [new Agent/TCP]
$ns attach-agent $s1 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $d1 $sink1
$ns connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

# s2 -> d2 (TCP)
set tcp2 [new Agent/TCP]
$ns attach-agent $s2 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $d2 $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ftp2 set type_ FTP

# s3 -> d3 (UDP)
set udp [new Agent/UDP]
$ns attach-agent $s3 $udp
set null [new Agent/Null] 
$ns attach-agent $d3 $null
$ns connect $udp $null
set traffic [new Application/Traffic/Exponential]
$traffic set	packetSize_	1000
$traffic set	burst_time_	0.5
$traffic set	idle_time_	0
$traffic set 	rate_	[expr $par1*1000]
$traffic attach-agent $udp

# setting random value
set rng [new RNG]
$rng seed 0

set RVstart [new RandomVariable/Uniform]
$RVstart set min_ 3
$RVstart set max_ 4
$RVstart use-rng $rng

set startT [expr [$RVstart value]]
puts "startT $startT sec"

$ns at 0.0 "$ftp2 start"
$ns at 0.0 "$traffic start"
$ns at $startT "$ftp1 start"

$ns at 11.0 "$ftp1 stop"
$ns at 11.5 "$ftp2 stop"
$ns at 11.5 "$traffic stop"

$ns at 1200.0 "finish"

$ns run
