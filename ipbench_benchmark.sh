#!/bin/bash

CLIENTS="vb01 vb02 vb03 vb04 vb05 vb06 vb07 vb08 vb09 vb10"
# CLIENTS="vb01"

TX2="10.13.1.74"
haswell3="172.16.1.50"
haswell4="10.13.1.73"
zynq7000="10.13.1.51"
sabre="10.13.1.137"
imx8mq="150.229.124.112"
imx8mm="172.16.0.10"
vb103="10.13.1.225"
vb09="10.13.1.206"

#TEST_TARGET=$haswell3
TEST_TARGET=$vb103
TARGET=$TEST_TARGET

# THROUGHPUT_RANGE="1000000000"
#THROUGHPUT_RANGE="20000000 40000000 60000000 80000000 100000000 120000000 150000000 180000000 200000000 210000000 220000000"
# THROUGHPUT_RANGE="800000000 900000000 1000000000 1100000000 1200000000 1300000000 1400000000 1500000000 1600000000 1700000000 1800000000 1900000000 2000000000 2500000000 3000000000 3500000000 4000000000"
THROUGHPUT_RANGE="800000000 900000000 1000000000  1200000000  1400000000  1600000000  1800000000  2000000000 2500000000 3000000000 3500000000 4000000000 4500000000 5000000000 5500000000 6000000000 6500000000 7000000000 7500000000 8000000000 8500000000 9000000000 9500000000 10000000000"
# THROUGHPUT_RANGE="100000000 200000000 300000000 400000000 500000000 600000000 700000000 800000000 900000000 1000000000 1100000000"

PACKET_SIZE_RANGE="1472"
#WARMUP_TIME=10
#COOLDOWN_TIME=10
SOCKTYPE="udp"
TARGET_PORT="1234"
#TARGET_PORT="7"
OUTPUT_FILE='output.csv'
SAMPLES=200000
#SAMPLES=20

for client in $CLIENTS
do
  CLIENT_ARGS=$CLIENT_ARGS" --client $client"
  NUM_CLIENTS=$((NUM_CLIENTS + 1))
done

echo "$CLIENT_ARGS"
echo "$NUM_CLIENTS"

echo "Requested_Throughput,Receive_Throughput,Send_Throughput,Packet_Size,Minimum_RTT,Average_RTT,Maximum_RTT,Stdev_RTT,Median_RTT,CPU_utilisation" > $OUTPUT_FILE

for throughput in $THROUGHPUT_RANGE
do
  for packetsize in $PACKET_SIZE_RANGE
  do
    echo Running $throughput bps, size $packetsize
    START_TIME=$SECONDS
    RESULT=`ipbench -d -p 8036 $CLIENT_ARGS --test-target="$TEST_TARGET" --test-port="$TARGET_PORT" --test="latency" --test-args="socktype=$SOCKTYPE,bps=$(($throughput/$NUM_CLIENTS)),size=$packetsize,warmup=$WARMUP_TIME,cooldown=$COOLDOWN_TIME,samples=$(($SAMPLES/$NUM_CLIENTS))" --target-test=cpu_target_lukem --target-test-hostname=$TEST_TARGET --target-test-port=8037`

    #RESULT=`ipbench -d -p 8036 $CLIENT_ARGS --test-target="$TEST_TARGET" --test-port="$TARGET_PORT" --test="discard" --test-args="bps=$(($throughput/$NUM_CLIENTS)),size=$packetsize,warmup=$WARMUP_TIME,cooldown=$COOLDOWN_TIME,test_time=20,ifname=eth0,proto=udp" --target-test=cpu_target_lukem --target-test-hostname=$TEST_TARGET --target-test-port=1236`

    echo $RESULT
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    echo $ELAPSED_TIME

    if [ "`echo $RESULT | grep '*'`" = "" ] ; then
    echo $RESULT   >> $OUTPUT_FILE
    else
    echo $RESULT >> $OUTPUT_FILE
    break;
    fi
    
    echo Done.
  done
done
