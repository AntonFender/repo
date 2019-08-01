#!/bin/bash

modules=(
'fsrarid'
'parsenattnresponse'
'logger'
'getlink'
'extractnattns'
'getcomment'
'extractrests'
'readmarks'
)

clear
for it in ${modules[@]}
do
    g++ -std=c++11 -o ../bin/$it.o ./$it.cpp
done
