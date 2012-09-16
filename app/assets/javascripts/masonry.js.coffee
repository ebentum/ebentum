@init_masonry = ->
  $("#myContent").masonry
    itemSelector: ".thumbnail"
    # isAnimated: not Modernizr.csstransitions
    isFitWidth: true

  # $container = $("#myContent")
  # gutter = 15
  # min_width = 300
  # $container.imagesLoaded ->
  #   $container.masonry
  #     itemSelector: ".thumbnail"
  #     gutterWidth: gutter
  #     isAnimated: true
  #     columnWidth: (containerWidth) ->
  #       num_of_boxes = (containerWidth / min_width | 0)
  #       box_width = (((containerWidth - (num_of_boxes - 1) * gutter) / num_of_boxes) | 0)
  #       box_width = containerWidth  if containerWidth < min_width
  #       $(".thumbnail").width box_width
  #       box_width