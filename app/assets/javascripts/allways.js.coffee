$(document).on "click", "#sign_up_button", (event) ->
  button = $(this)
  Paloma.devise.registrations.sign_up_flow(button, event)


# Si estamos dentro de la App nativa ocultar dialogo de "Loading..."
if EbentumAppNative?
  console.log "ocultar loading..."
  EbentumAppNative.hideLoadingDialog()
else
  console.log "No estamos en appnativa"