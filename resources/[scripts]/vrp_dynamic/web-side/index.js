$(document).ready(function (){
	const buttons = []
	const submenus = []
	const subsubmenus = []

	document.onkeyup = function(data){
		if (data["which"] == 27){
			buttons["length"] = 0;
			submenus["length"] = 0;
			subsubmenus["length"] = 0;

			$.post("http://vrp_dynamic/close",JSON.stringify({}));
			$("button").remove();
			$("#title").html("");
		} else if(data["which"] == 8){
			$("button").remove();

			for (i = 0; i < buttons["length"]; ++i){
				var div = buttons[i];
				var match = div.match("normalbutton");
				if(match){
					$(".container").prepend(div);
				}
			}

			$(".container").append(submenus).show();
		}
	}

	window.addEventListener("message",function(event){
		var item = event["data"];

		if(item["addbutton"] == true){
			if(item.id == false || null){
				var b = (`<button id="normalbutton" data-trigger="`+item["trigger"]+`" data-parm="`+item["par"]+`" data-server="`+item["server"]+`" class="btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div></button>`);
				buttons.push(b);
				return

			} else if(item.submenu == true) {
				var c = (`<button data-menu2=`+item["id2"]+` data-menu="`+item["id"]+`"class="c btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div><i class="fas fa-chevron-right" style="float:right;margin-top:-10%"></i></button>`)
				subsubmenus.push(c);

			} else {
				var b = (`<button id="`+item["id"]+`"data-trigger="`+item["trigger"]+`" data-parm="`+item["par"]+`" data-server="`+item["server"]+`" class="a btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div></button>`);
				buttons.push(b);
			}

		} else if(item["addmenu"] == true){
			var aa = (`<button data-menu="`+item["menuid"]+`"class="b btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div><i class="fas fa-chevron-right" style="float:right;margin-top:-10%"></i></button>`)
			$(".container").append(aa);
			$(".container").show();
			submenus.push(aa);

		} else if(item["buttonadd"] == true){
			var d = (`<button id="normalbutton" data-trigger="`+item["trigger"]+`" data-parm="`+item["par"]+`" data-server="`+item["server"]+`" class="btn"><div class="title">`+item["title"]+`</div><div class="description" >`+item["description"]+`</div></button>`);
			$(".container").append(d);
			$(".container").show();
			submenus.push(d);
		}

		if (item["close"] == true){
			buttons["length"] = 0;
			submenus["length"] = 0;
			subsubmenus["length"] = 0;
			$("button").remove();
			$("#title").html("");
		}
	});

	function goback(){
		var gobackbutton = (`<button style="height:10px; amarelo;" id="goback"class ="btn"><div class="title" style="margin-top:-3.8%">Voltar</div><i class="fas fa-chevron-left" style="float: right; margin-top:-3.5%"></i></button>`);
		$(".container").append(gobackbutton).show();
	}

	$("body").on("click",".a",function(){
		$.post("http://vrp_dynamic/clicked",JSON.stringify({ trigger:$(this).attr("data-trigger"), param:$(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click","#normalbutton",function(){
		$.post("http://vrp_dynamic/clicked",JSON.stringify({ trigger: $(this).attr("data-trigger"), param: $(this).attr("data-parm"), server: $(this).attr("data-server") }));
	});

	$("body").on("click",".b",function(){
		$("#normalbutton").remove();
		$("#normalbutton").remove();
		goback();

		$(".b").remove();
		$(".c").remove();
		$(".a").remove();
		$(".d").remove();

		var menuid = $(this).attr("data-menu");
			
		for (i2 = 0; i2 < subsubmenus["length"]; ++i2){
			var div2 = subsubmenus[i2];
			var match2 = div2.match(`data-menu="`+menuid+`"`);
			if(match2) {
				$(".container").append(div2);
			}
		}
		
		for (i = 0; i < buttons["length"]; ++i){
			var div = buttons[i];
			var match = div.match(`id="`+menuid+`"`);
			if(match) {
				$(".container").append(div);
			}
		}
	});

	$("body").on("click",".c",function(){
		$(".b").remove();
		$(".c").remove();
		$(".a").remove();
		$(".d").remove();

		var menuid = $(this).attr("data-menu2");
		
		for (i = 0; i < buttons["length"]; ++i){
			var div = buttons[i];
			var match = div.match(`id="`+menuid+`"`);
			if(match) {
				$(".container").append(div);
			}
		}
	});

	$("body").on("click","[id=goback]",function(){
		$(".b").remove();
		$(".c").remove();
		$(".a").remove();
		$(".d").remove();
		$("button").remove();
		$(".container").append(submenus).show();
		
        for (i2 = 0; i2 < subsubmenus["length"]; ++i2){
            var div2 = subsubmenus[i2];
            var match2 = div2.match("normalbutton");
            if(match2) {
                $(".container").append(div2);
            }
        }
		for (i = 0; i < buttons["length"]; ++i){
			var div = buttons[i];
			var match = div.match("normalbutton");
			if(match){
				$(".container").append(div);
			}
		}
	});
	
});