#!/bin/bash
if [ "$1" == "sync" ]
then
    if [ -z "$RABBIT_MGMT_URL" ] || [ -z "$RABBIT_MGMT_USER" ] || [ -z "$RABBIT_MGMT_PASS" ]; then
        echo "Please ensure RABBIT_MGMT_URL, RABBIT_MGMT_USER, and RABBIT_MGMT_PASS are set."
        exit 1
    fi
    if [ ! -d "$HOME/.rabbitcache" ]
    then
        mkdir "$HOME/.rabbitcache"
    fi
    echo "Targeting $RABBIT_MGMT_URL/api/queues"
    echo ""
    curl -i -u "$RABBIT_MGMT_USER:$RABBIT_MGMT_PASS" "$RABBIT_MGMT_URL/api/queues" | tail -n +10 | jq . > "$HOME/.rabbitcache/rabbit-cache.json"
fi

if [ "$1" == "clean" ]
then
    if [ -d "$HOME/.rabbitcache" ]
    then
        echo "Removing .rabbitcache from $HOME/"
        rm -rf "$HOME/.rabbitcache"
    else
        echo "No .rabbitcache found to remove"
    fi
fi

if [ "$1" == "count" ]; then
    if [ ! -f "$HOME/.rabbitcache/rabbit-cache.json" ]; then
        echo "Please run a \"rabbit sync\""
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "Please pass a queue count threshold as the next argument."
        exit 1
    fi

    echo ""

    threshold="$2"
    cache=$(jq ".[] | select(.messages_ready > $threshold).name,select(.messages_ready > $threshold).vhost,select(.messages_ready > $threshold).messages_ready,select(.messages_ready > $threshold).message_bytes_persistent,select(.messages_ready > $threshold).message_bytes_ram,select(.messages_ready > $threshold).message_bytes" "$HOME/.rabbitcache/rabbit-cache.json")

    counter=0
    while read -r line; do
        if [ -z "$line" ]; then
            echo "End of results."
            exit 0
        fi
        if [ $counter -eq 0 ]; then
            echo "Queue Name: $line"
            counter=$((counter+1))
        elif [ $counter -eq 1 ]; then
            echo "vHost: $line"
            counter=$((counter+1))
        elif [ $counter -eq 2 ]; then
            echo "Queued Messages: $line"
            counter=$((counter+1))
        elif [ $counter -eq 3 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes on Disk: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 4 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes in Memory: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 5 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Total Message Bytes: ${mb}MB"
            counter=0
            echo ""
        fi                        
    done <<< $cache
fi

if [ "$1" == "disk" ]; then
    if [ ! -f "$HOME/.rabbitcache/rabbit-cache.json" ]; then
        echo "Please run a \"rabbit sync\""
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "Please pass a disk threshold in MB as the next argument."
        exit 1
    fi

    echo ""
    
    threshold="$2"
    threshold=$((threshold * 1024 * 1024))
    cache=$(jq ".[] | select(.message_bytes_persistent > $threshold).name,select(.message_bytes_persistent > $threshold).vhost,select(.message_bytes_persistent > $threshold).messages_ready,select(.message_bytes_persistent > $threshold).message_bytes_persistent,select(.message_bytes_persistent > $threshold).message_bytes_ram,select(.message_bytes_persistent > $threshold).message_bytes" "$HOME/.rabbitcache/rabbit-cache.json")

    counter=0
    while read -r line; do
        if [ -z "$line" ]; then
            echo "End of results."
            exit 0
        fi
        if [ $counter -eq 0 ]; then
            echo "Queue Name: $line"
            counter=$((counter+1))
        elif [ $counter -eq 1 ]; then
            echo "vHost: $line"
            counter=$((counter+1))
        elif [ $counter -eq 2 ]; then
            echo "Queued Messages: $line"
            counter=$((counter+1))
        elif [ $counter -eq 3 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes on Disk: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 4 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes in Memory: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 5 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Total Message Bytes: ${mb}MB"
            counter=0
            echo ""
        fi                        
    done <<< $cache
fi

if [ "$1" == "memory" ]; then
    if [ ! -f "$HOME/.rabbitcache/rabbit-cache.json" ]; then
        echo "Please run a \"rabbit sync\""
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "Please pass a memory threshold in MB as the next argument."
        exit 1
    fi

    echo ""
    
    threshold="$2"
    threshold=$((threshold * 1024 * 1024))
    cache=$(jq ".[] | select(.message_bytes_ram > $threshold).name,select(.message_bytes_ram > $threshold).vhost,select(.message_bytes_ram > $threshold).messages_ready,select(.message_bytes_ram > $threshold).message_bytes_persistent,select(.message_bytes_ram > $threshold).message_bytes_ram,select(.message_bytes_ram > $threshold).message_bytes" "$HOME/.rabbitcache/rabbit-cache.json")

    counter=0
    while read -r line; do
        if [ -z "$line" ]; then
            echo "End of results."
            exit 0
        fi
        if [ $counter -eq 0 ]; then
            echo "Queue Name: $line"
            counter=$((counter+1))
        elif [ $counter -eq 1 ]; then
            echo "vHost: $line"
            counter=$((counter+1))
        elif [ $counter -eq 2 ]; then
            echo "Queued Messages: $line"
            counter=$((counter+1))
        elif [ $counter -eq 3 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes on Disk: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 4 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes in Memory: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 5 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Total Message Bytes: ${mb}MB"
            counter=0
            echo ""
        fi                        
    done <<< $cache
fi

if [ "$1" == "size" ]; then
    if [ ! -f "$HOME/.rabbitcache/rabbit-cache.json" ]; then
        echo "Please run a \"rabbit sync\""
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "Please pass a queue size threshold in MB as the next argument."
        exit 1
    fi

    echo ""
    
    threshold="$2"
    threshold=$((threshold * 1024 * 1024))
    cache=$(jq ".[] | select(.message_bytes > $threshold).name,select(.message_bytes > $threshold).vhost,select(.message_bytes > $threshold).messages_ready,select(.message_bytes > $threshold).message_bytes_persistent,select(.message_bytes > $threshold).message_bytes_ram,select(.message_bytes > $threshold).message_bytes" "$HOME/.rabbitcache/rabbit-cache.json")

    counter=0
    while read -r line; do
        if [ -z "$line" ]; then
            echo "End of results."
            exit 0
        fi
        if [ $counter -eq 0 ]; then
            echo "Queue Name: $line"
            counter=$((counter+1))
        elif [ $counter -eq 1 ]; then
            echo "vHost: $line"
            counter=$((counter+1))
        elif [ $counter -eq 2 ]; then
            echo "Queued Messages: $line"
            counter=$((counter+1))
        elif [ $counter -eq 3 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes on Disk: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 4 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Message Bytes in Memory: ${mb}MB"
            counter=$((counter+1))
        elif [ $counter -eq 5 ]; then
            mb=$(echo "scale=2; $line / 1024 / 1024" | bc -l)
            echo "Total Message Bytes: ${mb}MB"
            counter=0
            echo ""
        fi                        
    done <<< $cache
fi