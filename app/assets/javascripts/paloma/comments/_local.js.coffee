Paloma.Comments =

  page: 1
  loadingPage: false
  lastPage: false

  updateCommentsCount: (increment=1) ->
    $('.comments-count').text(parseInt($('.comments-count').text())+increment)

  load_event_comments: (event_id=$('#event_id').val()) ->
    Paloma.Comments.loadingPage = true
    $.ajax
      url: "/comments"
      type: 'GET'
      data:
        event_id: event_id
        page: Paloma.Comments.page
      dataType: 'html'
      success: (data, status, xhr) ->
        data = $(data)
        Paloma.DateTimes.format(data)
        if Paloma.Comments.page is 1
          $('#comments ul').html(data)
          $('#new_comment_textarea').autosize()
        else
          if data.length > 0
            $('#comments ul').append(data)
          else
            Paloma.Comments.lastPage = true

        Paloma.Comments.page = Paloma.Comments.page + 1

      complete: (data, status, xhr) ->
        Paloma.Comments.loadingPage = false

  comment_edit_mode_off: (id) ->
    $('#editcomment'+id).fadeOut 'fast', ->
      $('#bodycomment'+id).fadeIn 'fast'
      $('#editdeletecomment'+id).fadeIn 'fast'
      $('#new_comment').fadeIn 'fast'

  comment_edit_mode_on: (id) ->
    $('#editcomment'+id).fadeIn 'fast', ->
      $('#editcomment'+id+' textarea').autosize()
      $('#bodycomment'+id).fadeOut 'fast'
      $('#editdeletecomment'+id).fadeOut 'fast'
      $('#new_comment').fadeOut 'fast'

  initLayout: ->

    $(document).on "click", "#delete_comment", (event) ->
      id = $(this).data('commentid')
      $('#confirm_delete_btn').data('commentid', id)

    $(document).on "click", "#confirm_delete_btn", (event) ->
      event.preventDefault()
      id = $(this).data('commentid')
      $.ajax
        url: "/comments/"+id
        type: 'DELETE'
        dataType: 'json'
        success: (data, status, xhr) ->
          $('#comment'+id).fadeOut('fast')
          $('#comment'+id).remove()
          Paloma.Comments.updateCommentsCount(-1)
          # cerrar modal
          $('#confirm_delete').modal('hide')

    $(document).on "click", "#edit_comment", (event) ->
      event.preventDefault()

      # id del comentario que dejamos de editar
      id_editable = $('.editing textarea').data('commentid')
      # el comentario editable, lo ocultamos
      $('.editing').addClass('hide').removeClass('editing')
      Paloma.Comments.comment_edit_mode_off(id_editable)

      # id del comentario a editar
      id = $(this).data('commentid')
      # el comentario a editar, lo ponemos editable
      $('#editcomment'+id).addClass('editing').removeClass('hide')
      Paloma.Comments.comment_edit_mode_on(id)
      # poner el cursos al final del texto del textarea que queremos editar
      $('#edit_comment_textarea_'+id).caretToEnd()


    $(document).on "keydown", "#new_comment_textarea", (event) ->
      if event.keyCode == 13
        event.preventDefault()
        if $('#new_comment_textarea').val().trim().length > 0

          text_ = $('#new_comment_textarea').val()
          # lastPlaceholder = $('#new_comment_textarea').attr('placeholder')
          # $('#new_comment_textarea').attr('placeholder',"...")
          $('#new_comment_textarea').attr('disabled','')
          $('.comment-loading').removeClass 'hidden'
          # $('#new_comment_textarea').val('')


          $.ajax
            url: "/comments"
            type: 'POST'
            dataType: 'json'
            data:
              comment_text: text_
              event_id: $('#new_comment_textarea').data('eventid')
            success: (data, status, xhr) ->
              comment_id = data._id
              $.ajax
                url: "/comments/"+comment_id
                type: 'GET'
                dataType: 'html'
                success: (data, status, xhr) ->
                  $('#new_comment_textarea').val('')
                  # $('#new_comment_textarea').attr('placeholder',lastPlaceholder)
                  $('#new_comment_textarea').removeAttr('disabled')
                  $('.comment-loading').addClass 'hidden'
                  $('#new_comment_textarea').focus()
                  data = $(data)
                  $('#event_comments').prepend(data)
                  $('#event_comments li:first').hide()
                  $('#event_comments li:first').fadeIn('fast')

                  Paloma.Comments.updateCommentsCount()
                  Paloma.DateTimes.format($('#event_comments'))

    $(document).on "keydown", "textarea[id^=edit_comment_textarea_]", (event) ->
      if event.keyCode == 13
        event.preventDefault()
        commentid = $(this).data('commentid')
        if $('#edit_comment_textarea_'+commentid).val().trim().length > 0
          $.ajax
            url: "/comments/"+commentid
            type: 'PUT'
            dataType: 'json'
            data:
              comment:
                body: $('#editcomment'+commentid+' #edit_comment_textarea_'+commentid).val()
            success: (data, status, xhr) ->
              # Guardamos el id del siguiente comentario para saber donde hacer el prepend
              next_id = $('#comment' + data._id).next().attr('id')
              # Guardamos el id del anterior comentario para saber donde hacer el append
              prev_id = $('#comment' + data._id).prev().attr('id')
              # eliminamos el comentario del DOM
              $('#comment' + data._id).remove()
              # cargamos el comentario
              comment_id = data._id
              $.ajax
                url: "/comments/"+comment_id
                type: 'GET'
                dataType: 'html'
                success: (data, status, xhr) ->
                  data = $(data)
                  if next_id
                    data.insertBefore('#'+next_id)
                  else if prev_id
                    data.insertAfter('#'+prev_id)
                  else # es el único comentario que hay
                    $('#comments ul').html(data)
                  $('#'+data._id).hide()
                  $('#'+data._id).fadeIn('fast')
                  $('#new_comment_textarea').val('')
                  $('#new_comment').fadeIn 'fast'
                  Paloma.DateTimes.format($('#event_comments'))

      else if event.keyCode == 27 # ESC
        commentid = $(this).data('commentid')
        Paloma.Comments.comment_edit_mode_off(commentid)

    $(document).scroll ->
      if $(window).height() + $(window).scrollTop() >= $(document).height() * 0.75
        if Paloma.Comments.loadingPage is false and Paloma.Comments.lastPage is false
          Paloma.Comments.load_event_comments()
