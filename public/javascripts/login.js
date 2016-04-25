(function($) {
  $(function() {
    var loginForm = $('.cool-popup.login-form');

    loginForm.find('a.link-to-reset-password').bind('click', function(e) {
      e.stopPropagation();
      loginForm.addClass('hidden');
      $('.cool-popup.forgot-password-form').removeClass('hidden');
      popups.center($('.cool-popup.forgot-password-form')[0])
    });

    $('.cool-popup.forgot-password-form').find('a.back-to-login').bind('click', function(e) {
      $('.cool-popup.login-form').removeClass('hidden');
      $('.cool-popup.forgot-password-form').addClass('hidden');
    });

    $('.loginable').click(function(e) {
      e.stopPropagation();

      $('.cool-popup').addClass('hidden');
      $('.cool-popup.login-form').removeClass('hidden');

      popups.center($('.cool-popup.login-form')[0])
      
      $('#user_session_email').get(0).focus();

      $('.cool-popup.login-form, .cool-popup.forgot-password-form').click(function (e) {
        e.stopPropagation();
      });

      var loginLink = $('#header .top a.log-in').addClass("hidden");

      $("body").click(function() {
        $('.cool-popup').addClass('hidden');
        $(this).unbind('click');
        loginLink.removeClass("hidden");
      });
      return false;
    });
  });
})(jQuery);