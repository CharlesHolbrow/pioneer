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

  # The The difference between submitting a new post and
  # editing an existing post is specified. by the
  # currentPostId Session variable. If it's null, assume
  # we are submitting a new post.
  '/submit': {
    'to': 'postEdit'
    'and': ->
      Session.set 'currentPostId', null
  }

  # If the currentPostId Session variable is an ID,
  # assume we want to edit that doc
  '/edit/:_id': {
    'to': 'postEdit'
    'and': (_id) ->
      post = Posts.findOne {_id: _id}
      if post
        Session.set 'currentPostId', _id
      else
        Session.set 'currentPostId', null
  }

  '/login': 'login'

}

Meteor.Router.filters {
  'requireLogin': (page) ->
    if Meteor.user()
      return page
    else
      return 'denied'
}

Meteor.Router.filter 'requireLogin', {only: 'postEdit'}
