#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <stdint.h>

// Assembly implementation
void sin_x87(double* input, double* output, uint64_t length);

void sin_stdlib(double* input, double* output, uint64_t length) {
    for (uint64_t i = 0; i < length; i++) {
        output[i] = sin(input[i]);
    }
}

int main() {
    // arr length
    uint64_t length = 1000000000;

    // alloc respective arrays
    double* input = malloc(length * sizeof(double));
    double* output_asm = malloc(length * sizeof(double));
    double* output_c = malloc(length * sizeof(double));

    // fill array with rand values between 0 and 100
    for (uint64_t i = 0; i < length; i++) {
        input[i] = ((double)rand() / RAND_MAX) * 100;
    }

    clock_t start = clock();
    sin_x87(input, output_asm, length);
    clock_t end = clock();
    // clock ticks -> milliseconds
    double time_asm = ((double)(end - start)) / CLOCKS_PER_SEC * 1000;

    start = clock();
    sin_stdlib(input, output_c, length);
    end = clock();
    double time_c = ((double)(end - start)) / CLOCKS_PER_SEC * 1000;

    printf("sin_x87 took %.lf ms\n", time_asm);
    printf("sin_stdlib took %.lf ms\n", time_c);

    free(input);
    free(output_asm);
    free(output_c);

    return 0;
}