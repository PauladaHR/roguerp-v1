$(document).ready(function() {
    window.addEventListener("message", event => {
        switch (event.data.action) {
            case "showMenu":
                updateMochila();
                $("#body").fadeIn(500);
                break;

            case "hideMenu":
                $("#body").fadeOut(250);
                $(".ui-tooltip").hide();
                break;

            case "updateMochila":
                updateMochila();
                break;
        }
    });

    document.onkeyup = data => {
        if (data["key"] === "Escape") {
            $.post("http://vrp_inventory/invClose");
        }
    };
});

/* ----------CRAFT---------- */
$(document).on("click",".craft",function(e){
    $.post("http://vrp_inventory/Craft");
});

const updateDrag = () => {
    $('.populated').draggable({
        helper: 'clone'
    });

    $('.empty').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            const shiftPressed = event.shiftKey;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = ui.draggable.data('amount');

            updateDrag()

            $.post("http://vrp_inventory/populateSlot", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                target: target,
                amount: parseInt(amount)

            }));
            $('.amount').val("")
        }
    });

    $('.populated').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            const shiftPressed = event.shiftKey;
            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };
            const target = $(this).data('slot');

            if (itemData.key === undefined || target === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = ui.draggable.data('amount');

            $.post("http://vrp_inventory/updateSlot", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                target: target,
                amount: parseInt(amount)
            }))
            $('.amount').val("")
        }
    });

    $(".use").droppable({
        hoverClass: "hoverControl",
        drop: function(event, ui) {
            if (ui.draggable.parent()[0] == undefined) return;

            const shiftPressed = event.shiftKey;
            const origin = ui.draggable.parent()[0].className;
            if (origin === undefined || origin === "invRight") return;
            itemData = { key: ui.draggable.data("item-key"), slot: ui.draggable.data("slot") };

            if (itemData.key === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = ui.draggable.data("amount");

            $.post("http://vrp_inventory/useItem", JSON.stringify({
                slot: itemData.slot,
                amount: parseInt(amount)
            }));

            $(".amount").val("");
        }
    });

    $(".populated").on("auxclick", e => {
        if (e["which"] === 3) {
            const item = e["target"];
            const shiftPressed = event.shiftKey;

            itemData = { key: $(item).data("item-key"), slot: $(item).data("slot") };

            if (itemData.key === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = $(item).data("amount");

            $.post("http://vrp_inventory/useItem", JSON.stringify({
                slot: itemData.slot,
                amount: parseInt(amount)
            }));
        }
    });

    $('.drop').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            const shiftPressed = event.shiftKey;

            itemData = { key: ui.draggable.data('item-key'), slot: ui.draggable.data('slot') };

            if (itemData.key === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = ui.draggable.data('amount');

            $.post("http://vrp_inventory/dropItem", JSON.stringify({
                item: itemData.key,
                slot: itemData.slot,
                amount: parseInt(amount)
            }))

            $('.amount').val("")
        }
    });

    $('.submit').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            const shiftPressed = event.shiftKey;

            itemData = { key: ui.draggable.data('item-key') };

            if (itemData.key === undefined) return;

            let amount = $(".amount").val();
            if (shiftPressed) amount = ui.draggable.data('amount');

            $.post("http://vrp_inventory/sendItem", JSON.stringify({
                item: itemData.key,
                amount: parseInt(amount)
            }))

            $('.amount').val("")
        }
    });

    $(".populated").tooltip({
        create: function(event, ui) {
            var serial = $(this).attr("data-serial");
            var economy = $(this).attr("data-economy");
            var desc = $(this).attr("data-description");
            var amounts = $(this).attr("data-amount");
            var name = $(this).attr("data-name-key");
            var weight = $(this).attr("data-peso");
            var type = $(this).attr("data-type");
            var hunger = $(this).attr("data-hunger");
            var thirst = $(this).attr("data-thirst");
            var stress = $(this).attr("data-stress");
            var max = $(this).attr("data-max");
            var myLeg = "center top-196";

            if (desc !== "undefined") {
                myLeg = "center top-219";
            }

            if (type === "Alimento") {
                $(this).tooltip({
                    content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${(weight * amounts).toFixed(2)}</r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+economy:economy}</r>   <br>Nutrição: <r>${hunger !== "undefined" ? hunger:"S/N"}</r> <s>|</s> Hidratação: <r>${thirst !== "undefined" ? thirst:"S/H"}</r></legenda>`,
                    position: { my: myLeg, at: "center" },
                    show: { duration: 10 },
                    hide: { duration: 10 }
                })
            } else if (type === "Premium") {
                $(this).tooltip({
                    content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} </r>Peso: <r>${(weight * amounts).toFixed(2)}</r></r></legenda>`,
                    position: { my: myLeg, at: "center" },
                    show: { duration: 10 },
                    hide: { duration: 10 }
                })
            } else if (type === "Stress") {
                $(this).tooltip({
                    content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${(weight * amounts).toFixed(2)}</r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+economy:economy}</r>   <br>Stress: <r>${stress !== "undefined" ? stress:"S/S"}</r></legenda>`,
                    position: { my: myLeg, at: "center" },
                    show: { duration: 10 },
                    hide: { duration: 10 }
                })
            } else {
                $(this).tooltip({
                    content: `<item>${name}</item>${desc !== "undefined" ? "<br><description>"+desc+"</description>":""}<br><legenda>${serial !== "undefined" ? "Serial: <r>"+serial+"</r>":"Tipo: <r>"+type+"</r>"} <s>|</s> Máximo: <r>${max !== "undefined" ? max:"S/L"}</r><br>Peso: <r>${(weight * amounts).toFixed(2)}</r> <s>|</s> Economia: <r>${economy !== "S/V" ? "$"+economy:economy}</r></legenda>`,
                    position: { my: myLeg, at: "center" },
                    show: { duration: 10 },
                    hide: { duration: 10 }
                })
            }
        }
    });
}

const updateMochila = () => {

        $.post("http://vrp_inventory/requestMochila", JSON.stringify({}), (data) => {
            // $("#body").fadeIn(500);
        // if ($("#body").css("display")=="none") {
        //     $("#body").fadeIn(500);
        // }

            $("#myInfos").html(`
                <div id="myInfosContent">
                    <span>${(data["peso"]).toFixed(2)} / ${(data["maxpeso"]).toFixed(2)}</span>
                </div>
            `);

            $("#invweight").html(`
			    <div id="myWeight">
				  <div id="myWeightContent" style="width: ${data["peso"] / data["maxpeso"] * 100}%"></div>
			  </div>
		  `);

                    $("#invleft").html("");
                    for (let x = 1; x <= 70; x++) {
                        const slot = x.toString();

                        if (data["inventario"][slot] !== undefined) {
                            const v = data["inventario"][slot];
                            const item = `<div class="item populated" title="" data-max="${v["max"]}" data-type="${v["type"]}" data-serial="${v["serial"]}" style="background-image: url('http://131.196.196.218/inventory/armas/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/comidas/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/geral/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/hospital/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/ilegal/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/mechanic/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/premium/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/veiculos/${v["index"]}.png'),
                            url('http://131.196.196.218/inventory/weapons/${v["index"]}.png'); background-size: 93%; background-position: center; background-repeat: no-repeat;" data-amount="${v["amount"]}" data-peso="${v["peso"]}" data-item-key="${v["key"]}" data-name-key="${v["name"]}" data-slot="${slot}" data-description="${v["desc"]}" data-economy="${v["economy"]}" data-hunger="${v["hunger"]}" data-stress="${v["stress"]}" data-thirst="${v["thirst"]}">

					${v["durability"] !== undefined ? `<div id="durability"><div id="durability2" style="width: ${v["durability"]*10}%"></div></div>`:``}

					<div id="quantity">${formatarNumero(v["amount"])}x</div>
				  </div>`;
  
				  document.getElementById("invleft").innerHTML = `${document.getElementById("invleft").innerHTML} ${item}`;
			  } else {
				  const item = `<div class="item empty" data-slot="${slot}"></div>`;
  
				  document.getElementById("invleft").innerHTML = `${document.getElementById("invleft").innerHTML} ${item}`;
			  }
		  }
		  updateDrag();
	  });
  }
  
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
  
  function somenteNumeros(e){
	  var charCode = e.charCode ? e.charCode : e.keyCode;
	  if (charCode != 8 && charCode != 9){
		  var max = 9;
		  var num = $(".amount").val();
  
		  if ((charCode < 48 || charCode > 57)||(num.length >= max)){
			  return false;
		  }
	  }
  }