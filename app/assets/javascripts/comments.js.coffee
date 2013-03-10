window.comments = comments =

  load_event_comments: (event_id) ->
    $.ajax
      url: "/comments"
      type: 'GET'
      data:
        event_id: event_id
      dataType: 'html'
      success: (data, status, xhr) ->
        $('#comments').html(data)

  comment_edit_mode_off: (id) ->
    $('#editcomment'+id).addClass('hide')
    $('#bodycomment'+id).removeClass('hide')
    $('#editdeletecomment'+id).removeClass('hide')

  comment_edit_mode_on: (id) ->  
    $('#editcomment'+id).removeClass('hide')
    $('#bodycomment'+id).addClass('hide')
    $('#editdeletecomment'+id).addClass('hide')

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
      $('#comment'+id).remove()
      # cerrar modal
      $('#confirm_delete').modal('hide')

$(document).on "click", "#edit_comment", (event) ->
  event.preventDefault()
  
  # id del comentario que dejamos de editar
  id_editable = $('.editing textarea').data('commentid')
  # el comentario editable, lo ocultamos
  $('.editing').addClass('hide').removeClass('editing')
  comments.comment_edit_mode_off(id_editable)

  # id del comentario a editar
  id = $(this).data('commentid')
  # el comentario a editar, lo ponemos editable
  $('#editcomment'+id).addClass('editing')
  comments.comment_edit_mode_on(id)

  # ocultar el form de nuevo comentario
  $('#new_comment').addClass('hide')
  

$(document).on "keydown", "#new_comment_textarea", (event) ->
  if event.keyCode == 13
    event.preventDefault()
    if $('#new_comment_textarea').val().trim().length > 0
      $.ajax
        url: "/comments"
        type: 'POST'
        dataType: 'json'
        data: 
          comment_text: $('#new_comment_textarea').val()
          event_id: $('#new_comment_textarea').data('eventid')
        success: (data, status, xhr) ->
          comment_id = data.id
          $.ajax
            url: "/comments/"+data.id
            type: 'GET'
            dataType: 'html'
            success: (data, status, xhr) ->
              $('#event_comments').append(data)
              $('#new_comment_textarea').val('')

$(document).on "keydown", "#edit_comment_textarea", (event) ->
  if event.keyCode == 13
    event.preventDefault()
    if $('#edit_comment_textarea').val().trim().length > 0
      commentid = $(this).data('commentid')
      $.ajax
        url: "/comments/"+commentid
        type: 'PUT'
        dataType: 'json'
        data:
          comment:
            body: $('#editcomment'+commentid+' #edit_comment_textarea').val()
        success: (data, status, xhr) ->
          $('#bodycomment' + data.id).text(data.body)
          comments.comment_edit_mode_off(data.id)
  else if event.keyCode == 27 # ESC
    commentid = $(this).data('commentid')
    comments.comment_edit_mode_off(commentid)
    # mostrar el form de nuevo comentario
    $('#new_comment').removeClass('hide')

    