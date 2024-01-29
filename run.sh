#!/bin/bash
# The complete path of PalServer.sh
PAL_SERVER_SCRIPT_PATH="/home/ubuntu/Steam/steamapps/common/PalServer/PalServer.sh"
MEM_LIMIT=300

# The function to start the PalServer.sh script.
start_pal_server() {
    # Run PalServer.sh in the background as a steam user.
    sudo -u ubuntu bash "$PAL_SERVER_SCRIPT_PATH" &
    echo "PalServer.sh started"
}

serverThread=`ps -ef|grep PalServer-Linux |grep -v "grep"| wc -l`
echo "Current running Threads:$serverThread"
if [ "$serverThread" -ne 0 ]; then
    echo "kill process"
    pkill -9 PalServer
    sleep 10
fi

# Function to check memory and restart.
check_and_restart() {
    serverThread=`ps -ef|grep PalServer-Linux |grep -v "grep"| wc -l`
    echo "Current running Threads:$serverThread"
    if [ "$serverThread" -eq 0 ]; then
        start_pal_server
    fi
    # Get the available memory of the entire system (unit: MB)
    AVAILABLE_MEM=$(free -m | awk '/^Mem:/{print $7}')
    echo "Available Memory - ${AVAILABLE_MEM}MB..."
    # If the available memory is below the limit, restart PalServer.sh.
    if [ "$AVAILABLE_MEM" -lt "$MEM_LIMIT" ]; then
        echo "Memory limit exceeded: Available - ${AVAILABLE_MEM}MB, Limit - ${MEM_LIMIT}MB. Restarting PalServer.sh..."
        pkill -9 PalServer 2>/dev/null
        sleep 10
        start_pal_server
    fi
}


# Set up an infinite loop.
while true; do
    # Check the memory every minute.
    check_and_restart
    sleep 60
done
