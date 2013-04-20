window.scroll = scroll =

  activate_comments_scroll: ->
    $('.container-fluid').addClass('infinite-scroll comments-scroll')

$(window).on 'scroll', ->
  if $(document).height() == $(window).height() + $(window).scrollTop()
    if $('.container-fluid').hasClass('infinite-scroll')
      if $('.container-fluid').hasClass('comments-scroll')
        page = $('#comments').data('comments-page')
        $('#comments').data('comments-page', page + 1)
        comments.load_event_comments_page(page + 1)