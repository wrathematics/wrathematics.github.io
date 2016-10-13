#!/bin/sh

for f in `ls *.md`; do
#  sed -i -e "s/%7B%7B%20/{{ /g" $f
#  sed -i -e "s/20%7D%7D/ }}/g" $f
  #sed -i -e "s/baseurl%/baseurl/g" $f
  sed -i -e 's/\\^/^/g' $f
  #sed -i -e 's/\\\]/\]/g' $f
done
