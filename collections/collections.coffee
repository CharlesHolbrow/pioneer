# Posts
#   title
#   content
#   slug
#   authorId
#   createdAt
#   tags
@Posts = new Meteor.Collection('posts')

# Comments
#   postId
#   authorId
#   authorName
#   createdAt
#   content
@Comments = new Meteor.Collection('comments')
