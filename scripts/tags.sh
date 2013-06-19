#!/bin/bash --norc
renice 10 -p $$

if [ ! -e ~/.running ] || [ $[`date +%s` - `date +%s -r ~/.running`] -gt 600 ]; then
    touch ~/.running
    find . -name "dist" -prune  -o  -name ".git" -prune  -o -name "objs" -prune \
        -o -name "out" -prune -o -name "out0" -prune \
        -o -name "clientsv4" -prune  \
        -o -type l -prune \
        -o \( -name "*.[ch]" -o -name "*.[ch]pp" -o -name "*.js" -o -name "*.json" -o -name "*.idl" \
             -o -name "Makefile" -o -name "*.mk" -o -name "*.ini" -o -name "*.httpd" \
           \) \
        -print > cscope.files
    find dist/hw/*/include -name "*.h" >> cscope.files
    cscope -kRb 
    ctags -R --fields=+lStn --languages=c,javascript,make,sh,c++ --extra=+f --tag-relative=yes --exclude=objs --exclude=dist \
        --exclude=out --exclude=out0 --exclude=.git --exclude=clientsv4 --links=no -f tags.tmp 
    mv -f tags.tmp tags
    sed -n '/^\(\w\+\)\t[^"]*\"\t\(t\|f\|d\|e\).*language:C.*$/ s//syntax keyword c_\2 \1/p' tags | sort -u > tags_hl.tmp
    mv -f tags_hl.tmp tags_hl
    rm ~/.running
fi
