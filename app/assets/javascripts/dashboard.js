$(function() {
  $('.toggle-link').on('ajax:beforeSend', function(event) {
    $(event.target)
      .removeClass('fa-heart')
      .removeClass('far')
      .addClass('fa-spin')
      .addClass('fa-sync')
      .addClass('fas');
  });

  $('.toggle-link').on('ajax:complete', function(event) {
    $(event.target)
      .removeClass('fa-spin')
      .removeClass('fa-sync');
  });
});
