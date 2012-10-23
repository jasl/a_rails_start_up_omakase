//= require kindeditor/kindeditor.js

$.each(window.kindeditor_fields, function(i, item) {
    KindEditor.ready(function(K) {
        K.create(item.id, item.config);
    });
});
