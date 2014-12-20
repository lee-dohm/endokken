ClassPage = require '../src/class-page'

describe 'ClassPage', ->
  it 'accepts an AtomDoc class object', ->
    classPage = new ClassPage
      name: 'BugReport'
      summary: 'Provides a system whereby the user can create and easily post high-quality bug
                reports.'

    expect(classPage.object).toEqual
      name: 'BugReport'
      summary: 'Provides a system whereby the user can create and easily post high-quality bug
                reports.'

  it 'creates a title based on the class name', ->
    classPage = new ClassPage
      name: 'BugReport'

    expect(classPage.locals.title).toEqual 'Endokken: BugReport'

  it 'creates a description section if a description is present', ->
    classPage = new ClassPage
      name: 'BugReport'
      description: 'foo'

    expect(classPage.locals.descriptionSection).toBeDefined()
