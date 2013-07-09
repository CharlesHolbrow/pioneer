Meteor.methods {
  insertPost: (doc) ->
    # doc should contain at minimun: title, content
    # user MUST be logged in this.userId 
    # TODO: verify we have a title and content

    # verify we are logged in
    return unless @userId

    # only a user that isRoot is allowed to post
    user = Meteor.users.findOne @userId
    console.log 'Checking if user is root:', user.profile.name
    return unless user.isRoot
    console.log 'User is root. We allow posting.'

    # If we have an _id, assume we are editing existing post
    id = doc._id
    delete doc['_id']

    if id
      doc.editedAt = new Date().getTime()
      Posts.update {_id: id}, {$set: doc}
    else
      doc.authorId = @userId
      doc.slug = uniqueifySlug createSlug(doc.title)
      doc.createdAt = doc.createdAt || new Date().getTime()
      Posts.insert doc

  insertComment: (doc) ->
    user = Meteor.users.findOne @userId
    return unless user

    comment = {
      content: doc.content
      postId: doc.postId
      authorId: @userId
      authorName: user.profile.name
      createdAt: new Date().getTime()
    }
    Comments.insert comment
}

createSlug = (text) ->
  text = text || ''
  text.toLowerCase().replace(/[^\w ]+/g,'').replace(/\ +/g,'-')


uniqueifySlug = (slug) ->
  # if slug is unique
  if !Posts.findOne({slug:slug}) then return slug

  # get the number suffix if any
  lastDigits = slug.match(/-*([0-9]*)$/)[1] || 0

  # increment and append
  lastDigits = ~~lastDigits + 1
  newSlug = slug.replace(/-*[0-9]*$/, '-' + lastDigits)

  # return new slug after verifying uniqueness
  uniqueifySlug(newSlug)
