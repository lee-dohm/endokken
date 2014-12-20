DescriptionSection = require '../src/description-section'

describe 'DescriptionSection', ->
  it 'accepts text and renders it', ->
    section = new DescriptionSection('foo')

    expect(section.render()).toEqual """
    <h2>Description</h2>
    <p>foo</p>

    """
