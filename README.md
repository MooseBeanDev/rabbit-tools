# rabbit-tools

Copies rabbit queue info to a local cache and enables health based queries for finding problem queues.

## Table of Contents
- [Overview](#overview)
- [Installation and Usage](#installation-and-usage)

## Overview
This project will query the RabbitMQ Management API using curl, copy the results to a local json cache, and allow you to pull useful information from it locally with global visibility.

## Installation and Usage
Clone and move to somewhere in your PATH
```
cp rabbit-tools.sh /usr/local/bin/rabbit-tools
chmod 755 /usr/local/bin/rabbit-tools
chown root:root /usr/local/bin/rabbit-tools
```

Set Env Variables and pull the api data down to local json files. located in /home/USER/.rabbitcache/
```
export RABBIT_MGMT_URL=https://rabbitmq-mgmt.yourorg.net
export RABBIT_MGMT_USER=admin
export RABBIT_MGMT_PASS=your-password

rabbit-tools sync
```

Clear cache
```
rabbit-tools clean
```

Show all queues with greater than X amount of messages
```
rabbit-tools count X

#for example this will search for all queues with more than 5000 messages
$rabbit-tools.sh count 5000

Queue Name: "TestQueue1"
vHost: "e0a4fdb2-70e0-4a91-91d0-2fe98d48ce54"
Queued Messages: 8629
Message Bytes on Disk: 0MB
Message Bytes in Memory: 3.32MB
```

Show all queues with greater than X amount queue size in MB (disk and memory together)
```
rabbit-tools size X

#for example this will search for all queues with more than 50MB of messages
$rabbit-tools.sh size 50

Queue Name: "TestQueue2"
vHost: "e0a4fdb2-70e0-4a91-91d0-2fe98d48ce54"
Queued Messages: 12424
Message Bytes on Disk: 25MB
Message Bytes in Memory: 30MB
```

Show all queues with greater than X amount of persistent disk space used in MB
```
rabbit-tools disk X

#for example this will search for all queues with more than 50MB of messages written to disk
$rabbit-tools.sh disk 50

Queue Name: "TestQueue3"
vHost: "e0a4fdb2-70e0-4a91-91d0-2fe98d48ce54"
Queued Messages: 14381
Message Bytes on Disk: 70MB
Message Bytes in Memory: 0MB
```

Show all queues with greater than X amount of memory used in MB
```
rabbit-tools memory X

#for example this will search for all queues with more than 10MB of messages written to memory
$rabbit-tools.sh memory 10

Queue Name: "TestQueue4"
vHost: "d95de498-f7c3-43ad-8a2e-a767821d352c"
Queued Messages: 1047
Message Bytes on Disk: 0MB
Message Bytes in Memory: 17.28MB
```

