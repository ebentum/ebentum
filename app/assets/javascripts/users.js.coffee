$(document).on "click", "#sign_up_button", (event) ->
	$.ajax
		url: "/users"
		type: 'POST'
		data: $('#new_user').serialize()
		dataType: 'json'
		beforeSend: ->
			# quitar las marcas de error
			$('div.control-group').removeClass('error')
			$('div.controls input').next().text('')
			# boton en estado loading
			$('#sign_up_button').button('loading')
		success: (data) ->
			# ponemos el email en el mensaje y lo enseñamos
			txt = $('#sign_up_ok_text').text()
			txt = txt.replace('SIGN_UP_EMAIL', $('#email').val())
			$('#sign_up_ok_text').text(txt)
			$('#sign_up_success').fadeIn('slow')
			# ocultar el boton 
			$('#sign_up_button').hide()
		error: (xhr, status, error) ->
			# ponemos los errores
			# hacemos un tiemout para que el efecto sea más suave
			setTimeout (->
				errorList = jQuery.parseJSON(xhr.responseText).errors
				$.each errorList, (column, error) ->
					$('#new_user #'+column).next().hide().text(error).fadeIn('slow')
					$('#new_user #'+column).parent().parent().addClass('error')
				# activar el boton
				$('#sign_up_button').button('reset')
				), 2000
