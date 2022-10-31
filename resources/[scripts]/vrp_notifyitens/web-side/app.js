$(document).ready(function(){
	window.addEventListener("message",function(event){
		var html = `<div class="item" style="background-image: url('http://189.127.164.77/inventory/armas/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/comidas/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/geral/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/hospital/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/ilegal/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/mechanic/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/premium/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/veiculos/${event.data.item}.png'),
		url('http://189.127.164.77/inventory/weapons/${event.data.item}.png');">
			<div class="itemWeight">${event.data.mode}</div>
			<div class="itemAmount">${event.data.amount}x</div>
		</div>`;

		$(html).fadeIn(500).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});