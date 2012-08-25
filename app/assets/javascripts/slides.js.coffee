# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
page = 2
addNext = ->
  $.ajax({
    url: "/slides/add_next"
    type: "post"
    dataType: "script"
    data: {"page": page}
    success: (data) ->
      page++
      if data is ""
        $(document).unbind()
  })
onScroll = (event) ->
  closeToBottom = ($(window).scrollTop() + $(window).height() > $(document).height() - 100)
  if closeToBottom
    addNext()

$ ->
  if document.getElementById("endless_scroll")
    $(document).bind('scroll', onScroll)
  $("h2").click ->
    $(document).unbind()

