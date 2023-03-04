
  dependency = do ->

    shell = winjs.load-library 'WinjsShell.dll'

    file-system = winjs.load-library 'WinjsFileSystem.dll'

    { folder-separator: slash, path-separator } = file-system

    #

    drop-tail = (str, char) ->

      switch str.last-index-of char
        | -1 => str
        | otherwise => str.slice 0, that

    #

    dependency-path-folders = do ->

      env-var-name = 'WINJS_DEPENDENCY_PATH'

      dependency-path = shell.expand-env-var env-var-name

      switch dependency-path

        | '' => []
        | otherwise => that.split path-separator

    candidate-folders = do ->

      get-dependencies-folder = -> "#it#{ slash }dependencies"

      #

      current-folder = file-system.get-current-folder!
      current-dependencies = get-dependencies-folder current-folder

      winjs-folder = process.args.0 `drop-tail` slash
      winjs-dependencies = get-dependencies-folder winjs-folder

      ###

      folders = []

      for folder in [ '', current-folder, current-dependencies ] ++ dependency-path-folders ++ [ winjs-folder, winjs-dependencies ]

        if folder not in folders
          folders[*] = folder

      folders

    #

    load-script = (filename) ->

      file-names = [ filename, "#filename.js" ]

      for folder in candidate-folders

        for file-name in file-names

          full-path = "#folder#slash#file-name"

          if file-system.file-exists full-path

            return winjs.load-script full-path

      throw "Script '#filename' not found"

    #

    get-normalized-dependency-name = (dependency-name) ->

      dependency-name |> _ `drop-tail` '.' |> (.to-lower-case!)

    ###

    dependencies = {}

    (filepath) ->

      dependency-name = get-normalized-dependency-name filepath

      $dependency = dependencies[dependency-name]
      if $dependency is void

        $dependency = load-script filepath
        dependencies[dependency-name] := $dependency

      $dependency

  process.args => if ..length > 2 => dependency ..2
