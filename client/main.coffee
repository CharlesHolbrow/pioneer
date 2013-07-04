marked.setOptions {
  langPrefix: ''
  breaks: false
  highlight: (code, lang) ->
    if lang in ['js', 'javascript', 'json']
      hljs.highlightAuto(code).value
}
