var wait = 1500;

var auto_refresh = setInterval(
  function ()
  {
    if ($('.meter').length > 0) {
      console.log(($(".meter").width() / $('.meter').parent().width() * 100));
      if(($(".meter").width() / $('.meter').parent().width() * 100) > 99) {
        wait = 10000;
        document.location.reload(true);
      }
      $('#build-progress').load($(".meter").attr('id') + '/status');
    }
  },
wait);
