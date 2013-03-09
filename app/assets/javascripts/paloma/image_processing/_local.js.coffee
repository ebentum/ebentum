Paloma.ImageProcessing =

  loadImageFile: (inputDomId, previewDomId) ->
    if window.FileReader
      oPreviewImg = null
      oFReader = new window.FileReader()
      rFilter = /^(?:image\/bmp|image\/cis\-cod|image\/gif|image\/ief|image\/jpeg|image\/jpeg|image\/jpeg|image\/pipeg|image\/png|image\/svg\+xml|image\/tiff|image\/x\-cmu\-raster|image\/x\-cmx|image\/x\-icon|image\/x\-portable\-anymap|image\/x\-portable\-bitmap|image\/x\-portable\-graymap|image\/x\-portable\-pixmap|image\/x\-rgb|image\/x\-xbitmap|image\/x\-xpixmap|image\/x\-xwindowdump)$/i
      oFReader.onload = (oFREvent) ->
        unless oPreviewImg
          newPreview = document.getElementById(previewDomId)
          oPreviewImg = new Image()
          oPreviewImg.style.width = (newPreview.offsetWidth).toString() + "px"
          oPreviewImg.style.height = (newPreview.offsetHeight).toString() + "px"
          newPreview.appendChild oPreviewImg
        oPreviewImg.src = oFREvent.target.result

      aFiles = document.getElementById(inputDomId).files
      return  if aFiles.length is 0
      unless rFilter.test(aFiles[0].type)
        alert "You must select a valid image file!"
        return
      oFReader.readAsDataURL aFiles[0]

    if navigator.appName is "Microsoft Internet Explorer"
      document.getElementById(previewDomId).filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = document.getElementById(inputDomId).value
