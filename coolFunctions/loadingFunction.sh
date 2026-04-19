echo -n "["
    loadingLoopCount=40
    while [ $loadingLoopCount -ge 0 ]; do
    echo -n .
    sleep 0.04
    loadingLoopCount=$((loadingLoopCount - 1))
done
echo "]"
