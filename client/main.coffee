marked.setOptions {
  langPrefix: ''
  breaks: false
  highlight: (code) ->
    hljs.highlightAuto(code).value
}
