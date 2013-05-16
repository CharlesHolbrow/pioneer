Meteor.startup ->
  if Posts.find().count() == 0
    Posts.insert {
      title: 'A Test Post'
      content: 'This an initial blog post, really just for testing purposes'
    }
    Posts.insert {
      title: 'A second post'
      content: 'And this is another post that I\'m using for for pleasure and profit'
    }
