var selectPage = "";
var reversePage = "";
var openRestaurant = ""
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){
	window.addEventListener("message",function(event){
		switch (event["data"]["action"]){
            case "openSystem":
                openRestaurant = event.data.name;
				$("#mainPage").css("display","block");
                buyPage();
            break;

			case "closeSystem":
				$("#mainPage").css("display","none");
				openRestaurant = "";
			break;

			case "buyPage":
				buyPage();
			break;
		};
	});

	document.onkeyup = function(data){
		if (data["which"] == 27){
			$.post("http://vrp_tabletshops/closeSystem");
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
const buyPage = () => {
	selectPage = "buyPage";

	$.post("http://vrp_tabletshops/getRestaurant",JSON.stringify({ restaurant: openRestaurant }), (data) =>{

		$('#mainPage').html(`
		<div id="header"></div>
		<div id="mainMenu">
			<li onclick="buyPage();" class="active">INÍCIO</li>
		</div>
		<div id='content'></div>
		`);

		if (data["masterPermiss"]){
			document.getElementById('mainMenu').innerHTML = `<li onclick="buyPage();" class="active">INÍCIO</li> <li onclick="funcionaryPage();">FUNCIONÁRIOS</li>`;
		} 
		
		$('#content').html(`
		<div id="contentShops">
			<div id="pageVehicles"></div>
			<div id='pixBoxTwo'>
				<div class="title-sacar"> <b>COMPRA DE INGREDIENTES</b>Você pode comprar diversos produtos tendo o dinheiro disponível.</div>

				<input id="buyquantidade" class="bicho" maxlength="9" spellcheck="false" value="" placeholder="QUANTIDADE..">
				<input id="buyvalor" class="valor" maxlength="9" spellcheck="false" value="" placeholder="VALOR..">
				
				<select id="boxselect" class="select" name="select">
				</select>

				<div id="buyenviar" class="apostar"><i class="fas fa-check-circle fa-lg"></i></div>
				<div id="buyremover" class="remover"><i class="fas fa-times-circle fa-lg"></i></div>

				<div class="title-sacar2">Lembre-se de confirmar todas as informações preenchidas antes de enviar o formulário, pois não é possível efetuar o reembolso.
			</div></div>


			<div id='pixBoxTwo'>
			<div class="title-sacar"> <b>VENDA DE ALIMENTOS</b>Você pode vender diversos produtos tendo o produto disponível.</div>

			<input id="sellquantidade" class="bicho" maxlength="9" spellcheck="false" value="" placeholder="QUANTIDADE..">
			<input id="sellvalor" class="valor" maxlength="9" spellcheck="false" value="" placeholder="VALOR..">

			<select id="boxselect2" class="select" name="select">
			</select>

			<div id="sellenviar" class="apostar"><i class="fas fa-check-circle fa-lg"></i></div>
			<div id="sellremover" class="remover"><i class="fas fa-times-circle fa-lg"></i></div>

			<div class="title-sacar2">Lembre-se de confirmar todas as informações preenchidas antes de enviar o formulário, pois não é possível efetuar o reembolso.
			</div></div>

			<div id='separarBox'>	
				<div id='pixBoxTree'>
					<div class="title-sacar"> <b>SALDO DISPONÍVEL $${(data["restaurantBalance"])}</b>Saldo disponível em caixa da empresa.</div>

					<input id="valorcash" class="valorcash" maxlength="9" spellcheck="false" value="" placeholder="VALOR..">

					<div class="sacar">SACAR</div>
					<div class="depositar">DEPOSITAR</div>

					<div class="title-sacar2">Lembre-se de confirmar todas as informações preenchidas antes de enviar o formulário, pois não é possível efetuar o reembolso.
			</div></div>
		</div>
		`);

		for (var restaurantType in data) {
			if (restaurantType == "restaurantBuy") {
				const content = []
				for ( var items in data[restaurantType]){
					content.push(`
						<option id="valor${data[restaurantType][items]["key"]}" value="${data[restaurantType][items]["indexName"]}">${data[restaurantType][items]["name"]}</option>
					`)
					
				}
				document.getElementById('boxselect').innerHTML = content;
			}

			if (restaurantType == "restaurantSell") {
				const content = []
				for ( var items in data[restaurantType]){
					content.push(`
						<option id="valor${data[restaurantType][items]["key"]}" value="${data[restaurantType][items]["indexName"]}">${data[restaurantType][items]["name"]}</option>
					`)
					
				}
				document.getElementById('boxselect2').innerHTML = content;
			}
		}
	});
};

/* ---------------------------------------------------------------------------------------------------------------- */
/* FUNCIONARY PAGE */
/* ---------------------------------------------------------------------------------------------------------------- */

const funcionaryPage = () => {
    selectPage = "funcionaryPage";
	$('#content').html(`
		<div id="contentShops">
		<div id="pageVehicles"></div>

		<div id='pixBoxTree'>
			<div class="title-sacar"> <b>CONTROLE DE FUNCIONÁRIOS</b>Você pode adicionar e remover sócios da empresa aqui.</div>

			<input id="passaporte" class="valorcash2" maxlength="4" spellcheck="false" value="" placeholder="PASSAPORT..">

			<div id="adicionaruser" class="adicionar"><i class="fas fa-check-circle fa-lg"></i></div>
			<div id="removeruser" class="removeruser"><i class="fas fa-times-circle fa-lg"></i></div>

			<div class="title-sacar2">Lembre-se de confirmar todas as informações preenchidas antes de enviar o formulário.
		</div></div>
	</div>
	`); 
}


/* BOTÃO DE CLICK COMPRA DE INGREDIENTES*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buyenviar",(function(){
	let quantity = $('#buyquantidade').val();
	let amount = $('#buyvalor').val();
	let item = $("#boxselect :selected").val(); 
	let option = "Buy";
	let type = "salesStore";

	$.post("http://vrp_tabletshops/foodsFunctions",JSON.stringify({
		amount,
		quantity,
		item,
		option,
		type,
		openRestaurant,
	}));
	$('#buyquantidade').val('');
	$('#buyvalor').val('');
}));

/* BOTÃO DE CLICK VENDA DE INGREDIENTES*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#sellenviar",(function(){
	let quantity = $('#sellquantidade').val();
	let amount = $('#sellvalor').val();
	let item = $("#boxselect2 :selected").val(); 
	let option = "Buy";
	let type = "buyStore";

	$.post("http://vrp_tabletshops/foodsFunctions",JSON.stringify({
		quantity,
		amount,
		item,
		option,
		type,
		openRestaurant,
	}));
	$('#sellquantidade').val('');
	$('#sellvalor').val('');
}));

/* BOTÃO DE CLICK REMOÇÃO COMPRA DE INGREDIENTES*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buyremover",(function(){
	let quantity = $('#buyquantidade').val();
	let amount = $('#buyvalor').val();
	let item = $("#boxselect :selected").val();
	let option = "Sell"; 
	let type = "salesStore"

	if (amount || quantity) {
		$.post("http://vrp_tabletshops/foodsFunctions",JSON.stringify({
			quantity,
			amount,
			item,
			option,
			type,
			openRestaurant,
		}));
	}
	$('#buyquantidade').val('');
	$('#buyvalor').val('');
}));

/* BOTÃO DE CLICK REMOÇÃO VENDA DE INGREDIENTES*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#sellremover",(function(){
	let quantity = $('#sellquantidade').val();
	let amount = $('#sellvalor').val();
	let item = $("#boxselect2 :selected").val();
	let option = "Sell";
	let type = "buyStore";

	if (amount || quantity) {
		$.post("http://vrp_tabletshops/foodsFunctions",JSON.stringify({
			quantity,
			amount,
			item,
			option,
			type,
			openRestaurant,
		}));
	}
	$('#sellquantidade').val('');
	$('#sellvalor').val('');
}));

/* BOTÃO DE CLICK SACAR VALOR*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".sacar",(function(){
	let amount = $('#valorcash').val();
	let type = "Withdraw"

	if (amount) {
		$.post("http://vrp_tabletshops/businessFunctions",JSON.stringify({
			type,
			amount,
			openRestaurant,
		}));
	}
}));

/* BOTÃO DE CLICK DEPOSITAR VALOR*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".depositar",(function(){
	let amount = $('#valorcash').val();
	let type = "Deposit"

	if (amount) {
		$.post("http://vrp_tabletshops/businessFunctions",JSON.stringify({
			type,
			amount,
			openRestaurant,
		}));
	}
}));

/* BOTÃO DE ADICIONAR MEMBRO*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#adicionaruser",(function(){
	let passaporte = $('#passaporte').val();
	let type = "Add"

	if (passaporte) {
		$.post("http://vrp_tabletshops/businessFunctions",JSON.stringify({
			type,
			passaporte,
			openRestaurant,
		}));
	}
	$('#passaporte').val('');
}));

/* BOTÃO DE REMOVER MEMBRO*/
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#removeruser",(function(){
	let passaporte = $('#passaporte').val();
	let type = "Rem"

	if (passaporte) {
		$.post("http://vrp_tabletshops/businessFunctions",JSON.stringify({
			type,
			passaporte,
			openRestaurant,
		}));
	}
	$('#passaporte').val('');
}));