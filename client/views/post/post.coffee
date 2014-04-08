# Post List helpers
Template.postList.posts = ->
  Posts.find(Session.get 'postsSelector', {sort:{'createdAt':-1}})

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

    target = event.currentTarget
    target.disabled = true

    # Hack: renderer demands that first char is newline
    content = document.getElementById('content').value
    content = if content[0] == '\n' then content else '\n' + content

    post = {
      title: document.getElementById('title').value
      content: content
      tags: document.getElementById('tags').value.split(' ')
      publish: document.getElementById('publish').checked
      _id: Session.get('currentPostId')
    }

    Meteor.call 'insertPost', post, (error, slug)->
      if error
        target.disabled = false
        console.log 'Submit Error:', error
      else if slug
        Router.go 'postPage', {slug:slug}
      else
        Router.go 'posts'

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
