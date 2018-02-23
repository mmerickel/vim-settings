" :help new-filetype
if exists("did_load_filetypes")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

augroup filetypedetect
    au! BufRead,BufNewFile *.txx setf cpp
    au! BufRead,BufNewFile *.mako setf mako
    au! BufRead,BufNewFile SConstruct setf python
    au! BufRead,BufNewFile SConscript setf python
    au! BufRead,BufNewFile *.jt,*.jinja2 setf htmljinja
    au! BufRead,BufNewFile *.as setf actionscript
    au! BufRead,BufNewFile *.sls setf yaml
    au! BufRead,BufNewFile *.md setf markdown
    au! BufRead,BufNewFile Vagrantfile setf ruby
    au! BufRead,BufNewFile *.rs setf rust
    au! BufRead,BufNewFile Podfile,*.podspec setf ruby
    au! BufRead,BufNewFile wscript setf python
    au! BufRead,BufNewFile Fastfile setf ruby
    au! BufRead,BufNewFile Appfile setf ruby
    au! BufRead,BufNewFile Deliverfile setf ruby
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
