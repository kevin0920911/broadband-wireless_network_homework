#include <stdio.h>
#include <stdlib.h>
#define NUM 1000

int* getPrime(int n){
    // n: get the primes of 1-n

    // Init array
    int* preimes = (int*)malloc(sizeof(int) * (n + 1));
    for (int i=2; i<=n; i++) preimes[i] = 1;
    preimes[0] = 0; preimes[1] = 0;
    
    // Generate Prime use sieve of Eratosthenes
    for (int i=2; i<=n; i++){
        if (preimes[i]){
            for (int j=i+i; j<=n; j+=i){
                preimes[j] = 0;
            }
        }
    }
    return preimes;
}

int main() {
    int* preimes = getPrime(NUM); 
    FILE* FP = fopen("prime.txt", "w"); 

    for (int i=0; i<=NUM; i++){
        if (preimes[i]) {
            fprintf(FP, "%d\n", i);
        }
    }
    free(preimes);
    return 0;
}