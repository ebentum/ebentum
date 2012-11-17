$container = $("#myContent")
$container.imagesLoaded ->
  $("#myContent").masonry
    itemSelector: ".thumbnail"
    isFitWidth: true
