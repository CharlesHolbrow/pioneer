Session.set 'postsSelector', {}

window.subscriptions =
  published: new Meteor.subscribeWithPagination 'posts', {publish: true}, 3
  projects: new Meteor.subscribeWithPagination 'posts', {tags: 'projects'}, 2
  current: null # not EJSONable, cannot use Session.set

window.loadIfNeeded = ()->
  loadEl= $('.loading-more')[0]
  return unless loadEl and
    isElementInViewport(loadEl) and
    subscriptions.current.ready()
  subscriptions.current.loadNextPage()

Deps.autorun ->
  Session.get 'postsSelector' # make reactive
  if subscriptions.published.ready() or subscriptions.projects.ready()
    loadIfNeeded()

Router.map ->

  # Post List Routes
  @route 'projects',
    path: '/projects'
    template: 'postList'
    waitOn: ->
      subscriptions.current = subscriptions.projects
      Session.set 'postsSelector', {tags: 'projects'}
      return subscriptions.current

  @route 'posts',
    template: 'postList'
    path: '/'
    waitOn: ->
      subscriptions.current = subscriptions.published
      Session.set 'postsSelector', {publish: true}
      return subscriptions.current

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

Router.onAfterAction( ->
  $('body').scrollTop 0
, except: []
)