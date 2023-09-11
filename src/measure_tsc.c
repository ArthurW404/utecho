#include <stdint.h>
#include <stdlib.h>
#include <math.h>
#include <stdio.h>
#include "utilisation.h"
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#define SAMPLE_NUM 200000
int main()
{
    uint64_t max_diff = 0;

    uint64_t *samples = calloc(SAMPLE_NUM, sizeof(uint64_t));
    uint64_t prev = x86_get_cycles();
    for (int i = 0; i < SAMPLE_NUM; ++i)
    {
        uint64_t curr = x86_get_cycles();
        samples[i] = curr - prev;
        if (samples[i] > max_diff)
            max_diff = samples[i];
        prev = curr;
    }

    uint64_t total = 0;
    uint64_t x_minux_mean_2 = 0;

    FILE *fp;

    fp = fopen("cycle.txt", "w");

    for (int i = 0; i < SAMPLE_NUM; ++i)
    {
        // fprintf(fp, "samples[%d],%" PRIu64 "\n", i, samples[i]);
        fprintf(fp, "%" PRIu64 "\n", samples[i]);
        total += samples[i];
    }
    fclose(fp);

    uint64_t mean = total / SAMPLE_NUM;

    for (int i = 0; i < SAMPLE_NUM; i++)
    {
        uint64_t diff = (samples[i] - mean);
        x_minux_mean_2 += diff * diff;
    }
    double std = sqrt(x_minux_mean_2 / SAMPLE_NUM);
    printf("Mean = %" PRIu64 "\n", mean);

    printf("std = %lf\n", std);
    printf("samples[0] = %d\n", samples[0]);
    printf("max_diff = %d\n", max_diff);

    return 0;
}