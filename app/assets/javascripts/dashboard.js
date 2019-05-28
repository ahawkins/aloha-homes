$(function() {
  $('.toggle-link').on('ajax:beforeSend', function(event) {
    $(event.target)
      .addClass('fa-spin')
      .addClass('fa-sync')
      .addClass('fas')
      .removeClass('fa-heart')
      .removeClass('far');
  });

  $('.toggle-link').on('ajax:beforeSend', function(event) {
    $(event.target)
      .removeClass('fa-spin')
      .removeClass('fa-sync');
  });
});
