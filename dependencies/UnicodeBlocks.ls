
  do ->

    char = -> String.from-char-code it

    unicode = -> 0x2500 + it

    upper-half = char unicode 0x80
    lower-half = char unicode 0x84
    full-block = char unicode 0x88
    empty-block = ' '

    {
      upper-half, lower-half,
      full-block, empty-block
    }