"#####################
"# VIM CONFIGURATION #
"#####################

"Add scripts to path :
let $PATH = $PATH . ':' . $HOME . '/.vim/scripts'

"-------------------------------------------------------------------------
"Color and font
so $VIMRUNTIME/colors/desert.vim

" Font
set gfn=Monospace\ 9

" enable syntax highlighting
syntax on

"Disable printer
set printexpr=

"-------------------------------------------------------------------------
" Various
"Allow special Vim improvements like multiple-undo
set nocompatible

"Set improve Backspace
set bs=2

"No warning when existing swap file is found.
set shortmess+=A 
"Show the current edition mode on last line, number of column and line
set showmode
set ruler
set nu
set ls=2

"Mouse popup
set mousemodel=popup_setpos

" Set indentation corresponding to filetype
filetype on
filetype indent on
filetype plugin on

" Make command line two lines high
"set ch=2

" Highlight search strings
set hlsearch

" Smartcase : if lower search both else only written case
"set ignorecase
"set smartcase

" "search as we type" on
set incsearch

" cindent option
set cinoptions=t0,(0,l1,g0,hs,:0,W4

" I starts at the first non-blank character
set cpoptions+=H

" highlighting strings inside C comments
let c_comment_strings=1

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set list listchars=tab:‣ ,trail:·,nbsp:→,extends:↷,precedes:↶
au BufWritePre * :%s/ / /gce

"---------------------------------------------------------------------------
" Mapping
map <F2>          :call Show80col(-1)<CR>
map <F3>          :TlistUpdate<CR>
map <F4>          :TlistToggle<CR>
map <F5>          ^i/* <C-[>$a */<C-[>
map <F6>          ^3x$2h3x
map <F7>          :bdelete<CR>
map <F8>          :AsyncMake<CR>
map <F9>          :cp<CR>
map <F10>         :cn<CR>
map <C-N>         :noh<CR>
map <C-Del>       :bdelete<CR>
map <C-PageUp>    [c
map <C-PageDown>  ]c

map ,l            :so ~/.vimrc<CR>
map ,#            :s/^/#/<CR><C-N>
map ,/            :s@^@//@<CR><C-N>
map ,"            :s@^@"@<CR><C-N>
map ,c            :set filetype=c<CR>
map ,z            :set filetype=zsh<CR>
map ,m            :set filetype=make<CR>
map ,t            :!tal<CR>
map ,r            :redraw!<CR>
map ,i            :set diffopt+=iwhite<CR>
map ,w            :set diffopt-=iwhite<CR>

" --------------------------------------------------------------------------
" Cscope
autocmd GUIEnter * call Cscope_init()
function! Cscope_init()
    if has("cscope")
        " change this to 1 to search ctags DBs first
        set csto=0
        set cst
        set nocsverb
        "cd  /usr/local/home/sch/nsv-tangox
        let dir=system('vc-find-rootfolder')

        if !v:shell_error
            execute "cd " . dir
        elseif filereadable("cscope.out")
            cd .
        elseif ($DIR != "")
            cd $DIR
        "else
         "   let dir = input("Please specify workset dir :", ".", "dir")
          "  execute "cd " . dir
        endif
        cs add cscope.out
        set csverb

        " Using 'CTRL-AltGr \' then a search type makes the vim window
        " "shell-out", with search results displayed on the bottom

        nmap <C-\>s  :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g  :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c  :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t  :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e  :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f  :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i  :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d  :cs find d <C-R>=expand("<cword>")<CR><CR>

        vmap <C-\>s  <Esc>:cs find s <C-R>*<CR>
        vmap <C-\>g  <Esc>:cs find g <C-R>*<CR>
        vmap <C-\>c  <Esc>:cs find c <C-R>*<CR>
        vmap <C-\>t  <Esc>:cs find t <C-R>*<CR>
        vmap <C-\>e  <Esc>:cs find e <C-R>*<CR>
        vmap <C-\>f  <Esc>:cs find f <C-R>*<CR>
        vmap <C-\>i  <Esc>:cs find i <C-R>*<CR>
        vmap <C-\>d  <Esc>:cs find d <C-R>*<CR> 
        " Using 'CTRL-AltGr ^' then a search type makes the vim window
        " split horizontally, with search result displayed in
        " the new window.

        nmap <C-^>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-^>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-^>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-^>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-^>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-^>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-^>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-^>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

    endif
endfunction


"--------------------------------------------------------------------------
" Omnicompletion, needs tags
set omnifunc=ccomplete#Complete
set shiftwidth=4 softtabstop=4 tabstop=8 expandtab
set completeopt=menuone,longest,preview

set tags+=./tags

"---------------------------------------------------------------------------
" tab completion from tags or cscope
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] =~ '\s'
        return "\<Tab>"
    elseif "backward" == a:direction
        return "\<C-P>"
    else
        return "\<C-N>"
    endif
endfunction

inoremap <Tab> <C-R>=InsertTabWrapper("forward")<cr>
inoremap <s-tab> <C-R>=InsertTabWrapper("backward")<cr>
inoremap <leader><Tab> <Tab>

"Completion in commands like 
cnoremap <Tab> <C-L><C-D>


"open git gui blame
function CallGitGuiBlame()
    let file = bufname('%')
    let line = line('.')
    echo 'Calling git gui blame for' . file . ' at line ' . line 
    execute '!git gui blame  --line=' . line . ' ' . file . ' &' 
endfunction

command -nargs=0 GGB call CallGitGuiBlame()
map <Leader>b :GGB<CR> 

" Mini buffer explorer plugin
" -------------------------------------------------------------------------
let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMaxSize = 1

" Do not save modified buffer when switching
set hidden


"---------------------------------------------------------------------------
" Diff style
if &diff
    au BufWritePost * diffupdate
endif

highlight DiffText guifg=black 


"---------------------------------------------------------------------------
"Highlight when line > 80 columns

let g:isshow = 0

function! Show80col(active)
    if a:active == -1
        let active = !g:isshow
    else
        let active = a:active
    endif
    if active == 1
        let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
        let g:isshow = 1
        highlight link ExtraWhitespace Error
        echo 'Showing lines with more than 80 columns'
    else
        if exists("w:m2")
            call matchdelete(w:m2)
        endif
        let g:isshow = 0
        highlight link ExtraWhitespace NONE
        "syntax reset
        "so $VIMRUNTIME/colors/desert.vim
        echo 'Hiding lines with more than 80 columns'
    endif
endfunction

"---------------------------------------------------------------------------
"Rename plugin

noremap <Leader>rc :call Renamec()<CR> 
noremap <Leader>rf :call Renamef()<CR> 

"---------------------------------------------------------------------------
"Switch buffer
if !&diff 
    map <C-PageUp> :bN<CR>
    map <C-PageDown> :bn<CR>
endif


"-------------------------------------------------------------------------

let g:netrw_altv = 1
let g:netrw_alto = 1

"-----------------------------------------------------------------------------------
" Doxygen syntax and toolkit
let g:load_doxygen_syntax=1
let g:DoxygenToolkit_compactDoc="yes"
let doxygen_end_punctuation='¤'
"let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
set formatoptions+=ro

map ,d           :Dox<CR>


noremap K K<CR>
"-------------------------------------------------------------------------
" force use of tabs in Makefiles and python
au FileType *
            \ set softtabstop=4 expandtab
         
au FileType make,python
            \ set noexpandtab
         
" Remove newline added by vim automatically at end-of-file
set noeol

"Compilation in vim
command -complete=dir -nargs=+ Make silent make V=1 -C <args> | cwindow 15
command -nargs=0 Maka silent make V=1 | cwindow 15
"Mapping to close auto open cwindow (<C-W>c works only if focus on cwindow)
map <C-W>u        :cclose<CR>
map <C-W><C-U>    :cclose<CR>

command -nargs=0 Tags silent execute "!tags.sh &" 

function HT(path)
    for line in readfile(a:path)
        execute line
    endfor
endfunction

au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent highlight link c_f Function
au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent highlight c_t gui=bold,italic
au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent highlight link c_d Tag
au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent highlight link c_m Tag
au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent highlight link c_e Tag
"au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent! call HT("tags_hl")
au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent! so tags_hl
"au bufnewfile,bufread *.c,*.h,*.cpp,*.patch    silent call Show80col(1)

au bufnewfile,bufread *.js runtime syntax/doxygen.vim

"Update tags and syntax highlighting at each save
au BufWritePost *.c,*.h,*.js* Tags
au BufWritePost *.c,*.h,*.js* silent cs reset
"au BufWritePost *.c,*.h syntax clear
"au BufWritePost *.c,*.h silent! so tags_hl
"au BufWritePost *.c,*.h silent! call HT("tags_hl")
"au BufWritePost *.c,*.h runtime syntax/c.vim
"au BufWritePost *.c,*.h,*.js runtime syntax/doxygen.vim

autocmd BufRead *.json set ft=javascript

let g:JSLintHighlightErrorLine = 1

map <C-\>r :silent call MyGrep(expand("<cword>"), '')<CR>

function MyGrep(pattern, path)
    execute 'noa vimgrep /' . a:pattern . '/gj ' . a:path . '/** | cw'
endfunction
command -nargs=+ -complete=dir Grep silent call MyGrep(<f-args>)

autocmd BufRead,BufNewFile *.wiki           setfiletype Wiki
autocmd BufRead,BufNewFile *.wikipedia.org* setfiletype Wiki
autocmd BufRead,BufNewFile *.js set cinoptions-=:0

autocmd BufRead,BufNewFile COMMIT_EDITMSG set spell

" Show trailing whitespace:
au BufRead,BufNewFile,BufWritePost *.c,*.h,*.js syntax match ExtraWhitespace /\s\+$/
" Show trailing whitepace and spaces before a tab:
au BufRead,BufNewFile,BufWritePost *.c,*.h,*.js syntax match ExtraWhitespace /\s\+$\| \+\ze\t/
" Show tabs that are not at the start of a line:
au BufRead,BufNewFile,BufWritePost *.c,*.h,*.js syntax match ExtraWhitespace /[^\t]\zs\t\+/
" Show indent using tab
au BufRead,BufNewFile,BufWritePost *.c,*.h,*.js syntax match ExtraWhitespace /^\t\+/
"Show > 80 col 
"au BufRead,BufNewFile,BufWritePost *.c,*.h,*.js syntax match ExtraWhitespace /\%>80v.\+/

" Show spaces used for indenting (so you use only tabs for indenting).
"match ExtraWhitespace /^\t*\zs \+/
