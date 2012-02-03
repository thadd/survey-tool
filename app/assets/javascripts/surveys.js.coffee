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
