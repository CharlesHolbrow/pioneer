Template.commentList.comments = ->
  Comments.find({postId:this._id}, {sort:{createdAt:'desc'}});

Template.commentEdit.events = {
  'submit form': (event, template) ->
    event.preventDefault()
    inputElement = document.getElementById 'comment-input'
    return unless inputElement
    return unless inputElement.value.length > 3

    comment = {
      content: inputElement.value
      postId: this._id
    }

    inputElement.setAttribute 'disabled', 'disabled'

    Meteor.call 'insertComment', comment, (err, result)->
      inputElement.removeAttribute 'disabled'
      inputElement.value = '' unless err

}
