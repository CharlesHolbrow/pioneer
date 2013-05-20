# Posts
#   title
#   content
#   slug
#   authorId
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


