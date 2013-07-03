Meteor.subscribe 'posts'

marked.setOptions {
  langPrefix: ''
  breaks: true
  highlight: (code) ->
    results = hljs.highlightAuto(code).value
    console.log('doing it': results)
    results
}
