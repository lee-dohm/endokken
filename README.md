# Endokken [![Build Status](https://travis-ci.org/lee-dohm/endokken.svg?branch=master)](https://travis-ci.org/lee-dohm/endokken) [![Dependency Status](https://david-dm.org/lee-dohm/endokken.svg)](https://david-dm.org/lee-dohm/endokken)

Generates HTML documentation for your Atom package from [AtomDoc][atomdoc] comments in your code and your GitHub project's own Markdown files.

## Command-Line Interface

You can simply run the `endokken` command from the root directory of your Atom package and it will generate HTML documentation in the `./docs` directory.

```sh
$ endokken
```

Endokken also supports the following command-line options:

* `--extension [EXT]` Adds the given extension to all generated documentation files. Defaults to no extension for REST-like purity.
* `--metadata [FILENAME]` Dumps the AtomDoc metadata to the file name you provide or `api.json` if no filename is given.
* `--title [TITLE]` Title of index page, default is name of current directory.
* `--help` Displays command-line help

## Acknowledgements

Endokken was originally envisioned as [YARD][yard] for Atom packages. As such, Endokken owes a lot of its inspiration and ideas to YARD and its author [Loren Segal][lsegal].

## Copyright

Copyright &copy; 2014-2015 by [Lee Dohm][lee-dohm] and [Lifted Studios][lifted]. See [LICENSE][license] for details.

[atomdoc]: https://github.com/atom/atomdoc
[lee-dohm]: http://www.lee-dohm.com
[lifted]: http://www.liftedstudios.com
[lsegal]: https://github.com/lsegal
[license]: https://github.com/lee-dohm/endokken/blob/master/LICENSE.md
[yard]: http://yardoc.org
