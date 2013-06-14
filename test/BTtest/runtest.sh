#!/bin/bash
# 8213:
#	S40G2017 sub31462
#	S37G2115 sub28224
# 6702DM: S51G86 sub7990
#	  S37G49 sub5968
#  	  S43G11 sub5562

snap=$1
fofid=$2
echo snap=$1 fofid=$2

./follow_fof.mean $1 $2 
./follow_fof.minpotH $1 $2 
./follow_fof.potW $1 $2 

for CoreFrac in 0.01 0.04 0.111 0.25 0.51
do
./follow_fof.core $snap $fofid $CoreFrac 
done

for MassRelax in 10 5 3 2 1.4
do
	./follow_fof.adpt $snap $fofid $MassRelax 1 
done


./follow_fof.local $1 $2 2 

for skip in 2 5 10
do
	./follow_fof.adpt $snap $fofid 2 $skip 
done

