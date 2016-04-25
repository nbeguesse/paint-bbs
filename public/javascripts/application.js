$(document).ready(function() {
  //close flash alerts
  $(".alert .close").click(function(e){
    $(this).closest(".alert").remove();
  });

  $("#mobileMenuLink").click(function(e){
    $("#mobileNav").toggleClass("menu-open");
  });

  //catch spam on comments
   var e = document.getElementById("blank-field");
   if(e){
     e.parentNode.removeChild(e);
   }

   //Canvas Size form popup
    $('.set-canvas-size').click(function(e) {
      e.stopPropagation();
      $('.cool-popup').addClass('hidden');
      $('.cool-popup.canvas-size-form').removeClass('hidden');
      popups.center($('.cool-popup.canvas-size-form')[0])
      $('#width').get(0).focus();
      $('.cool-popup.canvas-size-form').click(function (e) {
        e.stopPropagation();
      });
      $("body").click(function() {
        $('.cool-popup').addClass('hidden');
        $(this).unbind('click');
      });
      return false;
    });

     //Share form popup
    $('.share').click(function(e) {
      e.stopPropagation();
      var shareform = $("#"+$(this).data("share"));
      $('.cool-popup').addClass('hidden');
      shareform.remove().appendTo("body").removeClass('hidden');
      popups.center($(shareform)[0]);
      shareform.click(function (e) {
        e.stopPropagation();
      });
      $("body").click(function() {
        shareform.addClass('hidden');
        $(this).unbind('click');
      });
      return false;
    });

    //Upload validation
    var upload = $("#i-made-this");
    if(upload.length > 0){
      upload.closest("form").submit(function(e){
        if(!document.getElementById('i-made-this').checked){
          if($("#post_image").val() != ""){
            alert("You can only upload artwork you own.");
            return false;
          }
        }
      });
    }
});