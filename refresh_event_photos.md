iniciar rails console y ejecutar:

Event.all.each {|e| e.photo.reprocess!}