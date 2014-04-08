Session.set 'postsSelector', {}
Session.set 'currentPostsSubscription', null

window.subscriptions =
  published: new Meteor.subscribeWithPagination 'posts', {publish: true}, 3
  projects: new Meteor.subscribeWithPagination 'posts', {tags: 'projects'}, 1

Router.map ->

  # Post List Routes
  @route 'projects',
    path: '/projects'
    template: 'postList'
    waitOn: ->
      Session.set 'postsSelector', {tags: 'projects'}
      Session.set 'currentPostsSubscription', subscriptions.projects

  @route 'posts',
    template: 'postList'
    path: '/'
    waitOn: ->
      Session.set 'postsSelector', {publish: true}
      Session.set 'currentPostsSubscription', subscriptions.published

Router.map ->

  # Single Post Routes, (Edit, view, submit, etc)
  @route 'postPage',
    path: '/posts/:slug'
    data: ->
      Posts.findOne {slug: @params.slug}
    waitOn: ->
      Meteor.subscribe 'postPage', @params.slug

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

  @route 'about',
    path: '/about',
    template: 'postPage',
    data: ->
      Posts.findOne {tags: 'about'}
    waitOn: ->
      Meteor.subscribe 'posts', {tags: 'about'}

  # Misc Routes
  @route 'login'
  @route 'signin',
    template: 'login'
  return

# Misc router configuration
Router.configure
  layoutTemplate: 'master',
  notFoundTemplate: 'missing',
  # loadingTemplate: 'loading'

Router.onAfterAction(
  -> $('body').scrollTop 0
  , except: []
)
