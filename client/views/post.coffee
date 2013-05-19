# Post List helpers
Template.postList.posts = ->
  Posts.find()

# Post Page helpers
Template.postPage.currentPost = ->
  Posts.findOne(Session.get('currentPostId'))

# Post Submit
Template.postSubmit.events = {
  'submit form': (event) ->
    event.preventDefault()

    post = {
      title: document.getElementById('title').value
      content: document.getElementById('content').value
    }
    post.slug = slugify(post.title)
    post._id = Posts.insert(post)
    Meteor.Router.to('postPage', post)
    return
}

slugify = (text) ->
  text.toLowerCase().replace(/[^\w ]+/g,'').replace(/\ +/g,'-')
