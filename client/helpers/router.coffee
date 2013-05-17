Meteor.Router.add {
  # Main page

  # set the url '/' to a template name
  # thie implicitly creates the following shortcuts:
  #   Meteor.Router.postListPath() -- "/"
  #   Meteor.Router.postListUrl()  -- "http://YourSite.com/"
  # And the template variables:
  #   {{ postListPath }}
  #   {{ postListUrl }}
  '/': 'postList'

  # Post Page

  # The style below creates the same shortcuts as postList above
  # Here we carefully name the variable part of the path 'slug'
  # this enables us to pass an object to the template variables:
  #   {{ postPagePath this }}
  # and the template variable will return will look like this:
  #   /posts/your-object-slug-attribute
  '/posts/:slug': {
    'to': 'postPage',
    'and': (slug) ->
      post = Posts.findOne {slug:slug}, {_id:true}
      if post then Session.set 'currentPostId', post._id
  }
}
