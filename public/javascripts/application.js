$(document).ready(function() {
  //flash alerts
  $(".alert .close").click(function(e){
    $(this).closest(".alert").remove();
  });
});