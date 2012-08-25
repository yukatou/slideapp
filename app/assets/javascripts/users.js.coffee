$ ->
  $(".queued_slides_list img").imagesLoaded ->
    $(".queued_slide_in_list").wookmark({container: $(".queued_slides_list"), itemWidth: 105})
