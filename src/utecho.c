// Combined TCP and UDP echo program.
// Matt Rossouw
// 07/12/2022

#include "utecho.h"
#include "utilisation.h"
#include <pthread.h>

static void usage()
{
    printf("USAGE: utecho [port] [mode] [RCV BUF size]\n Modes: tcp, udp");
    exit(-1);
}

void *CPU_util_thread(void *arg)
{
    start_CPU_util();
}

int main(int argc, const char *argv[])
{
    if (argc != 4)
        usage();
    int port = atoi(argv[1]);
    int recv_buf_size = atoi(argv[3]);

    // Set mode
    int mode = 0;
    if (strcmp(argv[2], "tcp") == 0)
    {
        mode = MODE_TCP;
    }
    else if (strcmp(argv[2], "udp") == 0)
    {
        mode = MODE_UDP;
    }
    else
    {
        printf("Unknown socket mode \n");
        exit(0);
    }
    char buf[BUFFER_SIZE];

    // pthread_t ithr0;
    // pthread_create(&ithr0, NULL, &CPU_util_thread, NULL);
    // // start_CPU_util();
    // printf("Here\n");
    switch (mode)
    {
    case MODE_TCP:
        tcpEcho(port, buf, BUFFER_SIZE);
        break;
    case MODE_UDP:
        udpEcho(port, buf, BUFFER_SIZE, recv_buf_size);
        break;
    }

    return 0;
}