Meteor.startup ->
  # The first user to sign up isRoot
  Accounts.onCreateUser (options, user) ->
    if options.profile
      user.profile = options.profile # boilerplate

    if Meteor.users.find().count() == 0
      user.isRoot = true

    return user
