$(document).ready ->
  editAreaLoader.init
    id: 'survey_xml'
    syntax: 'xml'
    start_highlight: true
    allow_toggle: false
    replace_tab_by_spaces: 2

  $('.fancybox').fancybox
    margin: 100

  $('fieldset input[type="submit"], .dependent').twipsy()

  if $('.page-container').hasClass('autosubmit')
    $('.page-container form').submit()
  else
    $('.loading').hide()
    $('.page-container form').show()

  $('table').each ->
    if $(this).find('tr:visible').length == 1
      $(this).hide()
