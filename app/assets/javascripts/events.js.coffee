$('#new_event').click ->
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("body").append data
      $('#new_event_modal').modal()