if {$argc != 2} {
	puts "Usage: ns queue.tcl noflows_ mode_"
	puts "Example:ns queue.tcl 10 RED"
    puts "mode_: myfifo or RED"
	exit
}

Queue/RED set limit_ 50
Queue/myfifo set limit_ 50

set flow_num [lindex $argv 0]
set mode [lindex $argv 1]

# Part 1: set up the simulator
set ns [new Simulator]

set nd [open out-$flow_num-$mode.tr w]
$ns trace-all $nd

proc finish {} {
	global ns nd 
    $ns flush-trace
    close $nd 
    exit 0
}

# Part 2: create nodes

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

$ns duplex-link $r1 $r2 56k 10ms $mode
$ns queue-limit $r1 $r2 50

set q_ [[$ns link $r1 $r2] queue]
set queuechan [open q-$flow_num-$mode.tr w]
$q_ trace curq_
$q_ attach $queuechan


# Part 3: create traffic
for {set i 0} {$i < $flow_num} {incr i} {
	set tcp($i) [$ns create-connection TCP/Reno $src($i) TCPSink $dst($i) 0]
	$tcp($i) set fid_ $i
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

for {set i 0} {$i < $flow_num} {incr i} {
	set ftp($i) [$tcp($i) attach-app FTP]
	$ns at $startT($i) "$ftp($i) start"
}

$ns at 50.0 "finish"
$ns run