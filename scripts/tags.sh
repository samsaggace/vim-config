#!/bin/bash --norc
renice 10 -p $$

if [ ! -e ~/.tags_running ] || [ $[`date +%s` - `date +%s -r ~/.tags_running`] -gt 600 ]; then
    touch ~/.tags_running
    #git grep --cached -Ile '' > cscope.files
    #if [ $? -ne 0 ]; then
        find . -name "build"  -prune -o -name "vendor" -prune -o -name "pgsql0" -prune -o -name "pgsql_token0" -prune \
            -o -type l -prune -o -name "cscope*" -prune \
            -o \( -name "*.[ch]" -o -name "*.[ch]pp" -o -name "*.js" -o -name "*.json" -o -name "*.idl" \
            -o -name "Makefile" -o -name "*.mk" -o -name "*.ini" -o -name "*.httpd"  -o -name "*.php" \
            -o -name "*.html" -o -name "*.in" -o -name "*.conf" -o -name "*.html.tmpl" -o -name "bconf.txt.*" \
            -o -name "*.pp" -o -name "Builddesc" -o -name "*.out"  -o -name "*.css" -o -name "*.sh" -o -name "*.py" \
            -o -name "*.rb" \) \
            -print > cscope.files
    #fi
    cscope -kRb
    ~/sources/ctags/ctags -R --fields=+lStn --extra=+f --tag-relative=yes --exclude=.git --links=no -L cscope.files -f tags.tmp
    mv -f tags.tmp tags
    sed -n '/^\(\w\+\)\t[^"]*\"\t\(t\|f\|d\|e\).*language:C.*$/ s//syntax keyword c_\2 \1/p' tags | sort -u > tags_hl.tmp
    mv -f tags_hl.tmp tags_hl
    rm ~/.tags_running
fi
