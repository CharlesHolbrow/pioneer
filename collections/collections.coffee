# Posts
#   title
#   content
#   slug
#   author
@Posts = new Meteor.Collection('posts')

Posts.allow {

  insert: (userId, doc) ->

    # must be logged in to post
    if !userId then return false

    doc.createdAt = new Date()
    # only the server can create a new slug properly
    doc.slug = uniqueifySlug createSlug(doc.title)
    true
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
