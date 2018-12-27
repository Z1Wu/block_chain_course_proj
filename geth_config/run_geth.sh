if [ "$1" = "" ]
then

echo "run geth on localhost"

./geth.exe -datadir data0 \
-networkid 719 -rpc -rpcaddr 127.0.0.1 \
--rpcapi personal,db,eth,net,web3 -rpccorsdomain "*" \
--preload ./autoMining.js console

else 

echo "run geth on $1"

./geth.exe -datadir data0 \
-networkid 719 -rpc -rpcaddr $1 \
--rpcapi personal,db,eth,net,web3 -rpccorsdomain "*" \
--preload ./autoMining.js console

fi
