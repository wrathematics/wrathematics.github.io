#!/bin/sh

rm *.md
cp ../../../script/_posts/*.html .

#cp a.bak a.html

for f in `ls *.html`; do
  nm=`echo $f | sed -e 's/.html//'`
  
  sed -i -e '/^author:/,/^---/{/^author/!{/^---/!d}}' $f
  sed -i -e "s/author:/author: wrathematics/" $f
  
  sed -i -e '/^meta:/,/^author/{/^meta/!{/^author/!d}}' $f
  sed -i -e "/^meta:/d" $f
  
  
  header=`sed -n '/^---/,/^---/p' $f`
  sed -i -e '/^---/,/^---/{//!d}' $f
  sed -i -e "s/^---//g" $f
  pandoc $f -o tmp.md
  echo "$header" > ${nm}.md
  echo "\n" >> ${nm}.md
  cat tmp.md >> ${nm}.md
  rm tmp.md
  
  sed -i -e 's/\\\[sourcecode language=\"/\`\`\`/g' ${nm}.md
  sed -i -e 's/"\\\]//g' ${nm}.md
  sed -i -e 's/\\\[\/sourcecode\\]/\`\`\`/g' ${nm}.md
  
  sed -i -e 's/\\n/\n/g' ${nm}.md
  sed -i -e "s/&lt;/</g" ${nm}.md
  sed -i -e 's/\\\#/#/g' ${nm}.md
  sed -i -e 's/\\\\+/\+/g' ${nm}.md
  sed -i -e 's/\\\-/-/g' ${nm}.md
  sed -i -e 's/\\\*/*/g' ${nm}.md
  sed -i -e 's/\\\[/\[/g' ${nm}.md
  #sed -i -e 's/\\\\//\//g' ${nm}.md
  sed -i -e "s/%7B%7B%20/{{ /g" ${nm}.md
  sed -i -e "s/%20%7D%7D/ }}/g" ${nm}.md
  sed -i -e "s/&gt;/>/g" ${nm}.md
  sed -i -e 's/\\\]/\]/g' ${nm}.md
  sed -i -e 's/\\_/_/g' ${nm}.md
  sed -i -e 's/\\^/^/g' ${nm}.md
  
  
  gawk -i inplace -v RS="\0" -v ORS="" '{gsub(/\\\n/,"\n")}7' ${nm}.md
  
  
  
#  head ${nm}.md -n 84 | tail -n 15
  
done

rm *.html
