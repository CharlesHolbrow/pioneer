# Post List helpers
Template.postList.posts = ->
  Posts.find({publish:true}, {sort:{'createdAt':-1}, limit:6})

# Post Page helpers
Template.postPage.currentPost = ->
  Posts.findOne(Session.get('currentPostId'))

Template.postItem.date = ->
  date = new Date @createdAt
  date.toString()

Template.postItem.ownPost = ->
  Meteor.userId() == this.authorId

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
    Meteor.Router.to 'postList'
    return
  }

Template.postEdit.helpers {
  'currentPost': ->
    Posts.findOne(Session.get('currentPostId'))

  'content': ->
    post = Posts.findOne(Session.get('currentPostId'))
    if post then post.content

  'title': ->
    post = Posts.findOne(Session.get('currentPostId'))
    if post then post.title

  'tags': ->
    post = Posts.findOne(Session.get('currentPostId'))
    if post and post.tags then post.tags.join(' ')

  'publish': ->
    post = Posts.findOne(Session.get('currentPostId'))
    if post then post.publish
}
