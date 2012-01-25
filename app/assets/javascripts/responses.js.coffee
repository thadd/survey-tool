$(document).ready ->

  $('table').each ->
    if $(this).find('tr:visible').length == 1
      $(this).hide()
