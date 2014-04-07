subscriptions = {}

Router.configure
  layoutTemplate: 'master',
  notFoundTemplate: 'missing',
  # loadingTemplate: 'loading'

Router.map ->
  @route 'postPage',
    path: '/posts/:slug'
    data: ->
      Posts.findOne {slug: @params.slug}
    waitOn: ->
      Meteor.subscribe 'postPage', @params.slug

Router.map ->
  @route 'posts',
    template: 'postList'
    path: '/'
    waitOn: ->
      Meteor.subscribe 'posts', {publish:true}

Router.map ->
  @route 'login'
  @route 'signin',
    template: 'login'
  return

Router.map ->
  @route 'edit',
    path: '/edit/:_id'
    template: 'postEdit'
    data: ->
      Posts.findOne {_id: @params._id}
    waitOn: ->
      id = @params._id
      Session.set 'currentPostId', id
      Meteor.subscribe 'posts', {_id: id}
  @route 'submit',
    path: '/submit'
    template: 'postEdit'
    waitOn: ->
      Session.set 'currentPostId', null

Router.map ->
  @route 'projects',
    path: '/projects'
    template: 'postList'
    waitOn: ->
      Meteor.subscribe 'posts', {tags:'projects'}
  @route 'about',
    path: '/about',
    template: 'postPage',
    data: ->
      Posts.findOne {tags: 'about'}
    waitOn: ->
      Meteor.subscribe 'posts', {tags: 'about'}


###
Meteor.Router.add {
  # Main page

  # set the url '/' to a template name
  # thie implicitly creates the following shortcuts:
  #   Meteor.Router.postListPath() -- "/"
  #   Meteor.Router.postListUrl()  -- "http://YourSite.com/"
  # And the template variables:
  #   {{ postListPath }}
  #   {{ postListUrl }}
  '/': {
    'to': 'postList'
    'and': ->
      # first post to appear at the top of the list. Get this first,
      # then get the other posts
      Meteor.subscribe 'lastPublishedPost', [], ->
        unless subscriptions['postList']
          subscriptions['postList'] = true;
          Deps.nonreactive ->
            # First Get the published posts
            subscriptions['postList'] = Meteor.subscribe 'posts', {publish:true}, ->
              # Once we have published posts, get all Posts
              Meteor.subscribe 'posts'
  }

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
      Meteor.subscribe 'postPage', slug, ->
        post = Posts.findOne {slug:slug}
        Session.set 'currentPostId', post._id
  }

  # If the currentPostId Session variable is an ID,
  # assume we want to edit that doc
  '/edit/:_id': {
    'to': 'postEdit'
    'and': (id) ->
      selector = {_id: id}
      post = Posts.findOne selector
      if post
        Session.set 'currentPostId', post._id
      else
        # running subscribe non reactively prevents subscription 
        # cancelation when route changes
        Deps.nonreactive ->
          Meteor.subscribe 'posts', selector, ->
            post = Posts.findOne selector, {_id:true}
            if post
              Session.set 'currentPostId', post._id
            else
              Session.set 'currentPostId', null
  }

  # The The difference between submitting a new post and
  # editing an existing post is specified by the
  # currentPostId Session variable. If it's null, assume
  # we are submitting a new post.
  '/submit': {
    'to': 'postEdit'
    'and': ->
      Session.set 'currentPostId', null
  }

  # A custom route that links to the post titled "About"
  '/about': {
    'as': 'about' # Name the route. Provide {{aboutPath/URL}} helpers
    'to': 'postPage'
    'and': ->
      selector = {tags:'about'}
      post = Posts.findOne selector
      if post
        Session.set 'currentPostId', post._id
      else
        Deps.nonreactive ->
          Meteor.subscribe 'posts', selector, ->
            post = Posts.findOne selector
            Session.set 'currentPostId', post._id
  }

  '/login': 'login'
  '/projects': {
    'to': 'projectList'
    'and': ->
      unless subscriptions['projects']
        subscriptions['projects'] = true
        Deps.nonreactive ->
          subscriptions['projects'] = Meteor.subscribe 'posts', {tags:'projects'}
  }
}

Meteor.Router.filters {
  'requireLogin': (page) ->
    if Meteor.user()
      return page
    else
      return 'denied'
}

Meteor.Router.filter 'requireLogin', {only: 'postEdit'}
###