#!/bin/bash -e

POD_ID=$(hostname | awk -F '-' '{ print $NF }')

# Generate myid from the hostname of the format "zookeeper-0", "zookeeper-1", etc.
echo $(( $POD_ID + 1 ))  > /data/myid

# Generate the address for all the zookeeper instances
for i in $(seq 0 $((ZOOKEEPER_NODES - 1))); do
  if [[ "$i" == "$POD_ID" ]]; then
    echo "server.$((i + 1))=0.0.0.0:2888:3888" >> /configs/zoo.cfg
  else
    echo "server.$((i + 1))=zookeeper-$i.zookeeper-headless:2888:3888" >> /configs/zoo.cfg
  fi
done
