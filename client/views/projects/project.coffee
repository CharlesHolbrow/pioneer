Template.projectList.projects = ->
  Posts.find({tags:'projects'}, {sort:{'createdAt':-1}})
