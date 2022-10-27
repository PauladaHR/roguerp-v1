var selectPage = "functionAnnounce";
var reversePage = "functionAnnounce";
var infos = "";
var arrest = "Não";
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).ready(function(){

	menuSpawn();

	window.addEventListener("message",function(event){
        switch (event.data.action){
            case "openSystem":
				menuSpawn();
                $("#mainPage").fadeIn(1000);
            break;

            case "closeSystem":
                $("#mainPage").fadeOut(100);
            break;

            case 'examesPendentes':
                examesPendentes();
            break;
            
            case 'prontuarioPage':
                prontuarioPage();
            break;

            case 'functionConsultas':
                functionConsultas();
            break;
            
            case 'resultExames':
                resultExames();
            break;

            case 'ocorrencyFunction':
                ocorrencyFunction();
            break; 

            case 'functionMedic':
                functionMedic();
            break;

            case 'minhasConsultas':
                minhasConsultas();
            break;

            case 'myExames':
                myExames();
            break;

			case 'functionAdmin':
				functionAdmin();
			break;

			case 'functionAnnounce':
				functionAnnounce();
			break;

			case 'infoPage':
				let passaporte = parseInt($('#inputUser').val());
				if(passaporte > 0){
				$.post("http://vrp_mdthospital/requestGetInfos",JSON.stringify({ passaporte }),function(data){
				$.post("http://vrp_mdthospital/getPermission",JSON.stringify({}),(data2) => {
				infoPage(data,data2);
			});
		});
	}
			break;
	};
});
	

	document.onkeyup = function(data){
		if (data.which == 27){
			$.post("http://vrp_mdthospital/closeSystem");
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


/* BOTÕES DO MENU */
/* ---------------------------------------------------------------------------------------------------------------- */

const menuSpawn = () => { 
	$.post("http://vrp_mdthospital/getPermission",JSON.stringify({ }),function(data){

    if(data["result"] == true){
			$('#mainPage').html(`
			<div id="header"></div>
			<div id="mainMenu">
				<li onclick="functionAnnounce();"class="active">ANÚNCIOS</li>
				<li onclick="functionProntuario();">ATENDIMENTO</li>
				<li onclick="functionConsultas();">CONSULTAS</li>
				<li onclick="marcarExames();">EXAMES</li>
				<li onclick="minhasConsultas();">MEDICOS</li>
				<li onclick="functionRanking();">RANKING</li>
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
				<li onclick="functionProntuario();">ATENDIMENTO</li>
				<li onclick="functionConsultas();">CONSULTAS</li>
				<li onclick="marcarExames();">EXAMES</li>
				<li onclick="minhasConsultas();">MEDICOS</li>
				<li onclick="functionRanking();">RANKING</li>
			</div>
			<div id='content'></div>
		`);
		findUser()
		functionAnnounce()
		}
    });
}


/* JS BOTÃO PARA DAR FIND NO USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const findUser = () => { 
	$('#header').html(`
		<div id="pageUser">
			<input id="inputUser" class="inputUser" spellcheck="false" value="" placeholder="Passaporte."></input></div>
			<button class="buttonUser"><i class="fas fa-search"></i></button>
		</div>
	`);
}

/* BOTÃO PARA DAR FIND NO USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
$(document).on("click",".buttonUser",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
		if(passaporte > 0){
			$.post("http://vrp_mdthospital/requestGetInfos",JSON.stringify({ passaporte }),function(data){
			$.post("http://vrp_mdthospital/getPermission",JSON.stringify({}),(data2) => {
			infoPage(data,data2);
			});
		});
	}
}));

/* INFORMAÇÕES SOBRE O USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const infoPage = (data,data2) => {
    selectPage = "infoPage";

        $("#content").html("<div id='mainPage'></div>" + "<div id='header'>" + "<div id='mainMenu'>")
        $('#content').prepend(`
            <div id="content-sub-menu">
                <li id="sobreclick" class="active">SOBRE</li>
                <li id="sobreProntuarios">PRONTUÁRIOS</li>
                <li id="usuarioConsultas">CONSULTAS</li>
                <li id="usuarioExames">EXAMES</li>
            </div></div>

            <div id="titleContent-subMenu">${data["nome"]} ${data["sobrenome"]}</div>
            <div id="pageLeft-subMenu">
                <div id="userInfoBox"><b>Passaporte:</b> ${formatarNumero(data["passaporte"])}<br>
                    <b>Nome:</b> ${data["nome"]} ${data["sobrenome"]}<br>
                    <b>Serial:</b> ${data["identity"]}<br>
                    <b>Telefone:</b> ${data["phone"]}<br>
                    <b>Gênero:</b> ${data["genero"]}<br>
                    <b>Alergias:</b> ${data["allergy"]}<br>
                    <b>Doenças pré-existentes:</b> ${data["sickness"]}<br>
                    <b>Historico de doação de sangue:</b> ${data["bloodquantity"]} <b>Ultima doação:</b>${data["blooddate"]}
                <button class="buttonSangue">Atualizar</button></div>

                <input class="inputSimple-Doenças" maxlength='70' spellcheck="false" value="" placeholder="O paciente possui alguma alergia?"></input>
                <div class="medicamentosButton-Doenças"><i class="fas fa-check fa-xl"></i>
            </div>
                <input class="inputSimple-DoençasPréExistentes" maxlength='70' spellcheck="false" value="" placeholder="Doenças pré-existentes do paciente..."></input>
                <div class="medicamentosButton-DoençasPréExistentes"><i class="fas fa-check fa-xl"></i>
            </div>
			${data2["result"] == true ? "<i class=\"material-icons contract\">post_add</i>":""} 
        </div>

        <div id="pageRight-sub-menu-sobre">OBSERVAÇÕES:</div>
        <div id="pageRightText-sub-menu">
        <b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br>
        <b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.<br><br>
        <b>3:</b> Preencha as informações de forma correta e coerente com as informações repassadas pelo paciente.
    `);
	$(".inputSimple-Doenças").click(function(event) {
		$('.inputSimple-Doenças').val(data["allergy"]);
	});
	$(".inputSimple-DoençasPréExistentes").click(function(event) {
		$('.inputSimple-DoençasPréExistentes').val(data["sickness"]);
	});
};


	
	/* BOTÃO DOADOR DE SANGUE */
	/* ---------------------------------------------------------------------------------------------------------------- */

	$(document).on("click",".buttonSangue",debounce(function(){
		let passaporte = parseInt($('#inputUser').val())
		if(passaporte > 0){
			$.post("http://vrp_mdthospital/bloodUser",JSON.stringify({ passaporte }));
		}
	}));

	/* BOTÃO CONTRATAR USUÁRIO */
	/* ---------------------------------------------------------------------------------------------------------------- */

	$(document).on("click",".material-icons.contract",debounce(function(){
		let passaporte = parseInt($('#inputUser').val())
		if(passaporte > 0){
			$.post("http://vrp_mdthospital/ContractMedic",JSON.stringify({ passaporte }));
		}
	}));
	
	/* BOTÃO ALERGIAS */
	/* ---------------------------------------------------------------------------------------------------------------- */

	$(document).on("click",".medicamentosButton-Doenças",debounce(function(){
		let passaporte = parseInt($('#inputUser').val())
		let text = $('.inputSimple-Doenças').val()
			$.post("http://vrp_mdthospital/allergyUser",JSON.stringify({ passaporte,text }));
			$('.inputSimple-Doenças').val('');
	}));

	/* BOTÃO DOENÇAS PRÉ-EXISTENTES */
	/* ---------------------------------------------------------------------------------------------------------------- */

	$(document).on("click",".medicamentosButton-DoençasPréExistentes",debounce(function(){
		let passaporte = parseInt($('#inputUser').val())
		let text = $('.inputSimple-DoençasPréExistentes').val()
			$.post("http://vrp_mdthospital/sicknessUser",JSON.stringify({ passaporte,text }));
			$('.inputSimple-DoençasPréExistentes').val('');
	}));


/* INFORMAÇÕES SOBRE O USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const prontuarioPage = (passaporte) => {
	selectPage = "prontuarioPage";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
				<li id="sobreclick">SOBRE</li>
				<li id="sobreProntuarios" class="active">PRONTUÁRIOS</li>
				<li id="usuarioConsultas">CONSULTAS</li>
				<li id="usuarioExames">EXAMES</li>
            </div></div>
			<div id="titleContent-logPrison">PRONTUÁRIOS</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	pageProntuario(passaporte)
}

const pageProntuario = (passaporte) => {
	$("#socialRight").html("")
	$("#socialRight").html("<div id='socialContent'></div>")
	$.post("http://vrp_mdthospital/requestProntuarios",JSON.stringify({ passaporte }),(data) => {
		document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
	$.each(JSON.parse(data),(k,v) => {
		$('#socialContent').prepend(`
			<div class ="logsBox" ${v.color}'":""}>
				<b>Socorrista:</b> ${v.socorrist}<br>
				<b>Informações sobre a triagem:</b> ${v.text}<br>
				<b>Paramédico:</b> ${v.medic}<br>
				<b>Informações sobre o atendimento:</b> ${v.text2}<br>
				<b>Atendimento efetuado em:</b> ${v.date}
			`);
		})
	});
};

/* CONSULTAS DO USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const consultUser = (passaporte) => {
	selectPage = "consultUser";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
				<li id="sobreclick">SOBRE</li>
				<li id="sobreProntuarios">PRONTUÁRIOS</li>
				<li id="usuarioConsultas" class="active">CONSULTAS</li>
				<li id="usuarioExames">EXAMES</li>
            </div></div>
			<div id="titleContent-logPrison">CONSULTAS</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	userConsult(passaporte)
}

const userConsult = (passaporte) => {
	$("#socialRight").html("")
	$("#socialRight").html("<div id='socialContent'></div>")
	$.post("http://vrp_mdthospital/requestMyConsults",JSON.stringify({ passaporte }),(data) => {
		document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
	$.each(JSON.parse(data),(k,v) => {
		$('#socialContent').prepend(`
				<div class ="logsBox"}>
				<b>Especialidade:</b> ${v.specialty}<br>
				<b>Consulta solicitada em:</b> ${v.date}<br>
				<b>Informações sobre a solicitação:</b> ${v.text}<br>
				<b>Consulta realizada em:</b> ${v.date2}<br>
				<b>Informações sobre a consulta:</b> ${v.text2}<br>
				<b>Paramédico:</b> ${v.medic}
			`);
		})
	});
};

/* EXAMES DO USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */
const examesUser = (passaporte) => {
	selectPage = "consultUser";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
				<li id="sobreclick">SOBRE</li>
				<li id="sobreProntuarios">PRONTUÁRIOS</li>
				<li id="usuarioConsultas">CONSULTAS</li>
				<li id="usuarioExames" class="active">EXAMES</li>
            </div></div>
			<div id="titleContent-logPrison">EXAMES</div>
			<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
	userExames(passaporte)
}

const userExames = (passaporte) => {
	$("#socialRight").html("")
	$("#socialRight").html("<div id='socialContent'></div>")
	$.post("http://vrp_mdthospital/requestMyExames",JSON.stringify({ passaporte }),(data) => {
	document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
	$.each(JSON.parse(data),(k,v) => {
		$('#socialContent').prepend(`
				<div class ="logsBox"}>
				<b>Exame:</b> ${v.specialty}<br>
				<b>Exame solicitado em:</b> ${v.date}<br>
				<b>Informações sobre a solicitação:</b> ${v.text}<br>
				<b>Exame realizado em:</b> ${v.date2}<br>
				<b>Resultado do exame:</b> ${v.text2}<br>
				<b>Paramédico:</b> ${v.medic}
			`);
		})
	});
};

/* MARCAR EXAMES */
/* ---------------------------------------------------------------------------------------------------------------- */

const marcarExames = () => {
	selectPage = "marcarExames";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="marcarexames" class="active">MARCAR EXAMES</li>
                <li id="examespendentes">EXAMES PENDENTES</li>
            </div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">MARCAR EXAME</div>
			<div id="pageLeft">
			<div id="inputs">
				<input id="passaporteInformationExames" class="bottonRegisterEvent" spellcheck="false" value="" placeholder="Passaporte."></input>
				
			<select id="boxselect" class="inputCheck" name="select">
  				<option id="valor1" value="1"selected>Ultrassonografia</option>
				<option id="valor2" value="2">Raio X</option>
  				<option id="valor3" value="3">Beta HCG</option>
  				<option id="valor4" value="4">Hemograma Completo</option>
				<option id="valor5" value="5">Tomografia</option>
				<option id="valor6" value="6">Ressonância</option>
			</select>

			</div>
			<textarea id="textoConsultasExames" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações sobre o exame do paciente."></textarea>
			<button id="buttonMarcarExames" class="buttonSimple-ocorrency">Marcar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
}
		

/* EXAMES PENDENTES */
/* ---------------------------------------------------------------------------------------------------------------- */

const examesPendentes = (passaporte) => {
	selectPage = "examesPendentes";

    	$('#content').html(`
			<div id='socialLeft'>
				<div id="content-sub-menu-rotation">
					<li id="marcarexames">MARCAR EXAMES</li>,
					<li id="examespendentes" class="active">EXAMES PENDENTES</li>
				</div></div>
					<div id="titleContent-logPrison">EXAMES PENDENTES</div>
					<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
					<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

					<div id="pageRightText-sub-menu-logprison">
					<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
					</div></div>
			<div id='socialRight'></div>
				<div class="checkPhone"><i class="fas fa-mobile-alt fa-xl"></i></div>
				<div class="checkMessage"><i class="fas fa-comment-alt fa-xl"></i></div>
				<div class="checkConsult"><i class="fas fa-check fa-xl"></i></div>
				<div class="removeConsult"><i class="fas fa-times fa-xl"></i></div>
			</div>
		`);

			$("#socialRight").html("")
			$("#socialRight").html("<div id='socialContent'></div>")
			$.post("http://vrp_mdthospital/requestExames",JSON.stringify({}),(data) => {
				document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
				let i = 0;
				const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
				$('#socialContent').html(`
					${nameList.map((item) => (`
						<div class="caixaConsultasPendentes" data-id-key="${item.table}" data-user-id="${item.user_id}" data-user-phone="${item.number}" data-info-type="Exames">
							<b>Paramédico:</b> ${item.medic}<br>
							<b>Exame solicitado:</b> ${item.specialty}<br>
							<b>Nome do paciente:</b> ${item.user_id}
							<b>Passaporte:</b> ${item.user_passaporte}<br>
							<b>Exame solicitado em:</b> ${item.date}<br>
							<b>Informações sobre o exame:</b> ${item.text}	
						</div>
			`)).join('')}
		`);
	});
}

/* MARCAR CONSULTAS */
/* ---------------------------------------------------------------------------------------------------------------- */

const functionConsultas = () => {
	selectPage = "functionConsultas";

	$('#content').html(`
		<div id='socialLeft'>
            <div id="content-sub-menu-rotation">
                <li id="sobreocorrencyclick" class="active">MARCAR CONSULTAS</li>
                <li id="historicoclick">CONSULTAS PENDENTES</li>
            </div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">MARCAR CONSULTAS</div>
			<div id="pageLeft">
			<div id="inputs">
				<input id="passaporteInformationConsultas" class="bottonRegisterEvent" spellcheck="false" value="" placeholder="Passaporte."></input>
				
			<select id="boxselect" class="inputCheck" name="select">
  				<option id="valor1" value="1"selected>Clínico Geral</option>
				<option id="valor1" value="2">Pediatria</option>
  				<option id="valor2" value="3">Cardiologista</option>
  				<option id="valor3" value="4">Ginecologista</option>
				<option id="valor4" value="5">Endocrinologista</option>
				<option id="valor5" value="6">Nefrologia</option>
			</select>
			
			</div>
			<textarea id="textoConsultas" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações sobre a consulta do paciente."></textarea>
			<button class="buttonSimple-ocorrency">Marcar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
}

$(document).on("click",".buttonSimple-ocorrency",debounce(function(){
	let passaporte = parseInt($('#passaporteInformationConsultas').val());
	let texto = $('#textoConsultas').val();
	let bottonselected = $("#boxselect :selected").val();
	if(passaporte,bottonselected > 0){
		$.post("http://vrp_mdthospital/consultaUser",JSON.stringify({ passaporte,bottonselected,texto }));
		$('#passaporteInformationConsultas').val('');
		$('#textoConsultas').val('');
		}
}));

/* CONSULTAS PENDENTES */
/* ---------------------------------------------------------------------------------------------------------------- */

const resultExames = () => {
	selectPage = "resultExames";

    	$('#content').html(`
			<div id="content-sub-menu-rotation">
				<li id="myConsults">MINHAS CONSULTAS</li>
				<li id="myExames">MEUS EXAMES</li>
				<li id="examesResultGlobal" class="active">RESULTADO DOS EXAMES</li>
				<li id="consultaMarcar">MARCAR CONSULTAS</li>
				<li id="exameMarcar">MARCAR EXAMES</li>
			</div></div>
					<div id="titleContent-logPrison">RESULTADO DOS EXAMES</div>
					<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
					<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

					<div id="pageRightText-sub-menu-logprison">
					<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
					</div></div>
			<div id='socialRight'></div>
			</div>
		`);

			$("#socialRight").html("")
			$("#socialRight").html("<div id='socialContent'></div>")
			$.post("http://vrp_mdthospital/resultExames",JSON.stringify({}),(data) => {
				document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
				let i = 0;
				const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
				$('#socialContent').html(`
					${nameList.map((item) => (`
						<div class="logsBox">
							<b>Exame:</b> ${item.specialty}<br>
							<b>Descrição da solicitação:</b> ${item.text}<br>
							<b>Exame solicitado em:</b> ${item.date}<br>
							<b>Paramédico:</b> ${item.medic}<br>
							<b>Nome do paciente:</b> ${item.user_id}
							<b>Passaporte:</b> ${item.user_passaporte}<br>
							<b>Exame realizado em:</b> ${item.date2}<br>
							<b>Resultado do exame:</b> ${item.text2}	
						</div>
			`)).join('')}
		`);
	});
}

/* CONSULTAS PENDENTES */
/* ---------------------------------------------------------------------------------------------------------------- */

const ocorrencyFunction = (passaporte) => {
	selectPage = "ocorrencyFunction";

    	$('#content').html(`
			<div id='socialLeft'>
				<div id="content-sub-menu-rotation">
					<li id="sobreocorrencyclick">MARCAR CONSULTAS</li>,
					<li id="historicoclick" class="active">CONSULTAS PENDENTES</li>
				</div></div>
					<div id="titleContent-logPrison">CONSULTAS PENDENTES</div>
					<div id="pageRight-sub-menu-logprison">OBSERVAÇÕES:</div>
					<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

					<div id="pageRightText-sub-menu-logprison">
					<b>1:</b> Todas as informações encontradas são de uso exclusivo hospitalar, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
					</div></div>
			<div id='socialRight'></div>
				<div class="checkPhone"><i class="fas fa-mobile-alt fa-xl"></i></div>
				<div class="checkMessage"><i class="fas fa-comment-alt fa-xl"></i></div>
				<div class="checkConsult"><i class="fas fa-check fa-xl"></i></div>
				<div class="removeConsult"><i class="fas fa-times fa-xl"></i></div>
			</div>
		`);

        $("#socialRight").html("")
        $("#socialRight").html("<div id='socialContent'></div>")
        $.post("http://vrp_mdthospital/requestConsultas",JSON.stringify({}),(data) => {
			document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
			let i = 0;
			const nameList = data["resultado"].sort((a,b) => (a.id > b.id) ? 1: -1);
			$('#socialContent').html(`
				${nameList.map((item) => (`
					<div class="caixaConsultasPendentes" data-id-key="${item["table"]}" data-user-id="${item["user_id"]}" data-nuser_id="${item["nuser_id"]}" data-user-phone="${item["number"]}" data-info-type="Consulta">
						<b>Paramédico:</b> ${item["medic"]}<br>
						<b>Especialidade solicitada:</b> ${item["specialty"]}<br>
						<b>Nome do paciente:</b> ${item["user_id"]}
						<b>Passaporte:</b> ${item["user_passaporte"]}<br>
						<b>Informações sobre a solicitação:</b> ${item["text"]}    
					</div>
            `)).join('')}
        `);
	});
}
/* BOTÃO LIGAÇÃO DE TELEFONE (BOTÃO AZUL) */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".checkPhone",debounce(function(){
	let $el = $('.caixaConsultasPendentes.active');
	$.post("http://vrp_mdthospital/CallConsult",JSON.stringify({
		number: $el.attr('data-user-phone'),
		type: $el.attr('data-info-type')
	}));
}));

/* BOTÃO MENSAGEM (BOTÃO AMARELO) */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".checkMessage",debounce(function(){
	let $el = $('.caixaConsultasPendentes.active');
	$.post("http://vrp_mdthospital/SmsConsult",JSON.stringify({
		number: $el.attr('data-user-phone'),
		type: $el.attr('data-info-type')
	}));
}));

/* CONFIRMAÇÃO DA CONSULTA (BOTÃO VERDE) */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".checkConsult",debounce(function(){
	let $el = $('.caixaConsultasPendentes.active');
	$.post("http://vrp_mdthospital/updateConsult",JSON.stringify({
		id: $el.attr('data-id-key'),
		user_id: $el.attr('data-user-id'),
		type: $el.attr('data-info-type')
	}));
}));

/* REMOÇÃO DA CONSULTA PRÉ MARCADA (BOTÃO VERMELHO) */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".removeConsult",debounce(function(){
	let $el = $('.caixaConsultasPendentes.active');
	$.post("http://vrp_mdthospital/delConsult",JSON.stringify({
		id: $el.attr('data-id-key'),
		user_id: $el.attr('data-user-id'),
		type: $el.attr('data-info-type')
	}));
}));

/* MINHAS CONSULTAS */
/* ---------------------------------------------------------------------------------------------------------------- */

const minhasConsultas = () => {
	selectPage = "functionMedic"
	
$('#content').html(`
	<div id='socialLeft'>
		<div id="content-sub-menu-rotation">
			<li id="myConsults" class="active">MINHAS CONSULTAS</li>
			<li id="myExames">MEUS EXAMES</li>
			<li id="examesResultGlobal">RESULTADO DOS EXAMES</li>
			<li id="consultaMarcar">MARCAR CONSULTAS</li>
			<li id="exameMarcar">MARCAR EXAMES</li>
		</div></div>
			<div id="titleContent-logPrison">MINHAS CONSULTAS</div>
			<div id="pageRight-sub-menu-logprison"></div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
				<textarea id="myConsults-boxarea" class="inputSimple-myConsulsts" spellcheck="false" value="" placeholder="Informações sobre a consulta."></textarea>

				<select id="boxselect" class="inputCheck-MyConsults" name="select">
					<option id="" value="0" selected>É necessário retorno?</option>
					<option id="valor1" value="1">Sim</option>
					<option id="valor1" value="2">Não</option>
				</select>

				<input id="date" class="inputSimple-horary" maxlength="10" placeholder="Data..." onkeypress="validate(event)" onkeyup="mascara()">
				<input id="hour" class="inputSimple-horary" maxlength="5" placeholder="Hora..." onkeypress="validate(event)" onkeyup="mascaraHora()">
			</div></div>
			<div id='socialRight'></div>
			<div id="buttonMyConsults-Medic" class="checkConsult2"><i class="fas fa-check fa-xl"></i>
		</div>
`);

$("#socialRight").html("")
	$("#socialRight").html("<div id='socialContent'></div>")
	$.post("http://vrp_mdthospital/requestConsultaMedic",JSON.stringify({}),(data) => {
		document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
		let i = 0;
		const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
		$('#socialContent').html(`
			${nameList.map((item) => (`
				<div class="myConsults" data-table-id="${item.table}" data-user-id="${item.user_id}" data-nuser_id="${item.nuser_id}">
				<b><p style="text-align:center;">Informações da consulta</p></b>
					<b>Especialidade:</b> ${item.especialidade}<br>
					<b>Paramédico:</b> ${item.medic}<br>
					<b>Nome do paciente:</b> ${item.user_id}
					<b>Passaporte:</b> ${item.user_passaporte}<br>
					<b>Informações sobre o agendamento:</b> ${item.text}<br><br>
					<b><p style="text-align:center;">Atualizações da consulta</p></b>
					<b>Consulta agendada para:</b> ${item.date}<br>
					<b>Consulta realizada em:</b> ${item.date2}<br>
					<b>Necessita de retorno:</b> ${item.retorno}<br>
					<b>Informações sobre a consulta:</b> ${item.text2}
				</div>
			`)).join('')}
		`);
	});
}

function mascara() {
	var data = document.getElementById("date")
		if(data.value.length == 2 || data.value.length == 5){
			data.value += "/"
		}
}

function mascaraHora() {
	var data2 = document.getElementById("hour")
		if(data2.value.length == 2 || data2.value.length == 6){
			data2.value += ":"
		}
}

function validate(evt) {
	var theEvent = evt || window.event;
  
	// Handle paste
	if (theEvent.type === 'paste') {
		key = event.clipboardData.getData('text/plain');
	} else {
	// Handle key press
		var key = theEvent.keyCode || theEvent.which;
		key = String.fromCharCode(key);
	}
	var regex = /[0-9]|\./;
	if( !regex.test(key) ) {
	  theEvent.returnValue = false;
	  if(theEvent.preventDefault) theEvent.preventDefault();
	}
}

/* BOTÃO DE CLICK */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonMyConsults-Medic",debounce(function(){

	let $el = $('.myConsults');
	let texto = $('#myConsults-boxarea').val();
	let bottonselected = $("#boxselect :selected").val(); 
	let data = $('#date').val();
	let hora = $('#hour').val();

	$.post("http://vrp_mdthospital/updateMyConsults",JSON.stringify({
		number: $el.attr('data-table-id'),
		texto,
		data,
		hora,
		bottonselected
	}));
}));

/* MY EXAMES */
/* ---------------------------------------------------------------------------------------------------------------- */

const myExames = (passaporte) => {
	selectPage = "myExames";

	$('#content').html(`
	<div id='socialLeft'>
		<div id="content-sub-menu-rotation">
			<li id="myConsults">MINHAS CONSULTAS</li>
			<li id="myExames" class="active">MEUS EXAMES</li>
			<li id="examesResultGlobal">RESULTADO DOS EXAMES</li>
			<li id="consultaMarcar">MARCAR CONSULTAS</li>
			<li id="exameMarcar">MARCAR EXAMES</li>
		</div></div>
			<div id="titleContent-logPrison">MEUS EXAMES</div>
			<div id="pageRight-sub-menu-logprison"></div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
			<textarea id="myConsults-boxarea" class="inputSimple-myConsulsts" spellcheck="false" value="" placeholder="Detalhes sobre o resultado do exame."></textarea>
			</div></div>
			<div id='socialRight'></div>
			<div id="buttonMyExames-Medic" class="checkConsultAtendimento"><i class="fas fa-check fa-xl"></i></div>
`);

	$("#socialRight").html("")
	$("#socialRight").html("<div id='socialContent'></div>")
	$.post("http://vrp_mdthospital/requestExamesMedic",JSON.stringify({}),(data) => {
		document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
		let i = 0;
		const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
		$('#socialContent').html(`
			${nameList.map((item) => (`
				<div id="myExames-Click" class="myConsults" data-id-key="${item.table}" data-user-id="${item.user_id}" data-nuser_id="${item.nuser_id}">
					<b>Paramédico:</b> ${item.medic}<br>
					<b>Exame solicitado:</b> ${item.specialty}<br>
					<b>Nome do paciente:</b> ${item.user_id}
					<b>Passaporte:</b> ${item.user_passaporte}<br>
					<b>Exame solicitado em:</b> ${item.date}<br>
					<b>Informações sobre o agendamento:</b> ${item.text}<br>
					<b>Resultado do exame:</b> ${item.text2}
				</div>
			`)).join('')}
		`);
	});
}

/* PAGE ANUNCIO */
/* ---------------------------------------------------------------------------------------------------------------- */

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
            $.post("http://vrp_mdthospital/requestAnnounce",JSON.stringify({}),(data) => {
            $.post("http://vrp_mdthospital/getPermission",JSON.stringify({}),(data2) => {
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
    $.post("http://vrp_mdthospital/delAnnounce",JSON.stringify({
        table_id: $el.attr('data-id-key')
    }));
}));

/* CLICK PAGE ANUNCIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click",".logsBox-announce",function(){
    $.post("http://vrp_mdthospital/getPermission",JSON.stringify({}),(data) => {
    if (data["result"] == true){
        let $el = $(this);
        let isActive = $el.hasClass('active');
        $('.logsBox-announce').removeClass('active');
        if(!isActive) $el.addClass('active');
    } else {
        $('.logsBox-announce').removeClass('active');
    }});
});

/* BOTÃO DE CLICK MY EXAMES */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonMyExames-Medic",debounce(function(){
	let $el = $('.myConsults');
	let texto = $('#myConsults-boxarea').val();

	$.post("http://vrp_mdthospital/updateMyExames",JSON.stringify({
		table: $el.attr('data-id-key'),
		texto
	}));
}));

$(document).on("click",".myExames-Click",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('.myExames-Click').removeClass('active');
    if(!isActive) $el.addClass('active');
});

$(document).on("click",".myConsults",function(){
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('.myConsults').removeClass('active');
    if(!isActive) $el.addClass('active').siblings().removeClass('active');
});

$(document).on("click",".caixaExamesPendentes",function(){ //testeFuncioneAmém
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('.caixaExamesPendentes').removeClass('active');
    if(!isActive) $el.addClass('active');
});

$(document).on("click",".caixaConsultasPendentes",function(){ //myExames-Click
    let $el = $(this);
    let isActive = $el.hasClass('active');
    $('.caixaConsultasPendentes').removeClass('active');
    if(!isActive) $el.addClass('active');
});


/* BOTÕES SUB-MENUS */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#examespendentes",debounce(function(){
	examesPendentes();
}));

$(document).on("click","#marcarexames",debounce(function(){
	marcarExames();
}));

$(document).on("click","#historicoclick",debounce(function(){
	ocorrencyFunction();
}));

$(document).on("click","#sobreocorrencyclick",debounce(function(){
	functionConsultas();
}));

$(document).on("click","#myConsults",debounce(function(){
	minhasConsultas();
}));

$(document).on("click","#myExames",debounce(function(){
	myExames();
}));

$(document).on("click","#triagemSection",debounce(function(){
	functionMedic();
}));

$(document).on("click","#examesResultGlobal",debounce(function(){
	resultExames();
}));

$(document).on("click","#consultaMarcar",debounce(function(){
	consultaMarcar();
}));

$(document).on("click","#exameMarcar",debounce(function(){
	exameMarcar();
}));

$(document).on("click","#registerTriagem",debounce(function(){
	functionProntuario()
}));	

/* PAGINA DE EXAMES USUARIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#usuarioExames",debounce(function(){
    let passaporte = parseInt($('#inputUser').val());
    if(passaporte > 0){
        examesUser(passaporte);
    }
}));

/* PAGINA DE CONSULTAS USUARIO  */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#usuarioConsultas",debounce(function(){
    let passaporte = parseInt($('#inputUser').val());
    if(passaporte > 0){
        consultUser(passaporte);
    }
}));

/* PAGINA DE PRONTUARIOS USUARIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#sobreProntuarios",debounce(function(){
    let passaporte = parseInt($('#inputUser').val());
    if(passaporte > 0){
        prontuarioPage(passaporte);
    }
}));

/* PAGINA DE INFORMAÇÕES USUÁRIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#sobreclick",debounce(function(){
	let passaporte = parseInt($('#inputUser').val());
	if(passaporte > 0){
		$.post("http://vrp_mdthospital/requestGetInfos",JSON.stringify({ passaporte }),function(data){
		$.post("http://vrp_mdthospital/getPermission",JSON.stringify({}),(data2) => {
			infoPage(data,data2);
			});
		});
	}
}));

/* ---------------------------------------------------------------------------------------------------------------- */
const functionProntuario = () => {
	selectPage = "prontuario";

	$('#content').html(`
		<div id='socialLeft'>
			<div id="content-sub-menu-rotation">
				<li id="registerTriagem" class="active">REGISTRO DE TRIAGEM</li>
				<li id="triagemSection">AGUARDANDO ATENDIMENTO</li>
			</div></div>

		<div id="pageOrganizer"></div>
		<div id="titleContent-ocorrency">REGISTRO DE TRIAGEM</div>

		<div id="pageLeft">
			<div id="inputs">
				<input id="passaporte" class="bottonRegisterEvent" spellcheck="false" value="" placeholder="Passaporte."></input>

			<select id="boxselect" class="inputCheck" name="select">
  				<option id="valor1" value="1">Emergência</option>
  				<option id="valor2" value="2">Muito urgente</option>
  				<option id="valor3" value="3">Urgente</option>
				<option id="valor4" value="4">Pouco Urgente</option>
				<option id="valor5" value="5"selected>Não Urgente</option>
			</select>

			</div>
			<textarea id="textoprisao" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações do paciente."></textarea>
			<button class="buttonSimple">Registrar</button>
		</div>

		<div id="pageRight-sub-menu-ocorrency"></div>
			<div id="boxUrgencyRed"><b>EMERGÊNCIA:</b> Caso gravíssimo. O paciente necessita de atendimento imediato e possui risco de morte.</div>
			<div id="boxUrgencyOrange"><b>MUITO URGENTE:</b> Caso grave. O paciente precisa de atendimento o mais prontamente possível.</div>
			<div id="boxUrgencyYellow"><b>URGENTE:</b> Caso de gravidade moderada, não considerada como emergência, pois o paciente possui condições clínicas para aguardar.</div>
			<div id="boxUrgencyGreen"><b>POUCO URGENTE:</b> Caso menos grave. Exige atendimento médico, mas o paciente pode ser assistido no consultório médico, de forma ambulatorial.</div>
			<div id="boxUrgencyBlue"><b>NÃO URGENTE:</b> Caso de menor complexidade e sem problemas recentes. O paciente deve ser atendido e acompanhado no consultório médico, no formato ambulatorial.</div>
	`);
}

/* ATENDIMENTOS PENDENTES */
/* ---------------------------------------------------------------------------------------------------------------- */

const functionMedic = () => {
	selectPage = "functionMedic";

	$('#content').html(`
	<div id='socialLeft'>
		<div id="content-sub-menu-rotation">
			<li id="registerTriagem">REGISTRO DE TRIAGEM</li>
			<li id="triagemSection"class="active">AGUARDANDO ATENDIMENTO</li>
		</div></div>
			<div id="titleContent-logPrison">AGUARDANDO ATENDIMENTO</div>
			<div id="pageRight-sub-menu-logprison"></div>
			<div class="fasIconLoading"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

			<div id="pageRightText-sub-menu-logprison">
			<textarea id="myConsults-boxarea" class="inputSimple-myConsulsts" spellcheck="false" value="" placeholder="Informações sobre o atendimento."></textarea>
			</div></div>
			<div id='socialRight'></div>
			<div id="buttonMyConsults" class="checkConsultAtendimento"><i class="fas fa-check fa-xl"></i></div>
`);

		$("#socialRight").html("")
			$("#socialRight").html("<div id='socialContent'></div>")
			$.post("http://vrp_mdthospital/requestTriagem",JSON.stringify({}),(data) => {
				document.getElementsByClassName('fasIconLoading')[0].style.visibility = 'hidden';
				let i = 0;
				const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
				$('#socialContent').html(`
					${nameList.map((item) => (`
						<div class="myConsults" data-table-id="${item.table}" data-id-user="${item.iduser}" data-user-id="${item.user_id}" ${item.color}'":""}">
							<b>Socorrista:</b> ${item.medic}<br>
							<b>Nome do paciente:</b> ${item.user_id}
							<b>Passaporte:</b> ${item.user_passaporte}<br>
							<b>Entrada do paciente:</b> ${item.date}<br>
							<b>Informações sobre a triagem:</b> ${item.text}<br>
							<b>Informações sobre o atendimento:</b> ${item.text2}
						</div>
			`)).join('')}
		`);
	});
}

$(document).on("click","#buttonMyConsults",debounce(function(){
	let texto = $('#myConsults-boxarea').val();
	let $el = $('.myConsults.active');
	$.post("http://vrp_mdthospital/updateTriagemUser",JSON.stringify({
		table_id: $el.attr('data-table-id'),
		user_id: $el.attr('data-id-user'),
		texto
	}));
}));


/* ---------------------------------------------------------------------------------------------------------------- */

const functionAdmin = () => {
    selectPage = "functionAdmin"

        $.post("http://vrp_mdthospital/getPermission",JSON.stringify({ }),function(data){

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
                <i id="remove-button" class=\"material-icons group_remove\">remove</i>
                <i id="add-button" class=\"material-icons person_add\">add</i>

		<div id='socialRight-Funcionary'></div>
		</div>
	`);

		$.post("http://vrp_mdthospital/meDaOsTrabalhadores",JSON.stringify({}),(data) => {

            $("#socialRight-Funcionary").html("")
            $("#socialRight-Funcionary").html("<div id='pageFuncionary2'></div>")
                document.getElementsByClassName('fasIconLoading-announce')[0].style.visibility = 'hidden';
                let i = 0;
                const nameList = data.resultado.sort((a,b) => (a.id > b.id) ? 1: -1);
                $('#pageFuncionary2').html(`
                ${nameList.map((item) => (`
                    <div class="myFuncionary" data-user-id="${item.user_id}">
                        <b>Nome:</b> ${item["name"]} <b>Passaporte:</b> ${item.user_id}<br>
						<b>Nivel:</b> ${item["promotion"]}
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
    $.post("http://vrp_mdthospital/desligarUser",JSON.stringify({
        user_id: $el.attr('data-user-id')
    }));
}));

$(document).on("click","#remove-button",debounce(function(){
    let $el = $('.myFuncionary.active');
    $.post("http://vrp_mdthospital/rebaixarUser",JSON.stringify({
        user_id: $el.attr('data-user-id')
    }));
}));


$(document).on("click","#add-button",debounce(function(){
    let $el = $('.myFuncionary.active');
    $.post("http://vrp_mdthospital/promoverUser",JSON.stringify({
        user_id: $el.attr('data-user-id')
    }));
}));

$(document).on("click",".buttonSimple",debounce(function(){
	let passaporte = parseInt($('#passaporte').val());
	let texto = $('#textoprisao').val();
	let bottonselected = $("#boxselect :selected").val(); 
	if(passaporte,bottonselected > 0){
		$.post("http://vrp_mdthospital/triagemUser",JSON.stringify({ passaporte,bottonselected,texto }));
		$('#passaporte').val('');
		$('#bottonselected').text('');
		$('#textoprisao').val('');
	}
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

/* MARCAR EXAMES MEDICO*/
/* ---------------------------------------------------------------------------------------------------------------- */

const exameMarcar = () => {
	selectPage = "exameMarcar";

	$('#content').html(`
		<div id='socialLeft'>
			<div id="content-sub-menu-rotation">
				<li id="myConsults">MINHAS CONSULTAS</li>
				<li id="myExames">MEUS EXAMES</li>
				<li id="examesResultGlobal">RESULTADO DOS EXAMES</li>
				<li id="consultaMarcar">MARCAR CONSULTAS</li>
				<li id="exameMarcar" class="active">MARCAR EXAMES</li>
			</div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">MARCAR EXAME</div>
			<div id="pageLeft">
			<div id="inputs">
				<input id="passaporteInformationExames" class="bottonRegisterEvent" spellcheck="false" value="" placeholder="Passaporte."></input>
				
			<select id="boxselect" class="inputCheck" name="select">
  				<option id="valor1" value="1"selected>Ultrassonografia</option>
				<option id="valor2" value="2">Raio X</option>
  				<option id="valor3" value="3">Beta HCG</option>
  				<option id="valor4" value="4">Hemograma Completo</option>
				<option id="valor5" value="5">Tomografia</option>
				<option id="valor6" value="6">Ressonância</option>
			</select>

			</div>
			<textarea id="textoConsultas3" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações sobre o exame do paciente."></textarea>
			<button id="buttonMarcarExamesMedic" class="buttonSimple-ocorrency">Marcar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
			<div id='socialRight'></div>
		`);
}

/* BOTÃO MARCAR EXAMES MEDICO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonMarcarExamesMedic",debounce(function(){
	let passaporte = parseInt($('#passaporteInformationExames').val());
	let texto = $('#textoConsultas3').val();
	let bottonselected = $("#boxselect :selected").val(); 
	if(passaporte,bottonselected > 0){
		$.post("http://vrp_mdthospital/examesMedicUser",JSON.stringify({ passaporte,bottonselected,texto }));
		$('#passaporteInformationExames').val('');
		$('#textoConsultas3').val('');
		}
}));


/* MARCAR CONSULTAS MEDICO*/
/* ---------------------------------------------------------------------------------------------------------------- */

const consultaMarcar = () => {
	selectPage = "consultaMarcar";

	$('#content').html(`
		<div id='socialLeft'>
			<div id="content-sub-menu-rotation">
				<li id="myConsults">MINHAS CONSULTAS</li>
				<li id="myExames">MEUS EXAMES</li>
				<li id="examesResultGlobal">RESULTADO DOS EXAMES</li>
				<li id="consultaMarcar" class="active">MARCAR CONSULTAS</li>
				<li id="exameMarcar">MARCAR EXAMES</li>
			</div></div>
			<div id="pageOrganizer"></div>
			<div id="titleContent-ocorrency">MARCAR CONSULTAS</div>
			<div id="pageLeft">
			<div id="inputs">
				<input id="passaporteInformationExames" class="bottonRegisterEvent" spellcheck="false" value="" placeholder="Passaporte."></input>
				
			<select id="boxselect" class="inputCheck" name="select">
				<option id="valor1" value="1"selected>Clínico Geral</option>
			  	<option id="valor1" value="2">Pediatria</option>
				<option id="valor2" value="3">Cardiologista</option>
				<option id="valor3" value="4">Ginecologista</option>
			  	<option id="valor4" value="5">Endocrinologista</option>
			  	<option id="valor5" value="6">Nefrologia</option>
		  	</select>

			</div>
			<textarea id="textoConsultas2" class="textareaSimple" spellcheck="false" value="" placeholder="Todas as informações sobre o exame do paciente."></textarea>
			<button id="buttonMarcarConsultaMedic" class="buttonSimple-ocorrency">Marcar</button>
			</div>
			<div id="pageRight-sub-menu-ocorrency">OBSERVAÇÕES:</div>

			<div id="pageRightText-sub-menu-logprison">
			<b>1:</b> Todas as informações encontradas e fornecidas são de uso exclusivo policial, tudo que for encontrado na mesma são informação em tempo real.<br><br><b>2:</b> Nunca forneça qualquer informação dessa página para outra pessoa, apenas se a mesma for o proprietário ou o advogado do mesmo.
			</div></div>
		`);
}

/* BOTÃO MARCAR CONSULTAS MEDICO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonMarcarConsultaMedic",debounce(function(){
	let passaporte = parseInt($('#passaporteInformationExames').val());
	let texto = $('#textoConsultas2').val();
	let bottonselected = $("#boxselect :selected").val(); 
	if(passaporte,bottonselected > 0){
		$.post("http://vrp_mdthospital/consultaMedicUser",JSON.stringify({ passaporte,bottonselected,texto }));
		$('#passaporteInformationExames').val('');
		$('#textoConsultas2').val('');
		}
}));

/* BOTÃO ENVIAR ANUNCIO */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonEnviarAnuncio",debounce(function(){
	let texto = $('#textoAnuncio').val();
		$.post("http://vrp_mdthospital/anuncioAdm",JSON.stringify({ texto }));
		$('#textoAnuncio').val('');
}));

/* BOTÃO MARCAR EXAMES */
/* ---------------------------------------------------------------------------------------------------------------- */

$(document).on("click","#buttonMarcarExames",debounce(function(){
	let passaporte = parseInt($('#passaporteInformationExames').val());
	let texto = $('#textoConsultasExames').val();
	let bottonselected = $("#boxselect :selected").val(); 
	if(passaporte,bottonselected > 0){
		$.post("http://vrp_mdthospital/examesUser",JSON.stringify({ passaporte,bottonselected,texto }));
		$('#passaporteInformationExames').val('');
		$('#textoConsultasExames').val('');
		}
}));

/* ---------------------------------------------------------------------------------------------------------------- */

const functionRanking = () => {
    selectPage = "functionRanking";

    $('#content').html(`
                <div id="titleContent-announcePage">RANKING HOSPITALAR</div>
                <div class="fasIconLoading-announce"><i class="fas fa-circle-notch fa-spin fa-5x"></i></div>

        <div id='socialRight-Ranking'>
    `);

        $.post("http://vrp_mdthospital/rankParamedic",JSON.stringify({}),(data) => {
            let position = 0;
            
            const nameList = data.resultado.sort((a,b) => (a["tops"] > b["tops"]) ? 1: -1);

            document.getElementsByClassName('fasIconLoading-announce')[0].style.visibility = 'hidden';
			
            $("#socialRight-Ranking").html("<div id='pageFuncionary-Ranking'></div>")

            $('#pageFuncionary-Ranking').append(`
                ${nameList.map((item) => (`
                    <div class="myFuncionary-Ranking" data-position="${position = position + 1}" data-user-id="${item.user_id}">

                    <titles>${item["name"]}</titles>
                    
					<div class="material-icons verified"> ${(position == 1 || position == 2 || position == 3) ? "<img src=\"https://r2rp.com/static/images/"+position+".png\">":""}</div><br>
                    
                    ${item.time}</div>
            `)).join('')}
        `);
    });
}


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