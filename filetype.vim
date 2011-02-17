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
augroup END

let &cpo = s:cpo_save
unlet s:cpo_save
