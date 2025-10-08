if {$argc != 1} {
	puts "Usage: ns queue.tcl mode_ "
	puts "Example:ns queue.tcl udp"
    puts "mode_: tcp or udp"
	exit
}
set mode [lindex $argv 0]

# Part 1: set up the simulator
set ns [new Simulator]

set nd [open out-$mode.tr w]
$ns trace-all $nd

proc finish {} {
	global ns nd 
    $ns flush-trace
    close $nd 
    exit 0
}

# Part 2: create nodes
set flow_num 10 
for {set i 0} {$i < $flow_num} {incr i} {
	set src($i) [$ns node]
	set dst($i) [$ns node]
}

set r1 [$ns node]
set r2 [$ns node]

for {set i 0} {$i < $flow_num} {incr i} {
	$ns duplex-link $src($i) $r1 100Mb [expr ($i*10)]ms DropTail
	$ns duplex-link $r2 $dst($i) 100Mb [expr ($i*10)]ms DropTail
}

$ns duplex-link $r1 $r2 56k 10ms "RED"
$ns queue-limit $r1 $r2 50

set q_ [[$ns link $r1 $r2] queue]
set queuechan [open q-$mode.tr w]
$q_ trace curq_
$q_ attach $queuechan


# Part 3: create traffic
if { $mode == "tcp" } {
    for {set i 0} {$i < $flow_num} {incr i} {
        set tcp($i) [$ns create-connection TCP/Reno $src($i) TCPSink $dst($i) 0]
        $tcp($i) set fid_ $i
    }
} elseif { $mode == "udp" } {
    for {set i 0} {$i < $flow_num} {incr i} {
        set udp($i) [$ns create-connection UDP $src($i) Null $dst($i) 0]
        $udp($i) set fid_ $i
    }
}
set rng [new RNG]
$rng seed 1

set RVstart [new RandomVariable/Uniform]
$RVstart set min_ 0
$RVstart set max_ 1
$RVstart use-rng $rng
for {set i 0} { $i < $flow_num } { incr i } {
	set startT($i) [expr [$RVstart value]]
}

if { $mode == "tcp" } {
    for {set i 0} {$i < $flow_num} {incr i} {
        set ftp($i) [$tcp($i) attach-app FTP]
        $ns at $startT($i) "$ftp($i) start"
    }
} elseif { $mode == "udp" } {
    for {set i 0} {$i < $flow_num} {incr i} {
        set cbr($i) [new Application/Traffic/CBR]
        $cbr($i) attach-agent $udp($i)
        $cbr($i) set packetSize_ 1000
        $cbr($i) set rate_ 10Mb
        $cbr($i) set random_ false

        $ns at $startT($i) "$cbr($i) start"
    }
}
$ns at 50.0 "finish"
$ns run