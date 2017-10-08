command! -nargs=1 -complete=file LoadHex call vhex#LoadHex("<args>")
command! -nargs=1 -complete=file StoreHex call vhex#StoreHex("<args>")
command! -nargs=0 DisplayHex call vhex#DisplayHex()
command! -nargs=0 ParseHex call vhex#ParseHex()
