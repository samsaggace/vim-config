#!/bin/bash --norc
renice 10 -p $$

if [ ! -e ~/.running ] || [ $[`date +%s` - `date +%s -r ~/.running`] -gt 600 ]; then
    touch ~/.running
    find . -name "dist" -prune  -o  -name ".git" -prune  -o -name "objs" -prune -o -type l -prune \
        -o \( -name "*.[ch]" -o -name "*.js" -o -name "*.json" -o -name "*.idl" \
             -o -name "Makefile" -o -name "*.mk" -o -name "*.ini" -o -name "*.httpd" \
           \) \
        -print > cscope.files
    cscope -kRb 
    ctags -R --fields=+lStn --extra=+f --tag-relative=yes --exclude=objs --exclude=dist -f tags.tmp 
    mv -f tags.tmp tags
    sed -n '/^\(\w\+\)\t[^\"]*\"\t\(t\|f\|d\|e\).*language:C.*$/ s//syntax keyword c_\2 \1/p' tags | sort -u > tags_hl.tmp
    mv -f tags_hl.tmp tags_hl
    rm ~/.running
fi
