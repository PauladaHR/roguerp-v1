var tickInterval = undefined;
var lastHealth = 999;
var lastArmour = 999;
var lastStress = 999;
var lastHunger = 999;
var lastOxigen = 999;
var lastWater = 999;
var teste = false;

$(document).ready(function () {
  window.addEventListener('message', function (event) {

          if (event["data"]["hud"] !== undefined) {
            if (event["data"]["hud"] == true) {
                $("#displayHud").css("visibility", "visible");
                $("#displayHud").fadeIn(500);
            } else {
                $("#displayHud").css("visibility", "hidden");
                $("#displayHud").fadeOut(500);
            }

            return
        }

          if (event["data"]["movie"] !== undefined) {
            if (event["data"]["movie"] == true) {
                $("#movieTop").fadeIn(500);
                $("#movieBottom").fadeIn(500);
            } else {
                $("#movieTop").fadeOut(500);
                $("#movieBottom").fadeOut(500);
            }

            return
        }

        if (event["data"]["mumble"] !== undefined){
          if (event["data"]["mumble"] == true){
            $("#Mumble").css("display","flex");
          } else {
            $("#Mumble").css("display","none");
          }
    
          return
        }

          if (event["data"]["hood"] !== undefined) {
            if (event["data"]["hood"] == true) {
                $("#hoodDisplay").fadeIn(500);
            } else {
                $("#hoodDisplay").fadeOut(500);
            }
        }

        if (event["data"]["progress"] == true) {
          var timeSlamp = event["data"]["progressTimer"];

          if ($("#progressBackground").css("display") === "block") {
              $("#progressDisplay").css("stroke-dashoffset", "100");
              $("#progressBackground").css("display", "none");
              clearInterval(tickInterval);
              tickInterval = undefined;

              return
          } else {
              $("#progressBackground").css("display", "block");
              $("#progressDisplay").css("stroke-dashoffset", "100");
          }

          var tickPerc = 100;
          var tickTimer = (timeSlamp / 100);
          tickInterval = setInterval(tickFrame, tickTimer);

          function tickFrame() {
              tickPerc--;

              if (tickPerc <= 0) {
                  clearInterval(tickInterval);
                  tickInterval = undefined;
                  $("#progressBackground").css("display", "none");
              } else {
                  timeSlamp = timeSlamp - (timeSlamp / tickPerc);
              }

              $("#textProgress").html(parseInt(timeSlamp / 1000));
              $("#progressDisplay").css("stroke-dashoffset", tickPerc);
          }

          return
      }

      if (lastOxigen !== event["data"]["oxigen"]) {
        lastOxigen = event["data"]["oxigen"];

        if (event["data"]["oxigen"] == 10) {
            if ($(".oxigenBackground").css("display") === "block") {
                $(".oxigenBackground").css("display", "none");
            }
        } else {
            if ($(".oxigenBackground").css("display") === "none") {
                $(".oxigenBackground").css("display", "block");
            }
        }

        if (event["data"]["oxigen"] <= 0)
            event["data"]["oxigen"] = 0;

        if (event["data"]["oxigen"] <= 10) {
            $(".oxigenDisplay").css("stroke-dashoffset", 100 - (event["data"]["oxigen"] * 10));
        } else {
            $(".oxigenDisplay").css("stroke-dashoffset", 100 - (event["data"]["oxigen"] / 12));
        }
    }

    if (lastStress !== event["data"]["stress"]) {
      lastStress = event["data"]["stress"];

      console.log(event["data"]["stress"])

      if (event["data"]["stress"] <= 0) {
          if ($(".stressBackground").css("display") === "block") {
              $(".stressBackground").css("display", "none");
          }
      } else {
          if ($(".stressBackground").css("display") === "none") {
              $(".stressBackground").css("display", "block");
          }
      }

      $(".stressDisplay").css("stroke-dashoffset", 100 - (event["data"]["stress"] / 3));
    }

    if (lastHealth !== event['data']['health']) {
      lastHealth = event['data']['health'];

      if (event['data']['health'] <= 1) {
        $('.statusBar .life-fill').css({ height: '4', width: '0%' });
      } else {
        $('.statusBar .life-fill').css({ height: '4', width: event['data']['health'] + '%', });
      }

      if (event['data']['health'] <= 50) {
        changeHealth()
      } else {
        defaultFill(".life-fill",".healthSvg")
      }
    }

    if (lastWater !== event['data']['thirst']) {
      lastWater = event['data']['thirst'];

      $('.statusBar .thirst-fill').css({
        height: '4',
        width: event['data']['thirst'] + '%',
      });

      
      if (event['data']['thirst'] <= 50) {
        changeThirst()
      } else {
        defaultFill(".thirst-fill",".thirstSvg")
      }
    }

    if (lastHunger !== event['data']['hunger']) {
      lastHunger = event['data']['hunger'];

      if (event['data']['hunger'] <= 50) {
        changeHunger()
      } else {
        defaultFill(".hunger-fill",".hungerSvg")
      }

      $('.statusBar .hunger-fill').css({
        height: '4',
        width: event['data']['hunger'] + '%',
      });
    }

    if (lastArmour !== event['data']['armour']) {
      lastArmour = event['data']['armour'];

      if (event['data']['armour'] <= 0) {
        $('armour').fadeOut(800);
        $('hudStatus').removeClass('statusBar armour');
        $('bolasStatus').css("bottom","115px");
      } else {
        $('armour').fadeIn(800);
        $('hudStatus').addClass('statusBar armour');
        $('bolasStatus').css("bottom","135px");
      }

      if (event['data']['armour'] <= 50) {
        changeArmour()
      } else {
        defaultFill(".armour-fill",".armourSvg")
      }

      $('.statusBar .armour-fill').css({
        height: '4',
        width: event['data']['armour'] + '%',
      });
    }

    if (event["data"]["showTime"] == false) {

      if (event['data']['hours'] <= 9) {
        event['data']['hours'] = '0' + event['data']['hours'];
      }
  
      if (event['data']['minutes'] <= 9) {
        event['data']['minutes'] = '0' + event['data']['minutes'];
      }

      $('.clock.align').fadeIn(800);
      $('.clock.text').fadeIn(800);


      $('.clock.text').html('<text>' + event['data']['hours'] + ':' + event['data']['minutes'] + '<b> ' + '66.69.99' + '</text>',);
      $('.location.text').html('<text>' + '<span>' + event['data']['direction'] + '</span><br>' + '<small>' + event['data']['street'] + '</small>' + '</text>',);

    } else {
      $('.clock.align').hide();
      $('.clock.text').hide();
    }

    if (event['data']['radio']) {
      $('.radio.align').fadeIn(800);
      $('.radio.text').fadeIn(800);
      $('.radio.text').html(' ' + event['data']['radio']);
    } else {
      $('.radio.align').hide();
      $('.radio.text').hide();
    }

    if (event['data']['talking'] == true) {
      $('.microphone .fill').css('background', 'rgb(181, 79, 98)');
    } else {
      $('.microphone .fill').css('background', 'rgb(255, 255, 255)');

      if (event['data']['voice'] == 1) {
        $('.microphone .fill').css({ width: '25%' });
      } else if (event['data']['voice'] == 2) {
        $('.microphone .fill').css({ width: '50%' });
      } else if (event['data']['voice'] == 3) {
        $('.microphone .fill').css({ width: '75%' });
      } else if (event['data']['voice'] == 4) {
        $('.microphone .fill').css({ width: '100%' });
      }
    }

    if (event['data']['vehicle'] !== undefined) {
      if (event['data']['vehicle'] == true) {
        inCar();

        $('hudStatus').removeClass('velocimeter #belt');
        $('hudStatus').removeClass("exit-vehicle");
        $('velocimeter').css('opacity', '1');
        $(".velocimetro.text").html('<text>' + "<span>" + parseInt(event["data"]["speed"]) + "<small>" + "KM/h" + "</small>" + "</span>" + '</text>');
        $(".fuel.text").html('<text>' + "<b>" + parseInt(event["data"]["fuel"]) + "</b>" + '</text>');
        $('hudInfo').css('left','19%');
        
        $('bolasStatus').addClass('active-Vehicle');

       //if (teste == true) {
       //  $('bolasStatus').css("bottom","105px");
       //}

        var loading = new ldBar(".ldBar");
        loading.set(parseInt(event["data"]["speed"] / 1.6 ), true);

        if (event["data"]["showbelt"] == true) {
          $(".belt2").css("opacity","1");
          if(event["data"]["seatbelt"] == 1){
              changeFilter(".belt2", "invert(57%) sepia(7%) saturate(3038%) hue-rotate(71deg) brightness(90%) contrast(110%)")
          } else {
              changeFilter(".belt2", "invert(61%) sepia(0%) saturate(1283%) hue-rotate(204deg) brightness(91%) contrast(82%)")
          }
        } else {
          $(".belt2").css("opacity","0");
        }



        $(".velocimetro.text").html('<text>' + "<span>" + parseInt(event["data"]["speed"]) + "<small>" + "KM/h" + "</small>" + "</span>" + '</text>');
        $(".fuel.text").html('<text>' + "<b>" + parseInt(event["data"]["fuel"]) + "</b>" + '</text>');
      } else {
        outCar();

        $('bolasStatus').removeClass('active-Vehicle');

        $('hudStatus').addClass('exit-vehicle');
        $('velocimeter').css('opacity', '0');
        $('hudInfo').css('left', '3%')
        
        $(".velocimetro.text").html('<text>' + "<span>" + event["data"]["speed"] + "</span>" + '</text>')
      }

      function inCar() {
        $('.statusBar .life-fill').css({ height: event['data']['health'] + '%', width: '100%', });
        $('.statusBar .thirst-fill').css({ height: event['data']['thirst'] + '%',  width: '100%', });
        $('.statusBar .hunger-fill').css({  height: event['data']['hunger'] + '%',  width: '100%',});
        $('.statusBar .armour-fill').css({  height: event['data']['armour'] + '%',  width: '100%',});
      }
    
      function outCar(){
        $('.statusBar .life-fill').css({  height: '4',  width: event['data']['health'] + '%',});
        $('.statusBar .thirst-fill').css({  height: '4',  width: event['data']['thirst'] + '%',});
        $('.statusBar .hunger-fill').css({  height: '4',  width: event['data']['hunger'] + '%',});
        $('.statusBar .armour-fill').css({  height: '4',  width: event['data']['armour'] + '%',});
      }

    }
  });


  function changeFilter(element, color) {
    $(element).css('filter', color);
  }
  
  function changeHealth() {
    $(".life-fill").css('background-color',"rgb(255, 111, 111)");
    $(".life-fill").css('animation', "pulse-red 2s infinite");
    $(".healthSvg").css('filter', "brightness(0) saturate(100%) invert(70%) sepia(41%) saturate(5304%) hue-rotate(317deg) brightness(104%) contrast(99%)");
  }

  function changeThirst() {
    $(".thirst-fill").css('background-color',"rgb(102, 154, 225)");
    $(".thirst-fill").css('animation', "pulse-blue 2s infinite");
    $(".thirstSvg").css('filter', "brightness(0) saturate(100%) invert(66%) sepia(64%) saturate(2790%) hue-rotate(189deg) brightness(95%) contrast(84%)");
  }

  function changeHunger() {
    $(".hunger-fill").css('background-color',"rgb(252, 145, 58)");
    $(".hunger-fill").css('animation', "pulse-orange 2s infinite");
    $(".hungerSvg").css('filter', "brightness(0) saturate(100%) invert(65%) sepia(84%) saturate(1013%) hue-rotate(330deg) brightness(98%) contrast(102%)");
  }

  function changeArmour() {
    $(".armour-fill").css('background-color',"rgb(97, 47, 153)");
    $(".armour-fill").css('animation', "pulse-purple 2s infinite");
    $(".armourSvg").css('filter', "brightness(0) saturate(100%) invert(19%) sepia(81%) saturate(1727%) hue-rotate(251deg) brightness(91%) contrast(94%)");
  }

  function defaultFill(element,element2) {
    $(element).css('background-color',"rgb(255, 255, 255)");
    $(element).css('animation', "none");
    $(element2).css('filter', "none");
  }

});
