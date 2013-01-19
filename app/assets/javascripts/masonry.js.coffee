$container = $("#myContent")
$container.imagesLoaded ->
  $("#myContent").masonry
    itemSelector: ".box"
    isFitWidth: true
