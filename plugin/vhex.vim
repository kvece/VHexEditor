augroup VHexResponse
    au!
    autocmd TextChanged *.vhex call vhex#VHexUpdateCursor()
    autocmd CursorMovedI *.vhex call vhex#VHexUpdateCursor()
augroup END

augroup VHexDetect
    au!
    autocmd BufRead,BufNewFile *.vhex set filetype=vhex
augroup END

command! -nargs=1 -complete=file LoadHex call vhex#LoadHex("<args>")
command! -nargs=1 -complete=file StoreHex call vhex#StoreHex("<args>")
command! -nargs=0 DisplayHex call vhex#DisplayHex()
command! -nargs=0 ParseHex call vhex#ParseHex()


