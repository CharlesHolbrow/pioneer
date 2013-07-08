Template.commentList.comments = ->
  Comments.find({postId:this._id});
