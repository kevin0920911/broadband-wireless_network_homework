# Part1: init
# Create Simuator 
set ns [new Simulator]
# Trace File
set nd [open out.tr w]
$ns trace-all $nd
# CLose FIle
proc finish {} {
    global ns nd
    
    close $nd
    $ns flush-trace

    exit 0
}

#---------------------

# Part2: Setting network graph 
set r1 [$ns node]
set r2 [$ns node]
$ns duplex-link $r1 $r2 1Mb 10ms DropTail

set nflow 3
for {set i 0} {$i < $nflow} {incr i 1} {
    set src($i) [$ns node]
    set dest($i) [$ns node]

    $ns duplex-link $src($i) $r1 10Mb 1ms DropTail 
	$ns duplex-link $r2 $dest($i) 10Mb 1ms DropTail
}

#---------------------

# Part3: Attach FTP agent
for {set i 0} {$i < $nflow} {incr i 1} {
    # Create Agent
    set tcp($i) [new Agent/TCP]
    set sink($i) [new Agent/TCPSink]

    # Attach agent to node
    $ns attach-agent $src($i) $tcp($i)
    $ns attach-agent $dest($i) $sink($i)
    $ns connect $tcp($i) $sink($i)

    # Attach FTP Application to TCP agent
    set ftp($i) [new Application/FTP]
    $ftp($i) attach-agent $tcp($i)
    $ftp($i) set type_ FTP

    $tcp($i) set fid_ $i
}

#---------------------

# Part4: Setting Start/End Time
set rng [new RNG]
$rng seed 0
# Set Distibution 
set start_random [new RandomVariable/Uniform]
$start_random set min_ 0
$start_random set max_ 1
$start_random use-rng $rng

set end_random [new RandomVariable/Uniform]
$end_random set min_ 4
$end_random set max_ 5
$end_random use-rng $rng

for {set i 0} { $i < $nflow } { incr i } {
	
	set start_time($i) [expr [$start_random value]]
	set end_time($i) [expr [$end_random value]]

    puts "start time $i : $start_time($i)"
    puts "end time $i : $end_time($i)"

	$ns at $start_time($i) "$ftp($i) start"
	$ns at $end_time($i) "$ftp($i) stop"
    
}

#---------------------

# Part5: Finish 
$ns at 7.0 "finish"
$ns run