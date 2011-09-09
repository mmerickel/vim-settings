""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
" ----------------------
"   *> General Setup
"   *> Text Options
"   *> Mappings
"   *> Autocommands
"   *> File Formats
"   *> Colors and Fonts
"   *> User Interface
"   *> Plugin Configuration
"   ------ *> Alternate
"   ------ *> ctags
"   ------ *> FuzzyFinder
"   ------ *> MatchIt
"   ------ *> Minibufexpl
"   ------ *> NERDTree
"   ------ *> Tag List
"   ------ *> ShowMarks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode
set nocompatible

"Set how many lines of history VIM remembers
set history=1000

"Enable filetype plugin
filetype on
filetype plugin on
filetype indent on

"Set to auto read when a file is changed from the outside
set autoread

"Turn backup off
set nobackup
set noswapfile

"Use 'ack' for grep
set grepprg=ack
set grepformat=%f:%l:%m

"Update time for various features
set updatetime=1000

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Expand tabs into spaces
set expandtab
set tabstop=4
set shiftwidth=4

set smarttab
set linebreak

"Auto indent
set autoindent
set cino=:0,g0

"Wrap lines
set wrap

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set mapleader
let mapleader = ","

"Remap the semicolon to save typing colon
nnoremap ; :

"Turn off search highlighting
nnoremap <leader>h :nohlsearch<cr>

"Close the current buffer
nnoremap <leader>x :close!<cr>

"Resize the window
nnoremap <leader>el :set columns=220<cr>

"Resize the window
nnoremap <leader>ej :set columns=130<cr>

"Resize the window
nnoremap <leader>eh :set columns=90<cr>

"Remap ` and ' for marking
nnoremap ' `
nnoremap ` '

"Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

"Move between buffers with arrow keys
nnoremap <right> :bnext<cr>
nnoremap <left> :bprev<cr>

"A little bit of Emacs-style navigation.
inoremap <C-a> <home>
inoremap <C-e> <end>
nnoremap <C-a> 0
nnoremap <C-e> $

"Simplify omnicompletion
inoremap <C-space> <C-x><C-o>

"Enable resaving a file as root with sudo
cmap w!! w !sudo tee % >/dev/null

"Modify a few commands to work on local lines in a wrapped line
noremap k gk
noremap j gj
noremap H g^
noremap L g$

"Fast editing of .vimrc
nnoremap <leader>ev :exec ':e! '.g:vim_local.'/vimrc'<cr>

"Display the end of lines and tabs as special characters
set listchars=tab:>-,trail:+,eol:$
nnoremap <silent> <leader>s :set nolist!<cr>

"Toggle line numbers
nnoremap <leader>n :set nu!<cr>

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"
    let l:pattern = escape(@", "\\/.*$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")
    if a:direction == "b"
        execute "normal ?" . l:pattern . "^M"
    else
        execute "normal /" . l:pattern . "^M"
    endif
    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch("f")<CR>
vnoremap <silent> # :call VisualSearch("b")<CR>

" Remap TAB to insert spaces if there is text preceding the cursor
function! InsertTab()
    if strpart(getline('.'), 0, col('.') - 1) =~ '\S'
        let num_spaces = &ts - (virtcol('.') - 1) % &ts
        return repeat(' ', num_spaces)
    else
        return "\<tab>"
    endif
endfunction

inoremap <tab> <c-r>=InsertTab()<cr>

" function to regenerate all tag types (ctags, cscope) for cwd
function! RegenerateTags()
    let tags = []
    " use the ctags found by taglist if it exists
    if exists('g:Tlist_Ctags_Cmd')
        let ctags = g:Tlist_Ctags_Cmd
    else
        let ctags = 'ctags'
    endif

    if executable(ctags)
        call system(ctags . ' -R --c++-kinds=+p --fields=+iaS --extra=+q --python-kinds=-i .')
        if (v:shell_error)
            echoerr "Error executing ctags"
        else
            call add(tags, ctags)
        endif
    endif

    if executable('cscope')
        " TODO
    endif

    echomsg "Tags generated: " . join(tags, ', ')
endfunction
nnoremap <leader>rt :call RegenerateTags()<CR>

"Function to execute a file beginning with a shebang
function! RunShebang()
  if (match(getline(1), '^\#!') == 0)
    :!./%
  else
    echo "No shebang in this file."
  endif
endfunction
nnoremap <leader>ex :call RunShebang()<CR>

"Switch CWD based on current file
nnoremap <leader>cd lcd %:p:h<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    "Reload vimrc when GUI is started
    if has("gui_running")
        autocmd GUIEnter * exec 'source '.g:vim_local.'/vimrc'
    endif
    
    "Switch CWD based on current file
    "autocmd BufEnter * lcd %:p:h
    
    "When vimrc is edited, reload it
    autocmd BufWritePost vimrc exec 'source '.g:vim_local.'/vimrc'
    
    "Refresh syntax highlighting when buffer is entered or written
    autocmd BufEnter * syntax sync fromstart
    autocmd BufWritePost * syntax sync fromstart
    
    " Have Vim jump to the last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif

    function! SetMakeProg()
        set makeprg=make
        if filereadable("Makefile")
            set makeprg=make
        elseif filereadable("SConstruct")
            set makeprg=scons
        endif
    endfunction
    autocmd BufEnter * call SetMakeProg()

    "Avoid showing whitespace while in insert mode
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd BufEnter,BufRead,BufNewFile,InsertLeave * match ExtraWhitespace /\s\+$/

    "Expand tabs
    "autocmd BufEnter,BufNewFile *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx set expandtab
    "autocmd BufLeave *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx set expandtab&

    "Enable cindent
    autocmd BufEnter,BufNewFile *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx,*.m,*.mm,*.java set cindent
    autocmd BufLeave *.c,*.cpp,*.h,*.hpp,*.cxx,*.hxx,*.m,*.mm,*.java set cindent&

    "Enable omni completion
    autocmd FileType * set omnifunc=syntaxcomplete#Complete
    autocmd FileType python set omnifunc=pythoncomplete#Complete
    autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css set omnifunc=csscomplete#CompleteCSS

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => File Formats
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos,mac

"Default to LaTeX
let g:tex_flavor = "latex"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn on syntax highlighting
syntax on

"Set background to light
"set background=dark
colorscheme molokai

if has("gui_running") && g:mysys == "mac"
    set guifont=Inconsolata:h14
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set terminal title
set title

"Set # of lines visible around the cursor when scrolling vertically
set scrolloff=3

"Turn on Wild Menu
set wildmenu

"Completion similarly to shell
set wildmode=list:longest,full

"Always show current position
set ruler

"Command bar is 2-high
set cmdheight=1

"Show line number
set number

"Do not redraw when running macros .. lazyredraw
set lazyredraw

"Change buffer without saving
set hidden

"Set backspace to work in more situations
set backspace=eol,start,indent

"Ignore case when searching
set ignorecase
set infercase

"Use case-sensitive search if a capital letter is present
set smartcase

"Search dynamically
set incsearch

"Highlight search items but turn it off when program starts
set hlsearch
nohlsearch

"Set magic!
set magic

"Turn off all sound on errors
set noerrorbells
set novisualbell
set vb t_vb=

"Show matching brackets
set showmatch

"How many tenths of a second to blink
set mat=2

"Set window size if using a GUI
if has("gui_running") && !exists('gui_resized')
    let gui_resized = 1

    set lines=60
    set columns=90
endif

"Insert-mode completion option
set completeopt=longest,menuone,preview

"Remove a lot of visual effects like scrollbar/menu/tabs from GUI
set guioptions=a

"Always hide the statusline
set laststatus=0

"Show as much of the last line as possible
set display=lastline

"Show a little more status about running command
set showcmd

"Show more context when completing ctags
set showfulltag

"Setup higlighting of whitespace that shouldn't be there
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

"Setup highlighting of lines longer than 80 characters
"highlight OverLength ctermbg=red ctermfg=white guibg=red
"2match OverLength /\%>80v.\+/

if v:version >= 730
    "Highlight the column to avoid long lines
    set colorcolumn=85

    "Show the relative number instead of absolute line number
    set relativenumber
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Alternate
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    nnoremap <leader>a :Ack 

    let g:alternateNoDefaultAlternate = 1

    "Add some support for ObjC
    let g:alternateExtensions_m = "h"
    let g:alternateExtensions_h = "m,c,cpp,cxx,cc,CC,tcc,txx"
    let g:alternateExtensions_hpp = "cpp,cxx,cc,CC,tcc,txx"
    let g:alternateExtensions_cpp = "h,hpp"
    let g:alternateExtensions_tcc = "h,hpp"
    let g:alternateExtensions_txx = "h,hpp"

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Coverage
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    nnoremap <leader>co :HiglightCoverage<CR>
    nnoremap <leader>noco :HiglightCoverageOff<CR>

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => ctags
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    set tags+=./tags,tags

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => FuzzyFinder
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    nnoremap <leader>ff :FufFile **/<cr>
    nnoremap <leader>fb :FufBuffer<cr>
    nnoremap <leader>ft :FufTag<cr>
    nnoremap <leader>fj :FufJumpList<cr>

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => MatchIt
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    source $VIMRUNTIME/macros/matchit.vim

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Minibufexpl
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let loaded_minibufexplorer = 1 " disable explorer
    let g:miniBufExplMapWindowNavVim = 1
    let g:miniBufExplMapCTabSwitchBufs = 1
    let g:miniBufExplModSelTarget = 1
    let g:miniBufExplSplitBelow = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => NERDTree
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let NERDTreeIgnore = [
        \ '\.jpg$', '\.gif$', '\.png$', '\.hdr$', '\.img\.gz$'
        \ , '\.o$', '\.obj$', '\.so$', '\.a$', '\.dll$', '\.dylib$'
        \ , '\.svn$', '\.git$', '\.swp$', '\.pyc$', '\.DS_Store'
        \ , '\.class$' ]
    let NERDTreeWinPos = "right"
    let NERDTreeQuitOnOpen = 0
    let NERDTreeHighlightCursorline = 1
    nnoremap <leader>dc :NERDTreeClose<cr>
    nnoremap <leader>do :NERDTreeToggle<cr>

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Tag List
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let Tlist_Close_On_Select = 1
    let Tlist_GainFocus_On_ToggleOpen = 1
    let Tlist_Process_File_Always = 1
    let Tlist_Inc_Winwidth = 0
    let Tlist_WinWidth = 50
    let Tlist_Display_Prototype = 0
    nnoremap <leader>t :TlistToggle<cr>

    "Add support for an ObjC-enabled ctags
    let tlist_objc_settings = 'ObjC;P:protocols;i:interfaces;' .
        \ 'I:implementations;M:instance methods;C:implementation methods;' .
        \ 'Z:protocol methods;d:macro;g:enum;s:struct;u:union;t:typedef;' .
        \ 'v:variable;f:function'

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => ShowMarks
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:showmarks_include='abcdefghijklmnopqrstuvwxyz'
    let g:showmarks_ignore_type='hmrpq'

