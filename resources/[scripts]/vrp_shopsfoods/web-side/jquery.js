var selectShop = "selectShop";
var selectType = "Buy";
/* --------------------------------------------------- */
$(document).ready(function() {
    window.addEventListener("message", function(event) {
        switch (event.data.action) {
            case "showNUI":
                selectShop = event.data.name;
                selectType = event.data.type;
                $(".inventory").css("display", "flex");
                requestShop();
                break;

            case "hideNUI":
                $(".inventory").css("display", "none");
                $(".ui-tooltip").hide();
                break;

            case "requestShop":
                requestShop();
                break;
        }
    });

    document.onkeyup = data => {
        if (data["key"] === "Escape") {
            $.post("http://vrp_shopsfoods/close");
            $(".invRight").html("");
            $(".invLeft").html("");
        }
    }
});
/* --------------------------------------------------- */
const updateDrag = () => {
        $(".populated").draggable({
            helper: "clone"
        });

        $('.empty').droppable({
            hoverClass: 'hoverControl',
            drop: function(event, ui) {
                if (ui.draggable.parent()[0] == undefined) return;

                const shiftPressed = event.shiftKey;
                const origin = ui.draggable.parent()[0].className;
                if (origin === undefined) return;
                const tInv = $(this).parent()[0].className;

                itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
                const target = $(this).data('slot');

                if (itemData.key === undefined || target === undefined) return;

                let amount = $(".amount").val();
                if (shiftPressed) amount = ui.draggable.data('amount');

                if (tInv === "invLeft") {
                    if (origin === "invLeft") {
                        $.post("http://vrp_shopsfoods/populateSlot", JSON.stringify({
                            item: itemData.key,
                            slot: itemData.slot,
                            target: target,
                            amount: parseInt(amount)
                        }))

                        $(".amount").val("");
                    } else if (origin === "invRight" && selectType === "buyStore") {
                        $.post("http://vrp_shopsfoods/functionShops", JSON.stringify({
                            shop: selectShop,
                            type: selectType,
                            item: itemData.key,
                            slot: target,
                            amount: parseInt(amount)
                        }));

                        $(".amount").val("");
                    }
                } else if (tInv === "invRight") {
                    if (origin === "invLeft" && selectType === "salesStore") {
                        $.post("http://vrp_shopsfoods/functionShops", JSON.stringify({
                            shop: selectShop,
                            type: selectType,
                            item: itemData.key,
                            slot: itemData.slot,
                            amount: parseInt(amount)
                        }));

                        $(".amount").val("");
                    }
                }
            }
        });

        $('.populated').droppable({
            hoverClass: 'hoverControl',
            drop: function(event, ui) {
                if (ui.draggable.parent()[0] == undefined) return;

                const shiftPressed = event.shiftKey;
                const origin = ui.draggable.parent()[0].className;
                if (origin === undefined) return;
                const tInv = $(this).parent()[0].className;

                itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
                const target = $(this).data('slot');

                if (itemData.key === undefined || target === undefined) return;

                let amount = $(".amount").val();
                if (shiftPressed) amount = ui.draggable.data('amount');


                if (tInv === "invLeft") {
                    if (origin === "invLeft") {
                        $.post("http://vrp_shopsfoods/updateSlot", JSON.stringify({
                            item: itemData.key,
                            slot: itemData.slot,
                            target: target,
                            amount: parseInt(amount)
                        }));

                        $(".amount").val("");


                    } else if (origin === "invRight") {

                        if (itemData.key === undefined || target === undefined || itemData.key !== $(this).data('item-key')) return;

                        $.post("http://vrp_shopsfoods/functionShops", JSON.stringify({
                            shop: selectShop,
                            type: selectType,
                            item: itemData.key,
                            slot: target,
                            amount: parseInt(amount)
                        }));

                        $(".amount").val("");
                    }

                } else if (tInv === "invRight") {

                    if (origin === "invLeft" && selectType === "salesStore") {

                        if (itemData.key === undefined) return;

                        $.post("http://vrp_shopsfoods/functionShops", JSON.stringify({
                            shop: selectShop,
                            type: selectType,
                            item: itemData.key,
                            slot: itemData.slot,
                            amount: parseInt(amount)
                        }));

                        $(".amount").val("");
                    }
                }
            }
        });

        $(".populated").tooltip({
            create: function(event,ui){
                var serial = $(this).attr("data-serial");
                var economy = $(this).attr("data-economy");
                var desc = $(this).attr("data-description");
                var name = $(this).attr("data-name-key");
                var weight = $(this).attr("data-peso");
                var type = $(this).attr("data-type");
                var max = $(this).attr("data-max");
                var stock = $(this).attr("data-stock");
                var hunger = $(this).attr("data-hunger");
                var thirst = $(this).attr("data-thirst");
                var stress = $(this).attr("data-stress");
                var myLeg = "center top-196";
    
                if (desc !== "undefined"){
                    myLeg = "center top-219";
                }
    
                if (stock == undefined){
                    stockShop = "Não Definido";
                } else {
                    var stockShop = formatarNumero(stock)
                }

                if (type == "Alimento"){
                    $(this).tooltip({
                        content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${Number(weight).toFixed(2)}</r></r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+formatarNumero(economy):economy}</r> <br>Nutrição: <r>${hunger !== "undefined" ? hunger:"S/N"}</r> <s>|</s> Hidratação: <r>${thirst !== "undefined" ? thirst:"S/H"}</legenda>`,
                        position: { my: myLeg, at: "center" },
                        show: { duration: 10 },
                        hide: { duration: 10 }
                    })
                }else{
                    $(this).tooltip({
                        content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${Number(weight).toFixed(2)}</r></r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+formatarNumero(economy):economy}</legenda>`,
                        position: { my: myLeg, at: "center" },
                        show: { duration: 10 },
                        hide: { duration: 10 }
                    })
                }
            }
        });
    }
    /* --------------------------------------------------- */
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
    /* --------------------------------------------------- */
const colorPicker = (percent) => {
    var colorPercent = "#2e6e4c";

    if (percent >= 100)
        colorPercent = "rgba(255,255,255,0)";

    if (percent >= 51 && percent <= 75)
        colorPercent = "#fcc458";

    if (percent >= 26 && percent <= 50)
        colorPercent = "#fc8a58";

    if (percent <= 25)
        colorPercent = "#fc5858";

    return colorPercent;
}

const colorPicker2 = (percent) => {
	var colorPercent = "#2e6e4c80";

	if (percent >= 100)
		colorPercent = "rgba(255,255,255,0)";

	if (percent >= 51 && percent <= 75)
		colorPercent = "#fcc55872";

	if (percent >= 26 && percent <= 50)
		colorPercent = "#fc895868";

	if (percent <= 25)
		colorPercent = "#fc5a5a66";

	return colorPercent;
}

const requestShop = () => {
    $.post("http://vrp_shopsfoods/requestShop", JSON.stringify({ shop: selectShop, type: selectType }), (data) => {
        $("#weightTextLeft").html(`${(data["weight"]).toFixed(2)}   /   ${(data["maxweight"]).toFixed(2)}`);

        $("#weightBarLeft").html(`<div id="weightContent" style="width: ${data["weight"] / data["maxweight"] * 100}%"></div>`);

        $(".invLeft").html("");
        $(".invRight").html("");

        for (let x = 1; x <= 72; x++) {
            const slot = x.toString();

            if (data["inventoryUser"][slot] !== undefined) {
                const v = data["inventoryUser"][slot];
                const maxDurability = 86400 * v["days"];
                const newDurability = (maxDurability - v["durability"]) / maxDurability;
                var actualPercent = newDurability * 100;
                if (actualPercent <= 1)
                actualPercent = 0;

                const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" style="background-image: url('http://131.196.196.218/inventory/armas/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/comidas/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/geral/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/hospital/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/ilegal/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/mechanic/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/premium/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/veiculos/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/weapons/${v["index"]}.png'); background-size: 86%; background-position: center; background-repeat: no-repeat;" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}" data-hunger="${v["hunger"]}" data-thirst="${v["thirst"]}">

                    <div class="itemAmount">${formatarNumero(v["amount"])}x</div>
				</div>`;

                $(".invLeft").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;

                $(".invLeft").append(item);
            }
        }

        const nameList2 = data.inventoryShop.sort((a, b) => (a.name > b.name) ? 1 : -1);

        for (let x = 1; x <= data["slotShops"]; x++) {
            const slot = x.toString();

            if (nameList2[x - 1] !== undefined) {
                const v = nameList2[x - 1];
                const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" style="background-image: url('http://131.196.196.218/inventory/armas/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/comidas/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/geral/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/hospital/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/ilegal/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/mechanic/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/premium/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/veiculos/${v["index"]}.png'),
                url('http://131.196.196.218/inventory/weapons/${v["index"]}.png'); background-size: 86%; background-position: center; background-repeat: no-repeat;" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}" data-hunger="${v["hunger"]}" data-thirst="${v["thirst"]}">

					<div class="itemPrice">$${formatarNumero(v["price"])}</div>
				</div>`;

                $(".invRight").append(item);
            } else {
                const item = `<div class="item empty" data-slot="${slot}"></div>`;

                $(".invRight").append(item);
            }
        }
        updateDrag();
    });
}

function somenteNumeros(e) {
    var charCode = e.charCode ? e.charCode : e.keyCode;
    if (charCode != 8 && charCode != 9) {
        var max = 9;
        var num = $(".amount").val();

        if ((charCode < 48 || charCode > 57) || (num.length >= max)) {
            return false;
        }
    }
}