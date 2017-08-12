augroup VHexResponse
    au!
    autocmd TextChanged *.vhex call VHexUpdateCursor()
    autocmd CursorMovedI *.vhex call VHexUpdateCursor()
augroup END

augroup VHexDetect
    au!
    autocmd BufRead,BufNewFile *.vhex set filetype=vhex
augroup END

command! -nargs=1 -complete=file LoadHex call LoadHex("<args>")
command! -nargs=1 -complete=file StoreHex call StoreHex("<args>")
command! -nargs=0 DisplayHex call DisplayHex()
command! -nargs=0 ParseHex call ParseHex()


