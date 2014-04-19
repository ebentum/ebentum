Paloma.callbacks["activities/index"] = (params) ->

  Paloma.Masonry.initPage("activities","#activity_list")

  # abrimos el modal de amigos de facebook, si es que el modal existe
  if $('#show_fb_friends').length > 0
    $('#show_fb_friends').modal()
