Meteor.publish 'posts', ->
  Posts.find {'createdAt':{$exists:1}},  {sort: {'createdAt': -1}}
