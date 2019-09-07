if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile /tmp/*/cheat/* setf cheat
augroup END
