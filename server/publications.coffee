Meteor.publish 'posts', ->
  # Caution: sorting on the server side is unreliable.
  Posts.find {}
