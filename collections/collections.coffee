# Posts
#   title
#   content
#   slug
#   authorId
@Posts = new Meteor.Collection('posts')

Posts.allow {

  # insert allowed IFF we are logged in
  insert: (userId, doc) ->
    !!userId
}
