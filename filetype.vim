if exists('did_load_filetypes')
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile $HOME/wiki/cheat/* setf cheat
augroup END
