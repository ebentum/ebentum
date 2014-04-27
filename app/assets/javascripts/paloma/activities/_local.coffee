Paloma.activities =

  $(document).on "click", ".follow-activity", (event) ->
    element = $(this)
    user_id = $(this).data('user-id')
    $.ajax
      url: '/users/'+user_id+'/follow'
      type: 'PUT'
      dataType: 'json'
      success: (data, status, xhr) ->
        # Actualizar contador se 'siguiendo'
        # TODO: Esto solo lo debe hacer si estoy viendo los 'seguidores' en mi perfil
        followingCount = parseInt($('.following_count').text().trim())
        $('.following_count').text(++followingCount)
        # Ocultar aviso de añadir
        element.fadeOut('slow')
