# Post List helpers
Template.postList.posts = ->
  Posts.find({publish:true}, {sort:{'createdAt':-1}, limit:6})

# Post Page helpers
Template.postPage.currentPost = ->
  Posts.findOne(Session.get('currentPostId'))

# Post Item helpers
Template.postItem.date = ->
  moment(@createdAt).format('MMM D, YYYY')

Template.postItem.ownPost = ->
  Meteor.userId() == this.authorId

Template.postItem.authorName = ->
  user = Meteor.users.findOne this.authorId
  if user
    user.profile.name

# Post Edit
Template.postEdit.events = {

  # how does this submit form event trigger?
  # there seems to be some magic in the name
  'submit form': (event) ->
    event.preventDefault()

    post = {
      title: document.getElementById('title').value
      content: document.getElementById('content').value
      tags: document.getElementById('tags').value.split(' ')
      publish: document.getElementById('publish').checked
      _id: Session.get('currentPostId')
    }

    Meteor.call 'insertPost', post
    Router.go 'postList'
    return
}

Template.postEdit.helpers {
  'currentPost': ->
    post = Posts.findOne(Session.get('currentPostId'))
    post or {}

  'tagString': ->
    post = Posts.findOne(Session.get('currentPostId'))
    if post and post.tags then post.tags.join(' ')
}
