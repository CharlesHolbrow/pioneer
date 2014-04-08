Handlebars.registerHelper 'debugger', -> 
  debugger

window.isElementInViewport = (el)->
  rect = el.getBoundingClientRect();
  return true if document.contains(el) and
    rect.top >= 0 and rect.left >= 0 and
    rect.top < $(window).height() and
    rect.left < $(window).width()
  return false
