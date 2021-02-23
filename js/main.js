

var screenValid = false;

var widthReq = 1920;
var heightReq = 1050;

$("document").ready(function(){
  init();
});

function init() {
  checkScreen();
  window.addEventListener('resize', checkScreen);

  $("#gobutton").click(function(){
    if(screenValid){
      $.post("php/idcounter.php",
      {
        command: "registerUserID",
        workerPrefix: "expert",
        devPixRatio: window.devicePixelRatio,
        screenRes: window.screen.width+"x"+window.screen.height,
        availRes: window.screen.availWidth+"x"+window.screen.availHeight,
        windowRes: window.innerWidth+"x"+window.innerHeight,
      },
      function(data,status){
        window.location.replace(data);
      });
    }
  });
}


function checkScreen() {
  $("#devPixRatio").text(window.devicePixelRatio);
  $("#screenRes").text(window.screen.width+"x"+window.screen.height);
  $("#availRes").text(window.screen.availWidth+"x"+window.screen.availHeight);
  $("#windowRes").text(window.innerWidth+"x"+window.innerHeight);

  if (window.devicePixelRatio!=1) {
    $("#devPixRatio").removeClass("table-success")
    $("#devPixRatio").addClass("table-danger");
    devPixRatio = false;
  }
  else {
    $("#devPixRatio").removeClass("table-danger")
    $("#devPixRatio").addClass("table-success");
    devPixRatio = true;
  }

  if (window.screen.width>=widthReq && window.screen.height>=heightReq) {
    $("#screenRes").removeClass("table-danger")
    $("#screenRes").addClass("table-success");
    screenRes = true;
  } else {
    $("#screenRes").removeClass("table-success")
    $("#screenRes").addClass("table-danger");
    screenRes = false;
  }

  if (window.screen.availWidth>=widthReq && window.screen.availHeight>=heightReq) {
    $("#availRes").removeClass("table-danger")
    $("#availRes").addClass("table-success");
    availRes = true;
  } else {
    $("#availRes").removeClass("table-success")
    $("#availRes").addClass("table-danger");
    availRes = false;
  }

  if (window.innerWidth>=widthReq && window.innerHeight>=heightReq) {
    $("#windowRes").removeClass("table-danger")
    $("#windowRes").addClass("table-success");
    windowRes = true;
  } else {
    $("#windowRes").removeClass("table-success")
    $("#windowRes").addClass("table-danger");
    windowRes = false;
  }
  screenValid = devPixRatio & screenRes & availRes & windowRes;

  if (screenValid) {
    $("#gobutton").removeClass("btn-outline-secondary");
    $("#gobutton").addClass("btn-primary");
  } else {
    $("#gobutton").removeClass("btn-primary");
    $("#gobutton").addClass("btn-outline-secondary");
  }
}
