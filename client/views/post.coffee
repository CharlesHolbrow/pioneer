# Post List helpers
Template.postList.posts = ->
  Posts.find()

# Post Page helpers
Template.postPage.currentPost = ->
  Posts.findOne(Session.get('currentPostId'))
