if exists("b:current_syntax")
    finish
endif

syntax match HexSeparater "|"
highlight link HexSeparater Operator

syntax match HexByte "\v[0-9a-f]{2}"
highlight link HexByte Statement

syntax match AsciiByte "[2-7][0-9a-f]"
highlight link AsciiByte Type

syntax match NullByte "00"
highlight link NullByte Constant

syntax match HexAddress "\v[0-9a-f]*:"
highlight link HexAddress Comment
