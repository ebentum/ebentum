$('#events_new').click ->
  console.log "events new.."
  $("#modal_windows #events_new_modal").remove()
  $.ajax
    url: "/events/new"
    success: (data) ->
      $("#modal_windows").append data
      $('#events_new_modal').modal()

$(document).on "change", "#event_search_form select", ->
  $('#event_search_form').submit()
