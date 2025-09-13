# Init array
set isPrime(1) 0
for {set i 2} {$i <= 1000} {incr i 1} {
    set isPrime($i) 1
}

# Prime Generarte
for {set i 2} {$i <= 1000} {incr i 1} {
    if {$isPrime($i) == 1} {
        for {set j [expr $i+$i]} {$j <= 1000} {incr j $i} {
            set isPrime($j) 0
        } 
    }
}

# output
set f [open "prime.txt" "w"]
for {set i 1} {$i <= 1000} {incr i 1} {
    if {$isPrime($i) == 1} {
        puts $f $i
    }
}