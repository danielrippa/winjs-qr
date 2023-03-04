
  { qr-encode } = winjs.load-library 'WinjsQR.dll'

  { new-boolean-matrix } = dependency 'BooleanMatrix'
  { new-block-matrix } = dependency 'BlockMatrix'

  qr-matrix = qr-encode process.args.3

  size = qr-matrix.length

  boolean-matrix = new-boolean-matrix size, size

  for x til qr-matrix.length
    for y til qr-matrix[x].length
      if qr-matrix[x][y]

        boolean-matrix.set x, y

  lines = new-block-matrix boolean-matrix

  process.io.stdout lines * '\n'
