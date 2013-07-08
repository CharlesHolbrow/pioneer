Meteor.publish 'posts', (selector = {})->
  # Caution: sorting on the server side is unreliable.
  Posts.find selector

Meteor.publish 'lastPublishedPost', ->
  Posts.find({publish: true}, {sort:[['createdAt', 'desc']], limit:1})

Meteor.publish 'comments', (postId) ->
  # TODO: Meteor 'check' function to verify postId
  Comments.find({postId:postId})
