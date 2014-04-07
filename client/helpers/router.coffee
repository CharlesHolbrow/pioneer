subscriptions = {}

Router.configure
  layoutTemplate: 'master',
  notFoundTemplate: 'missing',
  # loadingTemplate: 'loading'

# scrollUp = RouteController.extend
  # onBeforeAction: -> $('body').scrollTop 0

Router.onAfterAction(
  -> $('body').scrollTop 0
  , except: []
)

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
