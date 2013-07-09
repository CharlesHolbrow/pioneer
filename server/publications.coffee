Meteor.publish 'posts', (selector = {})->
  # Caution: sorting on the server side is unreliable.
  Posts.find selector

Meteor.publish 'lastPublishedPost', ->
  Posts.find({publish: true}, {sort:[['createdAt', 'desc']], limit:1})

Meteor.publish 'postPage', (slug) ->
  selector = {slug:slug}
  post = Posts.findOne(selector)
  if post
    # publish the post and comments
    return [Posts.find(selector, {limit:1}), Comments.find(postId:post._id)]
  @ready()

Meteor.publish 'users', ->
  # Users will need to look up the post author
  return Meteor.users.find({isRoot:true}, {fields:{profile:true}})
