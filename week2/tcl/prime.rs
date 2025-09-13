use std::fs::File;
use std::io::Write;

fn get_prime(num: usize) -> Vec<bool> {
    // num: get the primes of 1-num

    if num < 2 {
        return vec![false; num + 1];
    }

    // Init array
    let mut is_prime = vec![true; num + 1]; 
    is_prime[0] = false;
    is_prime[1] = false;

    // Generate Prime use sieve of Eratosthenes
    for i in 2..=num {
        if is_prime[i] {
            for j in (i * 2..=num).step_by(i) {
                // Delete $i's composite number
                is_prime[j] = false;
            }
        }
    }

    is_prime
}


fn main() -> std::io::Result<()>  {
    // write ans to prime.txt
    let mut file = File::create("prime.txt")?;
    let primes = get_prime(1000);

    for (i, &flag) in primes.iter().enumerate() {
        if flag {
            writeln!(file, "{}", i)?;
        }
    }
    Ok(())
}