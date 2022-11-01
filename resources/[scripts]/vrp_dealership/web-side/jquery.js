var selectPage = "commands";
var reversePage = "commands";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	benefactor("Carros");

	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
			case "openSystem":
				$("#mainPage").css("display","block");
				benefactor("Carros");
			break;

			case "closeSystem":
				$("#mainPage").css("display","none");
			break;

			case "requestPossuidos":
				benefactor("Possuidos");
			break;
		};
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://vrp_dealership/dealerClose");
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click","#mainMenu li",function(){
	if (selectPage != reversePage){
		let isActive = $(this).hasClass("active");
		$("#mainMenu li").removeClass("active");
		if (!isActive){
			$(this).addClass("active");
			reversePage = selectPage;
		};
	};
});
/* ---------------------------------------------------------------------------------------------------------------- */
var benMode = "Carros"
var benSearch = "alphabetic"

const searchTypePage = (mode) => {
	benSearch = mode;
	benefactor(benMode);
}
/* ---------------------------------------------------------------------------------------------------------------- */
const benefactor = (mode) => {
	benMode = mode;
	selectPage = "benefactor";

	$("#content").html(`
		<div id="benefactorBar">
			<li id="benefactor" data-id="Carros" ${mode == "Carros" ? "class=active":""}>CARROS</li>
			<li id="benefactor" data-id="Motos" ${mode == "Motos" ? "class=active":""}>MOTOS</li>
			<li id="benefactor" data-id="Aluguel" ${mode == "Aluguel" ? "class=active":""}>ALUGUEL</li>
			<li id="benefactor" data-id="Possuidos" ${mode == "Possuidos" ? "class=active":""}>POSSUÍDOS</li>
		</div>

		<div id="contentVehicles">
			<div id="titleVehicles">${mode}</div>
			<div id="typeSearch"><span onclick="searchTypePage('alphabetic');">Ordem Alfabética</span> / <span onclick="searchTypePage('crescent');">Valor Crescente</span></div>
			<div id="pageVehicles"></div>
		</div>
	`);

	$.post("http://vrp_dealership/request"+ mode,JSON.stringify({mode}),(data) => {
		if (benSearch == "alphabetic"){
			var nameList = data["veiculos"].sort((a,b) => (a["nome"] > b["nome"]) ? 1: -1);
		} else {
			var nameList = data["veiculos"].sort((a,b) => (a["price"] > b["price"]) ? 1: -1);
		}

		if (mode !== "Possuidos"){
			$("#pageVehicles").html(`
				${nameList.map((item) => (`<span>
					<left>
						${item["nome"]}
						${ mode === "Aluguel" ? "" : `<br><b>Valor:</b> ${format(item["price"])}` }
						<br><b>Porta-Malas:</b> ${format(item["chest"])}Kg
						${ mode === "Aluguel" ? "" : `<br><b>Estoque:</b> ${format(item["stock"])}` }
					</left>
					<right>
					${ mode === "Aluguel" ? "" : `<div id=benefactorBuy data-name="${item["k"]}">COMPRAR</div>` }
					<div id="benefactorDrive" data-name="${item["k"]}">T</div>
					<div id="benefactorTesteUm" data-name="${item["k"]}">1</div>
					<div id="benefactorTesteDois" data-name="${item["k"]}">2</div>
				</right>
				</span>`)).join('')}
			`);
		} else {
			$("#pageVehicles").html(`
				${nameList.map((item) => (`<span>
					<left>
						<i>${item["nome"]}</i><br>
						<b>Venda:</b> $${format(item["price"])}<br>
						<b>Taxa:</b> ${item["tax"]}
					</left>
					<right>
						<div id="benefactorTax" data-name="${item["k"]}">PAGAR</div>
					</right>
				</span>`)).join('')}
			`);
		}
	});
};
/* ----------BENEFACTOR---------- */
$(document).on("click","#benefactor",function(e){
	benefactor(e["target"]["dataset"]["id"]);
});
/* ----------BENEFACTORBUY---------- */
$(document).on("click","#benefactorBuy",function(e){
	$.post("http://vrp_dealership/buyDealer",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORBUY---------- */
$(document).on("click","#benefactorRental",function(e){
	$.post("http://vrp_dealership/requestBuyRental",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORSELL---------- */
$(document).on("click","#benefactorSell",function(e){
	$.post("http://vrp_dealership/sellDealer",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORTAX---------- */
$(document).on("click","#benefactorTax",function(e){
	$.post("http://vrp_dealership/payTax",JSON.stringify({ name: e["target"]["dataset"]["name"] }));
});
/* ----------BENEFACTORDRIVE---------- */
$(document).on("click","#benefactorDrive",function(e){
	$.post("http://vrp_dealership/HandleTest",JSON.stringify({name: e["target"]["dataset"]["name"]}));
});
/* ----------BENEFACTORTESTE1---------- */
$(document).on("click","#benefactorTesteUm",function(e){
	$.post("http://vrp_dealership/HandleSpawn",JSON.stringify({name: e["target"]["dataset"]["name"], spawn: 1}));
});
/* ----------BENEFACTORTESTE2---------- */
$(document).on("click","#benefactorTesteDois",function(e){
	$.post("http://vrp_dealership/HandleSpawn",JSON.stringify({name: e["target"]["dataset"]["name"], spawn: 2}));
});
/* ----------FORMAT---------- */
const format = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}