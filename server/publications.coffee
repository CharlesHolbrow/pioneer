Meteor.publish 'posts', (selector = {})->
  # Caution: sorting on the server side is unreliable.
  Posts.find selector

Meteor.publish 'lastPublishedPost', ->
  Posts.find({publish: true}, {sort:[['createdAt', 'desc']], limit:1})
