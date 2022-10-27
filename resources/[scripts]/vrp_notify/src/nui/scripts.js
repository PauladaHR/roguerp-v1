var sound = new Audio("./sound.mp3");
sound.volume = 0.4;

let notifyType = {
	sucesso: "success",
	verde: "success",

	importante: "info",
	azul: "info",

	negado: "error",
	vermelho: "error",

	aviso: "warning",
	amarelo: "warning",

	roxo: "clock",
};

let notifyTitle = {
	success: "Sucesso",
	info: "Importante",
	warning: "Aviso",
	error: "Negado",
	clock: "Anúncio",
}

window.addEventListener("message", function (event) {
	if (event.data.action == "open")
		showNotify(event.data);
});

let notifyID = 0;
function showNotify(data) {
	let type = data.type;
	if (notifyType[type])
		type = notifyType[type];

	notifyID++;
	let number = notifyID;

	$("#notify-wrapper").prepend(`
		<div class="notify wrapper-${number}">
			<div class="notify notification_main-${number}">
				<div class="title-${number}"></div>
				<div class="text-${number}">
					${data.message}
				</div>
			</div>
		</div>
	`);

	$(`.title-${number}`).html(notifyTitle[type]).css({
		"font-size": "16px",
		"font-weight": "600",
	});
	$(".text-" + number).css({
		"font-size": "12px",
	});

	$(`.notification_main-${number}`).addClass(`${type}-icon`);
	$(".notification_main-" + number).addClass("main");

	$(`.wrapper-${number}`).addClass(type);
	$(`.wrapper-${number}`).css({
		"margin-bottom": "10px",
		width: "275px",
		margin: "0 0 8px -180px",
		"border-radius": "15px",
	});
	sound.play();

	anime({
		targets: `.wrapper-${number}`,
		translateX: -60,
		duration: 750,
		easing: "spring(5, 100, 35, 10)",
	});
	setTimeout(function () {
		anime({
			targets: `.wrapper-${number}`,
			translateX: 500,
			duration: 750,
			easing: "spring(5, 80, 5, 0)",
		});
		setTimeout(function () {
			$(`.wrapper-${number}`).remove();
		}, 1000);
	}, data.time);
}
