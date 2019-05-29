$(function() {
  $('.toggle-link').on('ajax:beforeSend', function(event) {
    var icon = $('i', event.target).data('icon');
    $('i:not(.fa-spin)', event.target).hide();
    $('i.fa-spin', event.target).css('display', 'inline-block');
  });

  $('.toggle-link').on('ajax:complete', function(event) {
    var icon = $('i', event.target).data('icon');
    $('i:not(.fa-spin)', event.target).show();
    $('i.fa-spin', event.target).hide();
  });
});
