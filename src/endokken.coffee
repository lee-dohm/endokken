#!/usr/bin/env coffee

ClassPage = require './class-page'

page = new ClassPage
  name: 'BugReport'
  description: """
    Provides a system whereby the user can create and easily post high-quality bug reports.

    This system also allows other packages to report their bugs through the `bug-report` package.
  """

console.log(page.render())
