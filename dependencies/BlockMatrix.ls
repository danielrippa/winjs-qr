
  do ->

    { new-boolean-matrix } = dependency 'BooleanMatrix'
    { lower-half, upper-half, empty-block, full-block } = dependency 'UnicodeBlocks'

    new-block-matrix = (boolean-matrix) ->

      rows = []

      for x from 1 til boolean-matrix.height + 1 by 2

        row = []

        for y til boolean-matrix.width + 1

          upper = boolean-matrix.get x - 1, y
          lower = boolean-matrix.get x, y

          row[*] = match upper, lower

            | off, off => empty-block
            | on,  off => upper-half
            | off, on  => lower-half
            | on,  on  => full-block

        rows[*] = row * ''

      rows

    {
      new-block-matrix
    }