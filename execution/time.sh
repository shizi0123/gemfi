#!/bin/bash
my_child=$1
echo "$my_child"
while  kill -0 $my_child ;
do
  IFS=' '
  _time=$(ps -o stime,time $my_child)
  echo "$_time"
  array=($_time)
  string=${array[2]}
  OIFS=$IFS
  IFS=':'
  real_time=($string)
  hour=${real_time[0]}
  hour=`echo $hour|sed 's/^0*//'`
  min=${real_time[1]}
  min=`echo $min|sed 's/^0*//'`
  sec=${real_time[2]}
  sec=`echo $sec|sed 's/^0*//'`
  total_time=$((hour*3600+min*60+sec))
  IFS=$OIFS
  if [ "$total_time" -gt "7200" ]; then
    echo "kill my child"
    kill -15 $my_child
  fi
  IFS=$'\t'
  size=$(du -s ./start)
  _size=($size)
  actual_size=${_size[0]}
  IFS=$OIFS
  echo "size $actual_size"
  if [ "$actual_size" -gt "8000" ]; then
    echo "kill my child (size to big)"
    kill -15 $my_child
    if [ -d start ]; then
      cd start
      rm *
      touch "oversized experiments"
      cd ..
    fi
  fi
 sleep 30
done

