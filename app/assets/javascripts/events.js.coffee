$('#events_new').click ->
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("#modal_windows").append data
      $('#events_new_modal').modal()


# $("#modal_windows").on "click", "#new_event_save", (event) ->
#   $.ajax
#     url: "/events"
#     type: 'POST'
#     data: $('#new_event').serialize()
#     dataType: 'json'
#     success: (data) ->
#       alert('success')
#     error: (xhr, status, error) ->
#       errorList = jQuery.parseJSON(xhr.responseText)
#       $.each errorList, (column, error) ->
#         $('#event_'+column).parent().append('<span class="help-inline">'+error+'</span>')
#         $('#event_'+column).parent().parent().addClass('error')
