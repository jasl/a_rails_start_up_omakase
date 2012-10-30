$(".district_select").each ->
  selects = $('select', this)
  selects.unbind('change') # 避免多次绑定change事件
  selects.change ->
    $this = this
    select_index = selects.index($this)+1
    select = selects.eq(select_index)
    # clear children's options
    selects[select_index..-1].each ->
      $("option:gt(0)", this).remove()
    # when select value not empty
    if select[0] and $(this).val()
      $.get "/district/" + $(this).val(), (data) ->
        result = eval(data)
        options = select[0].options
        $.each result, (i, item) -> options.add new Option(item[0], item[1])
        select.change()
