Meteor.publish 'posts', (selector = {})->
  # Caution: sorting on the server side is unreliable.
  Posts.find selector
