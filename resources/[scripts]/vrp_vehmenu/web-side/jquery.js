/* ----------EVENTLISTENER---------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		if (event["data"]["show"] == true){
			$("body").css("display","block");
		}

		if (event["data"]["show"] == false){
			$("body").css("display","none");
		}
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://vrp_vehmenu/closeSystem");
		};
	};
});
/* ----------MENUACTIVE---------- */
$(document).on("click",".vehicleButton",debounce(function(e){
	var name = e["currentTarget"]["dataset"]["name"];

	if (name == "close"){
		$.post("http://vrp_vehmenu/closeSystem");
	} else {
		$.post("http://vrp_vehmenu/menuActive",JSON.stringify({ active: name }));
	}
}));
/* ----------DEBOUNCE---------- */
function debounce(func,immediate){
	var timeout
	return function(){
		var context = this,args = arguments
		var later = function(){
			timeout = null
			if (!immediate) func.apply(context,args)
		}
		var callNow = immediate && !timeout
		clearTimeout(timeout)
		timeout = setTimeout(later,100)
		if (callNow) func.apply(context,args)
	}
}