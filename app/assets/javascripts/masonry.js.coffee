# $container = $(".masonry_layout")
# $container.imagesLoaded ->

# $('.poster-front').oriDomi({ hPanels: 10, vPanels: 10, touchEnabled: false, speed: 400 })

$(document).on "click", ".poster-front.oridomi", (event) ->
  $item = $(this)

  isRevealed = $(this).data('isrevealed')

  if isRevealed == 'true'
    $item.oriDomi().reset()
    $item.data('isrevealed','false')

  else
    # console.log $item.width
    # console.log $item.height
    if $item.width() > $item.height()
      $item.oriDomi('curl', -90, 'right')
    else
      $item.oriDomi('curl', -90, 'bottom')

    $item.data('isrevealed','true')


# $('.poster').each ->
#   this.oriDomi('reveal', -20, 'top')

# $(document).on "click", ".poster", (event) ->
#   isRevealed = $(this).data('isrevealed')
#   if isRevealed == 'true'
#     $(this).oriDomi().reset()
#     $(this).data('isrevealed','false')
#   else
#     $(this).oriDomi('reveal', -20, 'top')
#     $(this).data('isrevealed','true')

$(".masonry_layout").masonry
  itemSelector: ".card"
  columnWidth: ( containerWidth ) ->
    # if containerWidth > 1024
    #   containerWidth / 6
    # else
    #   containerWidth / 3

    250

  isFitWidth: true

  # containerWidth = $(".masonry_layout").css("width")

  # if containerWidth > 1024
  #   containerWidth = containerWidth / 6
  # else
  #   containerWidth = containerWidth / 3

  # $(".masonry_layout .box").css("width",containerWidth)
