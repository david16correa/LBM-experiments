#!/bin/bash

# Infinite loop until break.io is found
while [ ! -f break.io ]; do
    echo "Looking for target.sh..."
    if [ -f target.sh ]; then
        echo "Found target.sh, executing..."
        bash target.sh > target.out 2>&1
        mv target.sh target.done
        echo "Execution complete. Output saved to target.out. Renamed target.sh to target.done."
    fi
    sleep 60  # avoid a tight loop
done

echo "Found break.io. Exiting loop."

