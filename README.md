# Endokken

Generates HTML documentation for your Atom package from [AtomDoc][atomdoc] comments in your code and your GitHub project's own Markdown files.

## Command-Line Interface

You can simply run the `endokken` command from the root directory of your Atom package and it will generate HTML documentation in the `./docs` directory.

```sh
$ endokken
```

Endokken also supports the following command-line options:

* `--metadata [FILENAME]` Dumps the AtomDoc metadata to the file name you provide or `api.json` if no filename is given.
* `--help` Displays command-line help

## Copyright

Copyright &copy; 2014-2015 by [Lee Dohm][lee-dohm]. See [LICENSE][license] for details.

[atomdoc]: https://github.com/atom/atomdoc
[lee-dohm]: http://www.lee-dohm.com
[license]: https://github.com/lee-dohm/endokken/blob/master/LICENSE.md
