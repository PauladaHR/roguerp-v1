var selectPage = "Prender";
var reversePage = "Prender";
var infos = "";
var arrest = "Não";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){

	menuSpawn();

	window.addEventListener("message",function(event){
		switch (event.data.action){
			case "openSystem":
				$("#mainPage").fadeIn(1000);
				menuSpawn();
			break;

			case "closeSystem":
				$("#mainPage").fadeOut(100);
			break;

			case 'functionAnnounce':
				functionAnnounce();
			break;

			case 'functionAdmin':
				functionAdmin();
			break;

			case 'functionFuncionario':
                functionFuncionario();
            break

			case 'infoPage':
				let passaporte = parseInt($('#inputUser').val());
				if(passaporte > 0){
				$.post("http://vrp_mdt/requestGetInfos",JSON.stringify({ passaporte }),function(data){
				$.post("http://vrp_mdt/getPermission",JSON.stringify({}),(data2) => {
				infoPage(data,data2);
			});
		});
	}
		};
	});

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_mdt/closeSystem");
		};
	};
});

/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click","#mainMenu li",function(){
	if (selectPage != reversePage){
		let isActive = $(this).hasClass('active');
		$('#mainMenu li').removeClass('active');
		if (!isActive){
			$(this).addClass('active');
			reversePage = selectPage;
		};
	};
});

/* ---------------------------------------------------------------------------------------------------------------- */
const findUser = () => { 
	$('#header').html(`
		<div id="pageUser">
			<input id="inputUser" class="inputUser" spellcheck="false" value="" placeholder="Passaporte."></input></div>
			<button class="buttonUser"><i class="fas fa-search"></i></button>
		</div>
	`);
}

/* BUTÃO PARA DAR FIND NO USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click",".buttonUser",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		$.post("http://vrp_mdt/requestGetInfos",JSON.stringify({ passaporte }),function(data){
		$.post("http://vrp_mdt/getPermission",JSON.stringify({}),(data2) => {
			infoPage(data,data2);
			});
		});
	}
}));

/* BOTÕES DO MENU */
/* ---------------------------------------------------------------------------------------------------------------- */

const menuSpawn = () => { 
	$.post("http://vrp_mdt/getPermission",JSON.stringify({ }),function(data){

    if(data["result"] == true){
			$('#mainPage').html(`
			<div id="header"></div>
			<div id="mainMenu">
				<li onclick="functionAnnounce();"class="active">ANÚNCIOS</li>
				<li onclick="functionPrender();">PRENDER</li>
				<li onclick="functionMultar();">MULTAR</li>
				<li onclick="functionOcorrency();">OCORRÊNCIAS</li>
				<li onclick="functionAdmin();">ADMINISTRATIVO</li>
			</div>
			<div id='content'></div>
		`);
		findUser()
		functionAnnounce()
        } else {
            $('#mainPage').html(`
			<div id="header"></div>
			<div id="mainMenu">
				<li onclick="functionAnnounce();"class="active">ANÚNCIOS</li>
				<li onclick="functionPrender();">PRENDER</li>
				<li onclick="functionMultar();">MULTAR</li>
				<li onclick="functionOcorrency();">OCORRÊNCIAS</li>
			</div>
			<div id='content'></div>
		`);
		findUser()
		functionAnnounce()
		}
    });
}


const functionAnnounce = () => {
    selectPage = "functionAnnounce";

        $('#content').html(`
                    <div id="titleContent-announcePage">ANÚNCIOS</div>
                    <div class="fasIconLoading-announce"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

            <div id='socialRight-announce'></div>
            </div>
        `);

            $("#socialRight-announce").html("")
            $("#socialRight-announce").html("<div id='socialContent-announce'></div>")
            $.post("http://vrp_mdt/requestAnnounce",JSON.stringify({}),(data) => {
            $.post("http://vrp_mdt/getPermission",JSON.stringify({}),(data2) => {
                document.getElementsByClassName('fasIconLoading-announce')[0].style.visibility = 'hidden';
                let i = 0;
                const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
                $('#socialContent-announce').html(`
                    ${nameList.map((item) => (`
                        <div id="announce-Delete" class="logsBox-announce" data-id-key="${item["table"]}">

                            <titles>${item["medic"]}
                            
                            </titles> <div id="timers" >${item["date"]}</div>
                            
                            ${data2["result"] == true ? "<i class=\"material-icons lixeira\">delete_forever</i>":""}
                            
                            <i class=\"material-icons verified\">verified</i><br>
                            
                            ${item["text"]} 
                        </div>
                `)).join('')}
            `);
        });
    });
}

/* CLICK DEL ANUNCIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".material-icons.lixeira",debounce(function(){
    let $el = $('.logsBox-announce');
    $.post("http://vrp_mdt/delAnnounce",JSON.stringify({
        table_id: $el.attr('data-id-key')
    }));
}));

const functionAdmin = () => {
    selectPage = "functionAdmin"

        $.post("http://vrp_mdt/getPermission",JSON.stringify({ }),function(data){

        if(data["result"] == true){
			anunciarPage()
        } else {
            $('#content').html(`
                <div id="pageOrganizer"></div>
                <div id="titleContent">Você não tem permissão para isso.</div>
            `);
        }
    });
}

$(document).on("click","#functionAdminAnunciar",debounce(function(){
    anunciarPage();
}));

$(document).on("click","#functionAdminFuncionario",debounce(function(){
    functionFuncionario();
}));

const functionFuncionario = () => {
    selectPage = "functionFuncionario";

	$('#content').html(`
			<div id='socialLeft'>
			<div id="content-sub-menu-rotation">
				<li id="functionAdminAnunciar">ANUNCIAR</li>
				<li id="functionAdminFuncionario"class="active">CONTROLE DE FUNCIONÁRIOS</li>
			</div></div>
				<div id="titleContent-logPrison">CONTROLE DE FUNCIONÁRIOS </div>
				<div class="fasIconLoading-announce"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>
                <i id="clear-button" class=\"material-icons clear\">clear</i>

		<div id='socialRight-Funcionary'></div>
		</div>
	`);

		$.post("http://vrp_mdt/meDaOsTrabalhadores",JSON.stringify({}),(data) => {

            $("#socialRight-Funcionary").html("")
            $("#socialRight-Funcionary").html("<div id='pageFuncionary2'></div>")
                document.getElementsByClassName('fasIconLoading-announce')[0].style.visibility = 'hidden';
                let i = 0;
                const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
                $('#pageFuncionary2').html(`
                ${nameList.map((item) => (`
                    <div class="myFuncionary" data-user-id="${item.user_id}">
                        <b>Nome:</b> ${item["name"]} <b>#${item.user_id}</b><br>
                    </div>
			`)).join('')}
		`);
	});
}

$(document).on("click",".myFuncionary",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('.myFuncionary').removeClass('active');
    if(!isActive) $el.addClass('active');
});

$(document).on("click","#clear-button",debounce(function(){
    let $el = $('.myFuncionary.active');
    $.post("http://vrp_mdt/desligarUser",JSON.stringify({
        user_id: $el.attr('data-user-id')
    }));
}));

/* MARCAR EXAMES */
/* ---------------------------------------------------------------------------------------------------------------- */

const anunciarPage = () => {
	selectPage = "anunciarPage";

	$('#content').html(`
			<div id='socialLeft'>
			<div id="content-sub-menu-rotation">
				<li id="functionAdminAnunciar"class="active">ANUNCIAR</li>
				<li id="functionAdminFuncionario">CONTROLE DE FUNCIONÁRIOS</li>
			</div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">ANUNCIAR</div>
			<div id="pageLeft">

			<textarea id="textoAnuncio" class="textareaSimple-announce" spellcheck="false" value="" placeholder="Insira o texto do anúncio aqui..."></textarea>
			<button id="buttonEnviarAnuncio" class="buttonSimple-ocorrency">Enviar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
}

/* BOTÃO ENVIAR ANUNCIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonEnviarAnuncio",debounce(function(){
	let texto = $('#textoAnuncio').val();
		$.post("http://vrp_mdt/anuncioAdm",JSON.stringify({ texto }));
		$('#textoAnuncio').val('');
}));

/* INFORMAÇÕES SOBRE O USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const infoPage = (data,data2) => {
	selectPage = "infoPage";

	$("#content").html("<div id='mainPage'></div>" + "<div id='header'>" + "<div id='mainMenu'>")
	$('#content').prepend(`
		<div id="content-sub-menu">
			<li id="sobreclick" class="active">SOBRE</li>
			<li id="prisonclick">PRISÕES</li>
			<li id="finesclick">MULTAS</li>
			<li id="propriedadesClick">VEÍCULOS</li>
			<li id="clickHomes">PROPRIEDADES</li>
		</div></div>

		<div id="titleContent-subMenu">${data.nome} ${data.sobrenome}</div>
        <div id="pageLeft-subMenu">
            <div id="userInfoBox"><b>Passaporte:</b> ${data.passaporte}<br><b>Nome:</b> ${data.nome} ${data.sobrenome}<br><b>Registro Geral:</b> ${data.identity}<br><b>Telefone:</b> ${data.phone}<br><b>Gênero:</b> ${data.genero}<br><b>Multas:</b> $${formatarNumero(data.fines)}
			<br><br><b>Porte: </b>${data.weaponporte} <button class="buttonPorte">Atualizar</button>
			</div>
			${data2["result"] == true ? "<i class=\"material-icons contract\">post_add</i>":""} 
        </div>

        <div id="pageRight-sub-menu">OBSERVAÇÕES:</div>
        <div id="pageRightText-sub-menu">
        <b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
	`);

	$(document).on("click",".buttonPorte",debounce(function(){
		let passaporte = data.passaporte
		if(passaporte > 0){
			$.post("http://vrp_mdt/weaponPortUser",JSON.stringify({ passaporte }));
		}
	}));
};


/* BENS MATERIAIS */
/* ---------------------------------------------------------------------------------------------------------------- */

const propriedadesClick = (passaporte) => {
	selectPage = "propriedadesClick";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreclick">SOBRE</li>
                <li id="prisonclick">PRISÕES</li>
                <li id="finesclick">MULTAS</li>
				<li id="propriedadesClick" class="active">VEÍCULOS</li>
				<li id="clickHomes">PROPRIEDADES</li>
            </div></div>
			<div id="titleContent-logPrison">VEÍCULOS</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	clickPropriedades(passaporte)
}

const clickPropriedades = (passaporte) => {
		$("#socialRight").html("")
		$("#socialRight").html("<div id='socialContent'></div>")
		$.post("http://vrp_mdt/requestVehs",JSON.stringify({ passaporte }),(data) => {
		$.each(JSON.parse(data),(k,v) => {
			$('#socialContent').prepend(`
			<div id="logsBox">
			<b>Veículo:</b> ${v.vehicle}<br> 
			<b>Placa:</b> ${v.plate}<br>
			<b>Veículo apreendido:</b> ${v.arrest}
			`);
		})
	});
}

/* BENS MATERIAIS */
/* ---------------------------------------------------------------------------------------------------------------- */

const homesClick = (passaporte) => {
	selectPage = "homesClick";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreclick">SOBRE</li>
                <li id="prisonclick">PRISÕES</li>
                <li id="finesclick">MULTAS</li>
				<li id="propriedadesClick">VEÍCULOS</li>
				<li id="clickHomes" class="active">PROPRIEDADES</li>
            </div></div>
			<div id="titleContent-logPrison">PROPRIEDADES</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	clickHomes(passaporte)
}

const clickHomes = (passaporte) => {
		$("#socialRight").html("")
		$("#socialRight").html("<div id='socialContent'></div>")
		$.post("http://vrp_mdt/requestHomes",JSON.stringify({ passaporte }),(data) => {
		$.each(JSON.parse(data),(k,v) => {
			$('#socialContent').prepend(`
			<div id="logsBox">
			<b>Casas:</b> ${v.homes}<br> 
			`);
		})
	});
}


/* REGISTRO CRIMINAL */
/* ---------------------------------------------------------------------------------------------------------------- */

const arrestPage = (passaporte) => {
	selectPage = "arrestPage";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreclick">SOBRE</li>
                <li id="prisonclick" class="active">PRISÕES</li>
                <li id="finesclick">MULTAS</li>
				<li id="propriedadesClick">VEÍCULOS</li>
				<li id="clickHomes">PROPRIEDADES</li>
            </div></div>
			<div id="titleContent-logPrison">REGISTRO CRIMINAL</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	requestArrest(passaporte)
}

const requestArrest = (passaporte) => {
		$("#socialRight").html("")
		$("#socialRight").html("<div id='socialContent'></div>")
		$.post("http://vrp_mdt/requestArrest",JSON.stringify({ passaporte }),(data) => {
		$.each(JSON.parse(data),(k,v) => {
			$('#socialContent').prepend(`
			<div id="logsBox">
			<b>Oficial:</b> ${v.officer}<br>
			<b>Prisão efetuada em:</b> ${v.date}<br>
			<b>Tempo de prisão:</b> ${formatarNumero(v.prison)}<br>
			<b>Valor total em multas:</b> $${formatarNumero(v.fine)}<br>
			<b>Crimes:</b> ${v.text}	
			`);
		})
	});
}

/* REGISTRO MULTAS */
/* ---------------------------------------------------------------------------------------------------------------- */

const finesPage = (passaporte) => {
	selectPage = "finesPage";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreclick">SOBRE</li>
                <li id="prisonclick">PRISÕES</li>
                <li id="finesclick" class="active">MULTAS</li>
				<li id="propriedadesClick">VEÍCULOS</li>
				<li id="clickHomes">PROPRIEDADES</li>
            </div></div>
			<div id="titleContent-logPrison">REGISTRO DE MULTAS</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	requestFines(passaporte)
}

const requestFines = (passaporte) => {
		$("#socialRight").html("")
		$("#socialRight").html("<div id='socialContent'></div>")
		$.post("http://vrp_mdt/requestFines",JSON.stringify({ passaporte }),(data) => {
		$.each(JSON.parse(data),(k,v) => {
			$('#socialContent').prepend(`
			<div id="logsBox">
			<b>Oficial:</b> ${v.officer}<br>
			<b>Multa efetuada em:</b> ${v.date}<br>
			<b>Valor total em multas:</b> $${formatarNumero(v.fine)}<br>
			<b>Infrações:</b> ${v.text}	
			`);
		})
	});
}

/* REGISTRO OCORRENCIAS */
/* ---------------------------------------------------------------------------------------------------------------- */

const functionOcorrency = () => {
	selectPage = "functionOcorrency";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreocorrencyclick" class="active">REGISTROS</li>
                <li id="historicoclick">OCORRêNCIAS</li>
            </div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">REGISTRO DE OCORRÊNCIAS</div>
			<div id="pageLeft">
			<div id="inputs">
				<input id="passaporteOcorrency" class="inputSimple-ocorrency" spellcheck="false" value="" placeholder="Passaporte."></input>
			</div>
			<textarea id="textoOcorrency" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações sobre a ocorrência."></textarea>
			<button class="buttonSimple-ocorrency">Enviar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
}

const ocorrencyFunction = (passaporte) => {
	selectPage = "ocorrencyFunction";

    	$('#content').html(`
			<div id='socialLeft'>
				<div id="content-sub-menu-rotation">
					<li id="sobreocorrencyclick">REGISTROS</li>,
					<li id="historicoclick" class="active">OCORRêNCIAS</li>
				</div></div>
					<div id="titleContent-logPrison">REGISTRO DE OCORRÊNCIAS</div>
					<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>

					<div id="pageRightText-sub-menu-logprison">
					<b>1:</b> Todas as informações encontradas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
					</div></div>
			<div id='socialRight'></div>
		`);

			$("#socialRight").html("")
			$("#socialRight").html("<div id='socialContent'></div>")
			$.post("http://vrp_mdt/requestOccurrence",JSON.stringify({}),(data) => {
			$.each(JSON.parse(data),(k,v) => {
			$('#socialContent').prepend(`
			<div id="logsBox">
			<b>Oficial:</b> ${v.officer}<br>
			<b>Nome:</b> ${v.user_id}<br>
			<b>Ocorrência efetuada em:</b> ${v.date}<br>
			<b>Informações sobre a ocorrência:</b> ${v.text}	
		`);
	})
});

$(document).on("click",".buttonSimple-ocorrency",debounce(function(){
	let passaporte = parseInt($('#passaporteOcorrency').val());
	let texto = $('#textoOcorrency').val();
	if(passaporte > 0){
		$.post("http://vrp_mdt/occurrenceUser",JSON.stringify({ passaporte,texto }));
		$('#passaporteOcorrency').val('');
		$('#textoOcorrency').val('');
		}
	}));
}
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click","#sobreclick",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		$.post("http://vrp_mdt/requestGetInfos",JSON.stringify({ passaporte }),function(data){
			infoPage(data);
		});
	}
}));
$(document).on("click","#prisonclick",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		arrestPage(passaporte);
	}
}));
$(document).on("click","#propriedadesClick",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		propriedadesClick(passaporte);
	}
}));
$(document).on("click","#clickHomes",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		homesClick(passaporte);
	}
}));
$(document).on("click","#finesclick",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		finesPage(passaporte);
	}
}));

$(document).on("click","#historicoclick",debounce(function(){
	ocorrencyFunction();
}));

$(document).on("click","#sobreocorrencyclick",debounce(function(){
	functionOcorrency();
}));
/* ---------------------------------------------------------------------------------------------------------------- */
const functionPrender = () => {
	selectPage = "Prender";

	$('#content').html(`
		<div id="pageOrganizer"></div>
		<div id="titleContent">PRENDER</div>
		<div id="pageLeft">
			<div id="inputs">
				<input id="passaporte" class="inputSimple" spellcheck="false" value="" placeholder="Passaporte."></input>
				<input id="servicos" class="inputSimple" spellcheck="false" value="" placeholder="Serviços."></input>
				<input id="valormulta" class="inputSimple" spellcheck="false" value="" placeholder="Valor da Multa."></input>
			</div>
			<textarea id="textoprisao" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações dos crimes."></textarea>
			<button class="buttonSimple">Prender</button>
			<button class="buttonSimpleRemove"><i class="fas fa-trash-alt"></i></button>
		</div>

		<div id="pageRight">OBSERVAÇÕES:</div>
		<div id="pageRightText">
		<b>1:</b> Antes de enviar o formulário verifique corretamente se todas as informações estão de acordo com o crime efetuado, você é responsável por todas as informações enviadas e salvas no sistema.
		<br><br><b>2:</b> Ao preencher o campo de multas, verifique se o valor está correto, após enviar o formulário não será possível alterar ou remover a multa enviada.
		<br><br><b>3:</b> Todas as prisões são salvas no sistema após o envio, então lembre-se que cada formulário enviado, o valor das multas, servições e afins são somados com a ultima prisão caso o mesmo ainda esteja preso.
		<br><br><b>4:</b> Tenha cuidado ao utilizar a função de remoção de prisão, você é responsável por todas as informações enviadas e salvas no sistema.</div>
	`);

	$(document).on("click",".buttonSimple",debounce(function(){
		let passaporte = parseInt($('#passaporte').val());
		let servicos = parseInt($('#servicos').val());
		let valormulta = parseInt($('#valormulta').val());
		let texto = $('#textoprisao').val();
		if(passaporte,servicos,valormulta > 0){
			$.post("http://vrp_mdt/prisonUser",JSON.stringify({ passaporte,servicos,valormulta,texto }));
			$('#passaporte').val('');
			$('#servicos').val('');
			$('#valormulta').val('');
			$('#textoprisao').val('');
		}
	}));
};

$(document).on("click",".buttonSimpleRemove",debounce(function(){
	let passaporte = parseInt($('#passaporte').val());
	let servicos = parseInt($('#servicos').val());
	if(passaporte,servicos > 0){
		$.post("http://vrp_mdt/delPrison",JSON.stringify({ passaporte,servicos }));
		$('#passaporte').val('');
		$('#servicos').val('');
	}
}));
/* ---------------------------------------------------------------------------------------------------------------- */
const functionMultar = () => {
	selectPage = "Multar";

	$('#content').html(`
		<div id="pageOrganizer"></div>
		<div id="titleContent">MULTAR</div>
		<div id="pageLeft">
			<div id="inputs">
				<input id="passaporte" class="inputSimpleMultar" spellcheck="false" value="" placeholder="Passaporte."></input>
				<input id="valormulta" class="inputSimpleMultar" spellcheck="false" value="" placeholder="Valor da Multa."></input>
			</div>
			<textarea id="textomulta" class="textareaSimpleMultar" spellcheck="false" value="" placeholder="Todas as informações da multa."></textarea>
			<button class="buttonSimpleMultar">Multar</button>
		</div>

		<div id="pageRight">OBSERVAÇÕES:</div>
		<div id="pageRightText">
		<b>1:</b> Antes de enviar o formulário verifique corretamente se todas as informações estão de acordo com a multa, você é responsável por todas as informações enviadas e salvas no sistema.<br><br><b>2:</b> Ao preencher o campo de multas, verifique se o valor está correto, após enviar o formulário não será possível alterar ou remover a multa enviada.</div>
	`);

	$(document).on("click",".buttonSimpleMultar",debounce(function(){
		let deposito = parseInt($('#passaporte').val());
		let chave = parseInt($('#valormulta').val());
		let texto = $('#textomulta').val();
		if(deposito,chave > 0){
			$.post("http://vrp_mdt/fineUser",JSON.stringify({ deposito,chave,texto }));
			$('#passaporte').val('');
			$('#valormulta').val('');
			$('#textomulta').val('');
		}
	}));
};

$(document).on("click",".material-icons.contract",debounce(function(){
	let passaporte = parseInt($('#inputUser').val())
	if(passaporte > 0){
		$.post("http://vrp_mdt/ContractPolice",JSON.stringify({ passaporte }));
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
		timeout = setTimeout(later,250)
		if (callNow) func.apply(context,args)
	}
}

/* ----------FORMATAR NÚMERO---------- */
const formatarNumero = (n) => {
	var n = n.toString();
	var r = '';
	var x = 0;

	for (var i = n.length; i > 0; i--) {
		r += n.substr(i - 1, 1) + (x == 2 && i != 1 ? '.' : '');
		x = x == 2 ? 0 : x + 1;
	}

	return r.split('').reverse().join('');
}