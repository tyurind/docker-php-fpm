#!/bin/bash
# set -e

DIR=$( cd $( dirname "${BASH_SOURCE[0]}" ) && pwd )
cd "$DIR"

_parse()
{
	INPUT_FILE=$1
	OUTPUT_FILE=$2

	echo;
	echo "Input : $INPUT_FILE"
	sed -n 's/### <include> /   Include: /p' $INPUT_FILE


	sed -e '
/Dockerfile-core/ {
r inc/Dockerfile-core
d}
/Dockerfile-php/ {
r inc/Dockerfile-php
d}
/Dockerfile-phar/ {
r inc/Dockerfile-phar
d}
/Dockerfile-clear/ {
r inc/Dockerfile-clear
d}
/postgres.inc/ {
r inc/postgres.inc
d}
' $INPUT_FILE > $OUTPUT_FILE
}


find . -name Dockerfile-init -print | while read i; do
	output_file=`dirname $i`/Dockerfile
	_parse $i $output_file
	echo "Output: $output_file"
done


# find . -name Dockerfile-init -print | while read i; do
    # sed -n '/### <include> /p' $i
    # echo $i
# done

# sed -n '/### <include> /p' Dockerfile-init | while read i; do
# 	# sed "/${i}/r ${i}"
# 	f=$(echo $i | sed 's/### <include> //g')
# 	p=$(basename $f)
# 	# echo $i
# 	echo $f
# 	# echo $p
# 	# echo ${f//'/'/\''/'}
# 	sed -i "/${p}/ {r ${f}
# d}" Dockerfile

# 	cat Dockerfile
# 	echo "================================="
# done
