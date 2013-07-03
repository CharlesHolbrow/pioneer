Meteor.subscribe 'posts'

marked.setOptions {
  langPrefix: ''
  breaks: false
  highlight: (code) ->
    results = hljs.highlightAuto(code).value
    console.log('doing it': results)
    results
}
