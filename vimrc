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
"   ------ *> FuzzyFinder
"   ------ *> NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode
set nocompatible

"Invoke pathogen to load extra plugins
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect(g:vim_local.'/bundle/{}')
call pathogen#helptags()

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

"Update time for various features
set updatetime=1000

" always show the signcolumn otherwise coc will hide/show it all the time
set signcolumn=yes

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
set copyindent
set cino=:0,g0

"Use multiple of shiftwidth when indenting with '<' and '>'
set shiftround

"Wrap lines
set wrap

"Avoid adding 2 spaces when joining lines together.
set nojoinspaces

"Make < and > match
set matchpairs+=<:>

"Enable extended % matching
runtime macros/matchit.vim

"Allow the cursor to go everywhere
set virtualedit=insert,onemore,block

set formatoptions-=t
set formatoptions+=c
set formatoptions+=r
set formatoptions+=q
" Remove comment leaders when joining lines
set formatoptions+=j

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

"Redraw the window
nnoremap <leader>rr :redraw!<cr>

"Remap ` and ' for marking
nnoremap ' `
nnoremap ` '

"Make Y consistent with C and D by yanking up to end of line
nnoremap Y y$

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
set list
nnoremap <silent> <leader>s :set nolist!<cr>

"Toggle line numbers
nnoremap <leader>n :set nu!<cr>

"Yank text to the OS X clipboard
noremap <leader>y "*y
noremap <leader>yy "*Y

"Yank the entire buffer into the z register
nnoremap <leader>ya ggvG$"zy

" Preserve indentation while pasting text from the OS X clipboard
noremap <leader>p :set paste<CR>:put  *<CR>:set nopaste<CR>

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

"Function to execute a file beginning with a shebang
function! RunShebang()
  if (match(getline(1), '^\#!') == 0)
    :!./%
  else
    echo "No shebang in this file."
  endif
endfunction
nnoremap <leader>ex :call RunShebang()<CR>

"Open ripgrep window to search whole project
nnoremap <leader>/ :Rg 

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !exists("autocommands_loaded")
    let autocommands_loaded = 1

    "Reload vimrc when GUI is started
    if has("gui_running")
        autocmd GUIEnter * exec 'source '.g:vim_local.'/vimrc'
    endif

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
    "autocmd FileType * set omnifunc=syntaxcomplete#Complete
    "autocmd FileType python set omnifunc=pythoncomplete#Complete
    "autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
    "autocmd FileType javascript.jsx set omnifunc=javascriptcomplete#CompleteJS
    "autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType css set omnifunc=csscomplete#CompleteCSS

    autocmd FileType html,css,scss,sass,javascript,javascript.jsx,htmljinja setlocal sw=2 ts=2 et
    autocmd FileType json setlocal sw=2 ts=2 et
    autocmd FileType jsonnet setlocal sw=2 ts=2 et
    autocmd FileType yaml setlocal sw=2 ts=2 et

    autocmd FileType rst setlocal sw=2 ts=2 et foldmethod=manual

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

"Set background
set background=dark
" let g:gruvbox_contrast_dark = "hard"
" let g:gruvbox_contrast_light = "hard"
" colorscheme gruvbox
" colorscheme molokai
colorscheme codedark

if has("gui_running")
    if g:mysys == "mac"
        set guifont=Inconsolata:h14
    elseif g:mysys == "dos"
        set guifont=Consolas:h12
    endif
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set terminal title
set title

"Highlight the current line and column
set cursorline
set cursorcolumn

"Set # of lines visible around the cursor when scrolling vertically
set scrolloff=3

"Turn on Wild Menu
set wildmenu

"Completion similarly to shell
set wildmode=list:longest,full

"Ignore some files
set wildignore+=*.jpg,*.gif,*.png,*.hdr,*.gz
set wildignore+=*.o,*.obj,*.so,*.a,*.dll,*.dylib
set wildignore+=.DS_Store,Thumbs.db
set wildignore+=*.svn,*.git,*.swp,*.pyc,*.class,*/__pycache__/*,*/.ruff_cache/*

"Always show current position
set ruler

"Command bar is 2-high
set cmdheight=1

"Show line number
set number

"Do not redraw when running macros .. lazyredraw
"set lazyredraw

"Change buffer without saving
set hidden

"Switch to existing tab then window when switching buffers
set switchbuf=usetab

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
set completeopt=menuone,longest,preview

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

"Do not fold blocks by default
set foldmethod=manual

"Setup higlighting of whitespace that shouldn't be there
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

"Setup highlighting of lines longer than 80 characters
"highlight OverLength ctermbg=red ctermfg=white guibg=red
"2match OverLength /\%>80v.\+/

if v:version >= 703
    "Highlight the column to avoid long lines
    set colorcolumn=81
    highlight ColorColumn ctermbg=8 guibg=#222222

    "Show the relative number instead of absolute line number
    "set relativenumber
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Ctrl-P
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    nnoremap <leader>ff :CtrlP<cr>
    nnoremap <leader>fb :CtrlPBuffer<cr>
    let g:ctrlp_switch_buffer = 1
    let g:ctrlp_max_files = 0
    let g:ctrlp_max_depth = 50
    "If the CWD has git submodules, try to set working path based on
    "the CWD instead of the local submodule
    let g:ctrlp_working_path_mode = 'ra'
    if executable('fd')
        let g:ctrlp_user_command = 'fd --type f --hidden --exclude .git --exclude .hg --exclude .svn --color never "" %s'
        let g:ctrlp_use_caching = 0
    endif

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => HTML Indent
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:html_indent_inctags = "html,body,head,tbody"
    let g:html_indent_script1 = "inc"
    let g:html_indent_style1 = "inc"

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => NERDTree
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let NERDTreeIgnore = [
        \ '\.jpg$', '\.gif$', '\.png$', '\.hdr$', '\.gz$'
        \ , '\.o$', '\.obj$', '\.so$', '\.a$', '\.dll$', '\.dylib$'
        \ , '\.svn$', '\.git$', '\.swp$', '\.pyc$', '\.DS_Store'
        \ , '\.class$', '__pycache__', '.ruff_cache' ]
    let NERDTreeWinPos = "right"
    let NERDTreeQuitOnOpen = 0
    let NERDTreeHighlightCursorline = 1
    let NERDTreeDirArrows = 0
    let NERDTreeMinimalUI = 1
    let NERDTreeShowHidden = 1
    nnoremap <leader>do :NERDTreeToggle<cr>

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => JSX
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:jsx_ext_required = 0

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => CSV
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:csv_no_conceal = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => Command-T
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:CommandTSmartCase = 1
    let g:CommandTFileScanner = 'watchman'
    let g:CommandTWildIgnore = &wildignore .",*/node_modules,*/build,*/venv,*/env,*/.git/*"

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => ripgrep
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:rg_highlight = 1
    let g:rg_derive_root = 1

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => rooter
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    let g:rooter_cd_cmd = 'lcd'
    let g:rooter_patterns = ['.git', '.hg', '.svn']
    let g:rooter_buftypes = ['']

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " => CoC
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Use tab for trigger completion with characters ahead and navigate
    " NOTE: There's always complete item selected by default, you may want to enable
    " no select by `"suggest.noselect": true` in your configuration file
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config
    inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
    inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    " Make <CR> to accept selected completion item or notify coc.nvim to format
    " <C-g>u breaks current undo, please make your own choice
    inoremap <silent><expr> <CR>
        \ coc#pum#visible() ? coc#pum#confirm()
        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Highlight the symbol and its references when holding the cursor
    autocmd CursorHold * silent call CocActionAsync('highlight')

    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Attempt to bind hotkeys for floating windows
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif
