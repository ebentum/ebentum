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
    $('#editcomment'+id).fadeOut 'fast', ->
      $('#bodycomment'+id).fadeIn 'fast'
      $('#editdeletecomment'+id).fadeIn 'fast'
      $('#new_comment').fadeIn 'fast'

  comment_edit_mode_on: (id) ->  
    $('#editcomment'+id).fadeIn 'fast', ->
      $('#bodycomment'+id).fadeOut 'fast'
      $('#editdeletecomment'+id).fadeOut 'fast'
      $('#new_comment').fadeOut 'fast'

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
  # poner el cursos al final del texto del textarea que queremos editar
  $('#edit_comment_textarea_'+id).caretToEnd()
  

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
          comment_id = data._id
          $.ajax
            url: "/comments/"+comment_id
            type: 'GET'
            dataType: 'html'
            success: (data, status, xhr) ->
              $('#event_comments').append(data)
              $('#event_comments li:last').hide()
              $('#event_comments li:last').fadeIn('fast')
              $('#new_comment_textarea').val('')

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
          $('#bodycomment' + data._id).text(data.body)
          $('#comment_date_'+ data._id).text(data.updated_at_formated)
          comments.comment_edit_mode_off(data._id)
           
  else if event.keyCode == 27 # ESC
    commentid = $(this).data('commentid')
    comments.comment_edit_mode_off(commentid)

    