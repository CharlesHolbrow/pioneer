Meteor.Router.add {
  # main page
  '/': 'postList'

  # post by id
  '/posts/:_id': {
    'to': 'postPage',
    'and': (id) ->
      Session.set 'currentPostId', id
      return
  }
}
