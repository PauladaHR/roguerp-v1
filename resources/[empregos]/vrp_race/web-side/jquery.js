$(document).ready(function () {
  window.addEventListener("message", function (event) {
    if (event.data.active == true) {
      $("#pos").html(event.data.pos);
      $("#total").html(event.data.total);
      $("#time").html(event.data.time);
      $("#menu").show();
    } else {
      $("#menu").hide();
      $("#pos").html("");
      $("#total").html("");
      $("#time").html("");
    }
  });
});
