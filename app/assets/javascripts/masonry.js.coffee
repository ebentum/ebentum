# $container = $(".masonry_layout")
# $container.imagesLoaded ->

$(".masonry_layout").masonry
  itemSelector: ".poster"
  columnWidth: ( containerWidth ) ->
    # if containerWidth > 1024
    #   containerWidth / 6
    # else
    #   containerWidth / 3

    210

  isFitWidth: true

  # containerWidth = $(".masonry_layout").css("width")

  # if containerWidth > 1024
  #   containerWidth = containerWidth / 6
  # else
  #   containerWidth = containerWidth / 3

  # $(".masonry_layout .box").css("width",containerWidth)
