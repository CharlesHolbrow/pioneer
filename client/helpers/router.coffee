Session.set 'postsSelector', {}

window.subscriptions =
  published: new Meteor.subscribeWithPagination 'posts', {publish: true}, 3
  projects: new Meteor.subscribeWithPagination 'posts', {tags: 'projects'}, 2
  awareness: new Meteor.subscribeWithPagination 'posts', {tags: 'awareness'}, 3
  current: null # not EJSONable, cannot use Session.set

window.loadIfNeeded = ()->
  Meteor.setTimeout ->
    loadEl= $('.loading-more')[0]
    return unless loadEl and
      isElementInViewport(loadEl) and
      subscriptions.current.ready()
    subscriptions.current.loadNextPage()
  , 1

Deps.autorun ->
  Session.get 'postsSelector' # make reactive
  if subscriptions.published.ready() or subscriptions.projects.ready()
    if subscriptions.current and subscriptions.current.ready()
      loadIfNeeded()

Router.map ->

  # Post List Routes
  @route 'projects',
    path: '/projects'
    template: 'postList'
    data: ->
      {title: 'Projects'}
    waitOn: ->
      subscriptions.current = subscriptions.projects
      Session.set 'postsSelector', {tags: 'projects'}
      return subscriptions.current

  @route 'awareness',
    path: '/awareness'
    template: 'postList'
    data: ->
      {title: 'Awareness'}
    waitOn: ->
      subscriptions.current = subscriptions.awareness
      Session.set 'postsSelector', {tags: 'awareness'}
      return subscriptions.current

  @route 'posts',
    template: 'postList'
    path: '/'
    data: ->
      {title: 'Blog'}
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

# Scroll to top after route changes
Tracker.autorun( ->
  current = Router.current()
  Tracker.afterFlush ->
    $('body').scrollTop 0
, except: []
)

# Update Page title
Router.onAfterAction( ->
  data = @data()
  if data and data.title
    title = data.title + ' - www.CharlesHolbrow.com'
  document.title = title or 'www.CharlesHolbrow.com'
  window.loadIfNeeded()
, except: []
)
