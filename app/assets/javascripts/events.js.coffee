$('#events_new').click ->
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("body").append data
      $('#events_new_modal').modal()