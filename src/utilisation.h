#include <sys/types.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#ifdef ARCH_X86
#ifdef _MSC_VER
#include <intrin.h>
#else
#include <x86intrin.h>
#endif
#endif

#define PROFILE_CONTEXT_COST 300

/* Timer data is held in a struct like this */
struct timer_buffer_t
{
    uint64_t idle;
    uint64_t total;
};

static inline uint64_t
aarch64_get_cycles(void)
{
    uint64_t tsc;
    asm volatile("mrs %0, cntvct_el0" : "=r"(tsc));
    return tsc;
}


#ifdef ARCH_X86
static inline uint64_t
x86_get_cycles()
{
    //     unsigned int lo, hi;
    //     __asm__ __volatile__("rdtsc" : "=a"(lo), "=d"(hi));
    //     return ((uint64_t)hi << 32) | lo;
    // }

    // ===
    // _mm_lfence();  // optionally wait for earlier insns to retire before reading the clock
    return __rdtsc();
    // _mm_lfence();  // optionally block later instructions until rdtsc retires
}

#endif

int start_CPU_util();