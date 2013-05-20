Meteor.methods {
  insertPost: (doc) ->
    # doc should contain at minimun: title, content
    # user MUST be logged in this.userId 
    # TODO: verify
    console.log('insertPost', doc)
    doc.authorId = this.userId
    doc.slug = uniqueifySlug createSlug(doc.title)
    Posts.insert doc
}

createSlug = (text) ->
  text = text || ''
  text.toLowerCase().replace(/[^\w ]+/g,'').replace(/\ +/g,'-')


uniqueifySlug = (slug) ->
  # if slug is unique
  if !Posts.findOne({slug:slug}) then return slug

  # get the number suffix if any
  lastDigits = slug.match(/-*([0-9]*)$/)[1] || 0

  # increment and append
  lastDigits = ~~lastDigits + 1
  newSlug = slug.replace(/-*[0-9]*$/, '-' + lastDigits)

  # return new slug after verifying uniqueness
  uniqueifySlug(newSlug)

