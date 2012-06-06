update_positions = (mirror) ->
  $('#scroll_top').val($('.CodeMirror-scroll').scrollTop());

$(document).ready ->

  $('.fancybox').fancybox
    margin: 100

  if $('#survey_xml').length != 0
    code_mirror = CodeMirror.fromTextArea(
      $('#survey_xml')[0]
      {
        fixedGutter: true
        lineNumbers: true
        lineWrapping: true
        tabSize: 2
        theme: 'rubyblue'
        onCursorActivity: update_positions
        onScroll: update_positions
      }
    )

  if code_mirror && $('#scroll_top').length != 0
    if $('#scroll_top').val() != '-1'
      top = $('#scroll_top').val()
      setTimeout ( ->
        code_mirror.scrollTo(0, top)
      ), 100

  $('fieldset input[type="submit"], .dependent').tooltip()

  if $('.page-container').hasClass('autosubmit')
    $('.page-container form').submit()
  else
    $('.loading').hide()
    $('.page-container form').show()

  $('table').each ->
    if $(this).find('tr:visible').length == 1
      $(this).hide()
