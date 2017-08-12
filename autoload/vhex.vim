" VHexMode Plugin

if exists("g:vhex_mode_init")
    finish
endif

let g:vhex_mode_init = 1

if has("python")
    set pyx=2
    let g:vhex_mode_python = 1
elseif has("python3")
    set pyx=3
    let g:vhex_mode_python = 1
else
    let g:vhex_mode_python = 0
endif

if g:vhex_mode_python
    pyx import vim
endif

let g:vhex_mode_addresses = get(g:, "vhex_mode_addresses", 1)
let g:vhex_mode_width = get(g:, "vhex_mode_width", 4)
let g:vhex_mode_line_width = get(g:, "vhex_mode_line_width", 4)
let g:vhex_mode_ascii = get(g:, "vhex_mode_ascii", 1)

function! LoadHex(fname)
pyx << _EOF_

fname = vim.eval("a:fname")

with open(fname, 'rb') as f:
    data = f.read()

data = map(ord, data)
vim.command("let b:hex_data = " + str(data))

_EOF_
endfunction

function! StoreHex(fname)
pyx << _EOF_

fname = vim.eval("a:fname")
data = vim.eval("b:hex_data")
data = "".join(map(chr, map(int, data)))

with open(fname, 'wb') as f:
    f.write(data)

_EOF_
endfunction

function! DisplayHex()
    let pos = 0
    let ascii = 0
    let lines = []
    let char_map = [
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \' ', '!', '"', '#', '$', '%', '&', "'",
        \'(', ')', '*', '+', ',', '-', '.', '/',
        \'0', '1', '2', '3', '4', '5', '6', '7',
        \'8', '9', ':', ';', '<', '=', '>', '?',
        \
        \'@', 'A', 'B', 'C', 'D', 'E', 'F', 'G',
        \'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
        \'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
        \'X', 'Y', 'Z', '[', '\\', ']', '^', '_',
        \'`', 'a', 'b', 'c', 'd', 'e', 'f', 'g',
        \'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o',
        \'p', 'q', 'r', "s", 't', 'u', 'v', 'w',
        \'x', 'y', 'z', '{', '|', '}', '~', '.'
        \
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.'
        \
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.',
        \'.', '.', '.', '.', '.', '.', '.', '.'
    \]
    if exists("b:hex_data")

        for b in b:hex_data
            if (pos % (g:vhex_mode_width*g:vhex_mode_line_width) ) == 0
                if g:vhex_mode_addresses
                    let lines += [printf("%08x: ", pos)]
                    let ascii = ""
                else
                    let lines += [""]
                    let ascii = ""
                endif
            endif

            if ((pos) % g:vhex_mode_width) == 0
                let lines[-1] .= " "
            endif
            let lines[-1] .= printf("%02x", b)

            if g:vhex_mode_ascii
                let ascii .= char_map[b]
                if (pos+1) % (g:vhex_mode_width*g:vhex_mode_line_width) == 0
                    let lines[-1] .= " | " . ascii
                endif
            endif

            let pos += 1
        endfor

        if g:vhex_mode_ascii
            while pos % (g:vhex_mode_width*g:vhex_mode_line_width) != 0
                let lines[-1] .= "  "
                if pos % g:vhex_mode_width == 0
                    let lines[-1] .= " "
                endif
                let pos += 1
            endwhile
            let lines[-1] .= " | " . ascii
        endif

        pyx vim.current.buffer[:] = vim.eval("lines")

    endif
endfunction

function! ParseHex()
pyx << _EOF_

lines = vim.current.buffer[:]

str_bytes = []
valid_chars = "0123456789abcdefABCDEF"

for l in lines:
    splice_beg = l.find(":") + 1
    if splice_beg < 0:
        splice_beg = 0
    splice_end = l.find("|")
    l = l[splice_beg:splice_end]
    str_bytes += "".join(l.split())

str_bytes = "".join(c for c in str_bytes if c in valid_chars)

if len(str_bytes) % 2:
    if len(str_bytes) > 1 and str_bytes[-1] != "0":
        str_bytes += "0"
    else:
        str_bytes = str_bytes[:-1]

it = iter(str_bytes)
hex_data = " ".join(a+b for a,b in zip(it,it))
def int16(i):
    return int(i, 16)
hex_data = map(int16, hex_data.split())

vim.command("let b:hex_data = " + str(hex_data))

_EOF_
endfunction

function! VHexUpdateCursor()
pyx << _EOF_

row,col = vim.current.window.cursor
l = vim.current.buffer[row]
beg = l.find(":") + 1
if beg < 0:
    beg = 0

while col < len(l) and l[col] == " ":
    col = col+1

if col >= len(l) or l[col] == "|":
    row += 1
    col = beg

l = vim.current.buffer[row]
while col < len(l) and l[col] == " ":
    col = col+1

vim.current.window.cursor = (row,col)

_EOF_
    call ParseHex()
    call DisplayHex()
endfunction
