# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".slides_list img").imagesLoaded ->
    $(".slide_in_list").wookmark({container: $(".slides_list"), itemWidth: 105})
