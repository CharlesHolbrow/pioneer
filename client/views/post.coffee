# Post List helpers
Template.postList.posts = ->
  Posts.find()

# Post Page helpers
Template.postPage.currentPost = ->
  Posts.findOne(Session.get('currentPostId'))

# Post Submit
Template.postSubmit.events = {

  # how does this submit form event trigger?
  # there seems to be some magic in the name
  'submit form': (event) ->
    event.preventDefault()

    post = {
      title: document.getElementById('title').value
      content: document.getElementById('content').value
      author: Meteor.user()
    }
    post._id = Posts.insert(post)
    Meteor.Router.to('postPage', post)
    return
}
