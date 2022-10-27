const debugStatus = false;

const actions = {
	openSelector,
	showSelectButton,
	closeSelector,

	closeCreator,

	openSpawn,
	closeSpawn,
};

$(() => {
	window.addEventListener("message", function (event) {
		const item = event.data;

		debug("Received request:", item.action, JSON.stringify(item));

		if (actions[item.action])
			actions[item.action](item);
	});
});

// * Character Selection
// Show selector
function openSelector(data) {
	const characterList = data.characters.sort((a, b) => (a.id > b.id ? 1 : -1));

	$("#charPage").html(`
		${
			(data.maxCharacters || 1) > data.characters.length ?
			`
				<div id="createChar" >
					<b><i class="fa-solid fa-circle-plus" style="margin-right: 6px;"></i> Novo Personagem</b>
					Pressione para criar um novo personagem.
				</div>
			`
		:
			`
				<div id="createCharLocked">
					<b><i class="fa-solid fa-lock" style="margin-right: 6px;"></i> Bloqueado</b>
					Você não pode criar novos personagens!
				</div>
			`
		}

		${characterList.map((item) => `
			<div id="selectChar" data-id="${item.id}">
				<div style="display: flex; align-items: center">
					<div style="margin-right: 18px;">
						<i class="fa-solid fa-user" style="font-size: 18px"></i> 
					</div>
					<div>
						<b>Nome:</b> ${item.name} ${item.name2}<br>
						<b>Passaporte:</b> ${item.id}<br>
						<b>Telefone:</b> ${item.phone}<br>
					</div>
				</div>
			</div>`
		).join("")}
	`);

	$("#createPage").hide();
	$("#charPage").show();
}

// Close selector
function closeSelector() {
	$("#spawnPage").hide();
}

// Preview character
$(document).on("click", "#selectChar", function (e) {
	const target = $(this);
	const id = parseInt(target.data("id"));

	$("#selectChar").prop("disabled", true);
	send("visualizeCharacter", { id }, (_) =>
		$("#selectChar").prop("disabled", false)
	);
});

// Show select button after character preview
function showSelectButton(data) {
	$("#selectPage").show();
	$("#selectPage").html(`<button id="chooseCharacter" class="float" data-id="${data.id}">Selecionar</button>`);
}

// Choose character
$(document).on("click", "#chooseCharacter", function (e) {
	const target = $(this);
	const id = parseInt(target.data("id"));

	send("chooseCharacter", { id });
	$("#charPage").hide();
	$("#selectPage").hide();
});

// * Create new character
// Open creator menu
$(document).on("click", "#createChar", function (_) {
	$("#charPage").hide();
	$("#createPage").show();
	$("#selectPage").hide();
	send("deletePed");
});

// Start creator
$("#createNew").on("click", () => {
	const name = $("#charNome").val();
	const name2 = $("#charSobrenome").val();
	const gender = $("#charGender").val();
	if (name !== "" && name2 !== "" && (gender === "M" || gender === "F")) {
		const model = gender == "M" ? "mp_m_freemode_01" : "mp_f_freemode_01";
		send("newCharacter", { name, name2, gender: model });
	}
});

// Back to selector
$("#createBack").on("click", () => {
	$("#charPage").show();
	$("#createPage").hide();
});

function closeCreator() {
	$("#charPage").hide();
	$("#createPage").hide();
}

// * Spawn
// Open menu
let selectedSpawn;
function openSpawn(data) {
	const spawnLocations = Object.values(data.spawnLocations).sort((a, b) => (a.name > b.name ? 1 : -1));
	$("#spawnPage").html(`
		${spawnLocations.map((item) =>
			`<div id="previewSpawn" data-location="${item.id}">
				${item.name}
			</div>`
		).join("")}
		<div id="selectSpawn">Confirmar</div>
	`);
	$("#spawnPage").show();
}

// Close menu
function closeSpawn() {
	$("#spawnPage").hide();
}

// Preview location
$(document).on("click", "#previewSpawn", function (e) {
	const loc = $(this).data("location");

	selectedSpawn = loc;
	send("previewSpawn", { id: parseInt(loc) });
});

// Select location
$(document).on("click", "#selectSpawn", function (_) {
	send("selectSpawn", { id: (selectedSpawn || "lastLocation") });
});


// ? Utils
function send(name, data, callback) {
	debug("Sending:", name, JSON.stringify(data));

	$.post(`http://${GetParentResourceName()}/${name}`, JSON.stringify(data || {}), (callbackData) => {
		debug("Received callback:", name, JSON.stringify(callbackData));
		callback(callbackData);
	});
}

function debug(...message) {
	if (debugStatus)
		console.log("[DEBUG]", ...message);
}
