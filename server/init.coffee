Meteor.startup ->

  # Only allow one user
  Accounts.validateNewUser ->
    if Meteor.users.find().count() < 1
      return true
    return false
