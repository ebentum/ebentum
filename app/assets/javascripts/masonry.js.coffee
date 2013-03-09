$container = $(".masonry_layout")
$container.imagesLoaded ->
  $(".masonry_layout").masonry
    itemSelector: ".box"
    isFitWidth: true