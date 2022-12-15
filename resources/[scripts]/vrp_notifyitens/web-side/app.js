$(document).ready(function(){
	window.addEventListener("message",function(event){
		var html = `<div class="item" style="background-image: url('nui://vrp_inventory/web-side/images/armas/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/comidas/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/geral/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/hospital/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/ilegal/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/mechanic/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/premium/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/veiculos/${event.data.item}.png'),
		url('nui://vrp_inventory/web-side/images/weapons/${event.data.item}.png');">
			<div class="itemWeight">${event.data.mode}</div>
			<div class="itemAmount">${event.data.amount}x</div>
		</div>`;

		$(html).fadeIn(500).appendTo("#notifyitens").delay(3000).fadeOut(500);
	})
});