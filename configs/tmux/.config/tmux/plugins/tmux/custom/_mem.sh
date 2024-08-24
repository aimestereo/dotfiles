# Description: Get the amount of available memory on the system

FREE_BLOCKS=$(vm_stat | grep free | awk '{ print $3 }' | sed 's/\.//')
INACTIVE_BLOCKS=$(vm_stat | grep inactive | awk '{ print $3 }' | sed 's/\.//')
SPECULATIVE_BLOCKS=$(vm_stat | grep speculative | awk '{ print $3 }' | sed 's/\.//')

FREE=$(echo "($FREE_BLOCKS + $SPECULATIVE_BLOCKS) * $(pagesize) / 1048576" | bc -l)
INACTIVE=$(echo "$INACTIVE_BLOCKS * $(pagesize) / 1048576" | bc -l)
TOTAL=$(echo "$FREE + $INACTIVE" | bc -l)

# echo Free: "$FREE" MB
# echo Inactive: "$INACTIVE" MB
# echo Total free: "$TOTAL" MB

# Free: 82 MB
# Inactive: 5093 MB
# Total free: 5175 MB

# example output: 5.4
echo "$TOTAL / 1024" | bc -l | xargs printf "%.1f"
