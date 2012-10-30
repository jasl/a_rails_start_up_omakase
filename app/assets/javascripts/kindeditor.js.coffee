#= require kindeditor/kindeditor.js

$.each(window.kindeditor_fields, (i, item)->
  KindEditor.ready((K)->
    K.create(item.id, item.config)
  )
)
