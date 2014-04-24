#!/bin/sh

for i in ./tex/*.tex
do
    sed -f sed_tex2uni $i > tmp/`basename $i`
done

for i in ./tmp/*.tex
do
    sed -i -e 's/^ *//; s/ *$//; /^%/d' $i
    cat $i | sed -e '/^\\looseness=-*[0-9] *$/d; /^\\index[[][^]]\+[]][{].\+[}] *$/d;' |\
    sed -e 's/\(\w\)\\-\(\w\)/\1\2/g; s/\\noindent//; s/\\clearpage//; s/\\ldots\\/\&hellip;/g; s/\\ldots[{][}]/\&hellip;/g; s/\\\\/<br \/>/g; s/\\linebreak\\//g; s/\\linebreak[{][}]\\//g; s/\\thinspace//g;' |\
    sed 's/\\section[*]*[{]\([^}]\+\)[}]/<h3 class="section">\1<\/h3>/g' |\
    sed 's/\\subsection[*]*[{]\([^}]\+\)[}]/<h3 class="subsection">\1<\/h3>/g' |\
    sed 's/\\qaitem[{]\([^}]\+\)[}]/<i>\1<\/i>/g' |\
    sed '/^\\vspace[*][{][^}]\+[}] *$/d' |\
    sed 's/\\vspace[*]*[{][^}]\+[}]//g' |\
    sed -e '1{/./{s/^/<p>\n/}}; 1{/^$/{s/^/<p>/}};' |\
    sed -e '${/./{s/$/\n<\/p>/}}; ${/^$/{s/$/<\/p>/}};' |\
    sed 's/\\mbox[{]\([^}]\+\)[}]/\1/g' |\
    sed 's/\\glsdisp[{]\([^}]\+\)[}][{]\([^}]\+\)[}]/<a class="glslink" href="glossary.html#\1">\2<\/a>/g' |\
    sed 's/\\glslink[{]\([^}]\+\)[}][{]\([^}]\+\)[}]/<a class="glslink" href="glossary.html#\1">\2<\/a>/g' |\
    sed -e 's/\\dropcaps[{]\([^}]\+\)[}][{]\([^}]\+\)[}]/\1\2/; s/\\pali[{]\([^}]\+\)[}]/<i>\1<\/i>/g; s/\\textit[{]\([^}]\+\)[}]/<i>\1<\/i>/g;' |\
    sed 's/\\footnote[{]\([^}]\+\)[}]/<span class="footnote">\1<\/span>/g' |\
    sed -e 's/\\begin[{]verse[}]/<p class="verse">/g; s/\\end[{]verse[}]/<\/p>/g;' |\
    sed -f sed_chars |\
    sed 's/^$/<\/p><p>/' > $i.html
done
