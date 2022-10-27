--[[
==========================================================================================================================
	PRESTE ATENÇÃO AO CONFIGURAR TUDO, SE VOCÊ QUEBRAR ALGO BAIXE A CONFIGURAÇÃO ORIGINAL DE VOLTA E TENTE NOVAMENTE
==========================================================================================================================
	Para alterar o posicionamento da HUD abra o style.css e altere os valores nas linhas 322 e 448
]]

Config = {}

Config.webhook = "https://discord.com/api/webhooks/983481222435057724/kfHL-zEkBC5mHX5INZMjebOpbkVVmVdJl1eyeLislnAVPo79gTv1HvE9HcWuaSsuXP3O"						-- Webhook para enviar logs para discord
Config.lang = "br"								-- Defina o idioma do arquivo [en/br]

Config.ESX = {									-- Configurações ESX, se você estiver usando vRP, ignore
	['ESXSHAREDOBJECT'] = "esx:getSharedObject4687",-- Altere seu evento de objeto getshared aqui, se você estiver usando anti-cheat
}

Config.format = {
	['currency'] = 'BRL',						-- Este é o formato da moeda, para que o símbolo da sua moeda apareça corretamente [Exemplos: BRL, USD]
	['location'] = 'pt-BR'						-- Este é o local do seu país, para formatar as casas decimais de acordo com seu padrão [Exemplos: pt-BR, en-US]
}

Config.mechanicLocations = {
	['enabled'] = false,						-- false: você poderá abrir a UI em qualquer lugar, true: você poderá abrir a UI apenas nos locais abaixo
	['locations'] = {							-- Locais para abrir a UI (as coordenadas são compostas por x, y, z e raio)
		{x = -337.13, y = -132.55, z = 39.01, radius = 30.0}, 
		{x = -205.04, y = -1321.29, z = 32.21, radius = 20.0}
	}
}

Config.command = "status"						-- Comando para abrir o menu (Evento para abrir o menu se você quiser acioná-lo de algum lugar: TriggerEvent ('advanced_vehicles: showStatusUI'))
Config.permission = "Mechanic"		-- Permissão para realizar as ações no menu (defina como false para desativar a permissão)

Config.enabledVehicles = {						-- Habilite aqui os veículos que deseja funcionar no script
	[0] = true, 	-- Compacts
	[1] = true, 	-- Sedans
	[2] = true, 	-- SUVs
	[3] = true, 	-- Coupes
	[4] = true, 	-- Muscle
	[5] = true, 	-- Sports Classics
	[6] = true, 	-- Sports
	[7] = true, 	-- Super
	[8] = true, 	-- Motorcycles
	[9] = true, 	-- Off-road
	[10] = true, 	-- Industrial
	[11] = true, 	-- Utility
	[12] = true, 	-- Vans
	[13] = false, 	-- Cycles
	[14] = false, 	-- Boats
	[15] = false, 	-- Helicopters
	[16] = false, 	-- Planes
	[17] = false, 	-- Service
	[18] = false, 	-- Emergency
	[19] = false, 	-- Military
	[20] = true, 	-- Commercial
	[21] = false, 	-- Trains
}
Config.debugClass = false						-- Habilite isso para ver no F8 a classe do veículo em que você está

Config.itemToInspect = "scanner"				-- Item necessário para inspecionar os veículos
Config.oneClickToInspect = true					-- true: ao inspecionar uma peça, todas serão inspecionadas também, false: precisa inspecionar peça por peça

Config.NitroAmount = 100						-- Quantidade de nitro para cada carga
Config.NitroRechargeTime = 60					-- Tempo de recarga do nitro
Config.NitroRechargeAmount = 5					-- Quantidade de cargas
Config.NitroForce = 2.5							-- Força do nitro
-- Você pode configurar 2 chaves para nitro
Config.NitroKey1 = 19 	-- ALT
Config.NitroKey2 = 210 	-- CTRL

Config.oil = "oil"								-- Índice do óleo configurado em Config.maintenance
-- Config for car services
Config.maintenance = {
	['default'] = { -- default significa que se você não tiver uma configuração para o veículo específico, ele obterá o padrão
		['oil'] = {								-- Índice
			['lifespan'] = 1500,				-- Quantidade de KMs até que o carro precise de serviço
			['damage'] = {
				['type'] = 'engine',			-- Tipo de dano: engine: isso irá danificar o motor do veículo
				['amount_per_km'] = 0.0001,		-- Este é o valor base (em porcentagem) que o carro sofrerá danos a cada km que rodar [a saúde máxima do motor é 1000, portanto, 0,0001 de 1000 é 0,1 | O valor máximo para handling é obtido no arquivo handling.meta do veículo]
				['km_threshold'] = 100,			-- Este é o limite para aumentar o multiplicador, então o multiplicador aumentará cada vez que o jogador passar este km [Defina este valor como 99999 se você não quiser que o multiplicador funcione]
				['multiplier'] = 1.2,			-- Este é o multiplicador de danos, este valor fará com que o carro sofra ainda mais danos após o jogador usar o carro por mais tempo [Este valor não pode ser inferior a 1,0 | Defina este valor como 1,0 se você não quiser que o multiplicador funcione]
				['min'] = 0,					-- Este é o valor mínimo que a saúde da peça pode atingir recebendo dano
				['destroy_engine'] = false		-- Fará com que o carro pare de funcionar se o motor atingir o valor mínimo [aplicável somente quando type = engine]
			},
			['repair_item'] = {
				['name'] = 'oil',				-- Item para fazer o serviço do carro
				['amount'] = 2,					-- Quantidade de itens
				['time'] = 10					-- Tempo de conserto
			},
			['interface'] = {
				['name'] = 'Óleo de motor',					-- Nome na interface
				['icon_color'] = '#ffffff00',				-- Cor de fundo na interface
				['icon'] = 'images/maintenance/oil.png',	-- Imagem
				['description'] = 'Você precisar sempre ter um óleo novo e limpo para manter seu motor funcionando',	-- Descrição
				['index'] = 0								-- Este índice significa que os itens são pedidos na interface, 0 será o primeiro, o 1 ...
			}
		},
		['tires'] = {
			['lifespan'] = 5000,
			['damage'] = {
				['type'] = 'CHandlingData',			-- Isso irá danificar a física do veículo (handling.meta)
				['handId'] = 'fTractionCurveMax',	-- Índice no handling.meta
				['amount_per_km'] = 0.0001,			-- Definindo 0,0001 (em quantidade_por_km), 100 (em limite de km) e 1,2 (em multiplicador), o carro rodará aproximadamente 1,300 km antes de atingir o valor mínimo
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.5
			},
			['repair_item'] = {
				['name'] = 'tires',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Pneus',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/tires.png',
				['description'] = 'Os pneus são usados ​​para manter seu veículo em linha reta, pneus gastos farão seu veículo derrapar mais fácil',
				['index'] = 1
			}
		},
		['brake_pads'] = {
			['lifespan'] = 4000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fBrakeForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'brake_pads',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Pastilha de freio',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/brake_pads.png',
				['description'] = 'As pastilhas de freio são úteis para fazer seu carro parar durante a desaceleração',
				['index'] = 2
			}
		},
		['transmission_oil'] = {
			['lifespan'] = 30000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveMaxFlatVel',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 100.0
			},
			['repair_item'] = {
				['name'] = 'transmission_oil',
				['amount'] = 2,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Óleo de transmissão',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/transmission_oil.png',
				['description'] = 'Você deve manter seu óleo limpo para a sua transmissão funcionar',
				['index'] = 3
			}
		},
		['shock_absorber'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'shock_absorber',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Amortecedor',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/shocks.png',
				['description'] = 'Sua suspensão depende de um bom amortecedor',
				['index'] = 4
			}
		},
		['clutch'] = {
			['lifespan'] = 35000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fClutchChangeRateScaleUpShift',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0.1
			},
			['repair_item'] = {
				['name'] = 'clutch',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Embreagem',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/clutch.png',
				['description'] = 'Velocidade da embreagem em mudanças de marchas',
				['index'] = 5
			}
		},
		['air_filter'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.00005,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = false
			},
			['repair_item'] = {
				['name'] = 'air_filter',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Filtro de ar',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/air_filter.png',
				['description'] = 'Seu motor precisa respirar através de um filtro de ar novo',
				['index'] = 6
			}
		},
		['fuel_filter'] = {
			['lifespan'] = 10000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.00005,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = false
			},
			['repair_item'] = {
				['name'] = 'fuel_filter',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Filtro de combustível',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/fuel_filter.png',
				['description'] = 'O nome já diz bem a função: evitar a passagem de sujeira do tanque do veículo para o motor',
				['index'] = 7
			}
		},
		['spark_plugs'] = {
			['lifespan'] = 15000,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0
			},
			['repair_item'] = {
				['name'] = 'spark_plugs',
				['amount'] = 4,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Velas de ignição',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/spark_plugs.png',
				['description'] = 'As velas são necessárias pra gerar a energia necessária para o motor funcionar corretamente',
				['index'] = 8
			}
		},
		['serpentine_belt'] = {
			['lifespan'] = 20000,
			['damage'] = {
				['type'] = 'engine',
				['amount_per_km'] = 0.001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0,
				['destroy_engine'] = true
			},
			['repair_item'] = {
				['name'] = 'serpentine_belt',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Correia dentada',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/serpentine_belt.png',
				['description'] = 'A correia dentada coordena a abertura e fechamento das válvulas do motor, além do movimento dos pistões no cilindro e virabrequim',
				['index'] = 9
			}
		},
	},
	--[[['panto'] = {	-- Se você habilitar isso, o carro panto terá essas configurações
		['example'] = {
			['lifespan'] = 999,
			['damage'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['amount_per_km'] = 0.0001,
				['km_threshold'] = 100,
				['multiplier'] = 1.2,
				['min'] = 0
			},
			['repair_item'] = {
				['name'] = 'example',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Example',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/maintenance/example.png',
				['description'] = 'Example',
				['index'] = 9
			}
		},
	}]]
}

-- Upgrades availables
Config.upgrades = {
	['default'] = {
		['susp'] = {	-- Index
			['improvements'] = {
				['type'] = 'CHandlingData',			-- CHandlingData: afetará a física do veículo
				['handId'] = 'fSuspensionRaise',	-- O indice no handling.meta
				['value'] = -0.2,					-- Valor que altera
				['fixed_value'] = false				-- Isso significa que se o valor será relativo ou absoluto (fixo)
			},
			['item'] = {
				['name'] = 'susp',					-- Item necessário para atualizar
				['amount'] = 1,						-- Quantidade de itens
				['time'] = 10						-- Tempo
			},
			['interface'] = {
				['name'] = 'Suspensão muito baixa',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp.png',
				['description'] = 'Troca a suspensão por um conjunto extremamente reduzido. Indicado apenas para caminhonetes e veículos altos',
				['index'] = 0
			},
			['class'] = 'suspension'
		},
		['susp1'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = -0.1,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp1',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Suspensão baixa',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp1.png',
				['description'] = 'Instala um jogo de molas curtos para rebaixar o veículo ao extremo. Pode deixar seu veículo instável. Não indicado para veículos baixos',
				['index'] = 1
			},
			['class'] = 'suspension'
		},
		['susp2'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = -0.05,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp2',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Suspensão esportiva',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp2.png',
				['description'] = 'Instala uma mola esportiva para diminuir a altura do veículo. Não indicado para veículos que já são baixos',
				['index'] = 2
			},
			['class'] = 'suspension'
		},
		['susp3'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = 0.1,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp3',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Suspensão confortável',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp3.png',
				['description'] = 'Aumenta levemente a altura da suspensão para dar mais conforto e segurança aos passageiros',
				['index'] = 3
			},
			['class'] = 'suspension'
		},
		['susp4'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fSuspensionRaise',
				['value'] = 0.2,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'susp4',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Suspensão alta',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/susp4.png',
				['description'] = 'Aumenta drásticamente a altura da suspensão para veículos que desejam uma aventura offroad',
				['index'] = 4
			},
			['class'] = 'suspension'
		},

		['garett'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['value'] = 0.04,
				['turbo'] = true,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'garett',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Turbo Garett GTW',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/turbo.png',
				['description'] = 'Instala uma turbina maior para gerar mais pressão e admitir mais ar frio na admissão para o motor, gerando mais potência',
				['index'] = 5
			},
			['class'] = 'turbo'
		},
		['nitrous'] = {
			['improvements'] = {
				['type'] = 'nitrous'	-- Nitro
			},
			['item'] = {
				['name'] = 'nitrous',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Nitro',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/nitrous.png',
				['description'] = 'O nitro aumenta a quantidade de oxigênio que entra nos cilindros do motor. É como se, por alguns segundos, ele expandisse o volume de motor para gerar potência',
				['index'] = 6
			},
			['class'] = 'nitro'
		},
		['AWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 0.5,
				['powered_wheels'] = {0,1,2,3},	-- Se a atualização mudar o fDriveBiasFront, as rodas que receberão potência do veículo também devem ser alteradas
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'AWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversão para AWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/awd.png',
				['description'] = 'Uma tramissão AWD significa que o motor faz girar as 4 rodas do seu veículo',
				['index'] = 7
			},
			['class'] = 'differential'
		},
		['RWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 0.0,
				['powered_wheels'] = {2,3},
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'RWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversão para RWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/rwd.png',
				['description'] = 'Uma tramissão RWD significa que o motor faz girar as 2 rodas traseiras do seu veículo',
				['index'] = 8
			},
			['class'] = 'differential'
		},
		['FWD'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fDriveBiasFront',
				['value'] = 1.0,
				['powered_wheels'] = {0,1},
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'FWD',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Conversão para FWD',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/fwd.png',
				['description'] = 'Uma tramissão FWD significa que o motor faz girar as 2 rodas dianteiras do seu veículo',
				['index'] = 9
			},
			['class'] = 'differential'
		},

		['semislick'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fTractionCurveMax',
				['value'] = 0.4,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'semislick',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Pneus Semi Slick',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/semislick.png',
				['description'] = 'O pneu semi-slick é um pneu homologado para a rua utilizado para explorar plenamente os desempenhos dos veículos',
				['index'] = 10
			},
			['class'] = 'tires'
		},
		['slick'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fTractionCurveMax',
				['value'] = 0.8,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'slick',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Pneus Slick',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/slick.png',
				['description'] = 'Os pneus slick, por serem lisos, possuem maior área de contato com o solo, garantindo assim uma melhor performance',
				['index'] = 11
			},
			['class'] = 'tires'
		},

		['race_brakes'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fBrakeForce',
				['value'] = 2.0,
				['fixed_value'] = false
			},
			['item'] = {
				['name'] = 'race_brakes',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Freios Brembo',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/race_brakes.png',
				['description'] = 'Freios de corrida tem um poder de frenagem muito maior e não sobreaquecem como os freios comuns',
				['index'] = 12
			},
			['class'] = 'brakes'
		},

		['mustangv8'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['sound'] = '2015mustsound',
				['value'] = 0.30,
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'mustangv8',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'Coyote V8',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/mustangv8.png',
				['description'] = 'O coyote é um motor Ford 5.0 V8 que produz 466cv no Mustang Mach 1',
				['index'] = 13
			},
			['class'] = 'engine'
		},
		['k20a'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['sound'] = 'k20a',
				['value'] = 0.20,
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'k20a',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'K20',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/k20a.png',
				['description'] = 'O motor Honda série K é uma linha de motores de carro de quatro cilindros e quatro tempos lançada em 2001.',
				['index'] = 14
			},
			['class'] = 'engine'
		},
		['rb26'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['sound'] = 'rb26dett',
				['value'] = 0.250,
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = 'rb26',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = 'RB26DETT',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/rb26.png',
				['description'] = 'O motor RB26DETT é um motor I6 de 2,6 L (2.568 cc) fabricado pela Nissan, para uso no Nissan Skyline GT-R 1989-2002.',
				['index'] = 15
			},
			['class'] = 'engine'
		},
		['2jz'] = {
			['improvements'] = {
				['type'] = 'CHandlingData',
				['handId'] = 'fInitialDriveForce',
				['sound'] = 'toysupmk4',
				['value'] = 0.250,
				['fixed_value'] = true
			},
			['item'] = {
				['name'] = '2jz',
				['amount'] = 1,
				['time'] = 10
			},
			['interface'] = {
				['name'] = '2JZ-GTE',
				['icon_color'] = '#ffffff00',
				['icon'] = 'images/upgrades/2jz.png',
				['description'] = 'O 2JZ-GTE é um motor biturboalimentado de seis cilindros em linha projetado e fabricado pela Toyota que foi produzido de 1991 a 2002 no Japão.',
				['index'] = 16
			},
			['class'] = 'engine'
		},
	}
}

-- Repair config
Config.repair = {
	['engine'] = {			-- Índice da peça (não mude)
		['items'] = {		-- Itens necessários para reparar a peça
			['piston'] = 4,
			['rod'] = 4,
			['oil'] = 3
		},
		['time'] = 10,		-- Tempo para reparar
		['repair'] = {		-- Os índices do handling.meta que voltarão ao padrão
			"fInitialDriveForce",
		}
	},
	['transmission'] = {
		['items'] = {
			['gear'] = 5,
			['transmission_oil'] = 2
		},
		['time'] = 10,
		['repair'] = {
			"fClutchChangeRateScaleUpShift"
		}
	},
	['chassis'] = {
		['items'] = {
			['iron'] = 10,
			['aluminum'] = 2
		},
		['time'] = 10,
		['repair'] = {
		}
	},
	['brakes'] = {
		['items'] = {
			['brake_discs'] = 4,
			['brake_pads'] = 4,
			['brake_caliper'] = 2
		},
		['time'] = 10,
		['repair'] = {
			"fBrakeForce"
		}
	},
	['suspension'] = {
		['items'] = {
			['shock_absorber'] = 4,
			['springs'] = 4
		},
		['time'] = 10,
		['repair'] = {
			"fTractionCurveMax",
			"fSuspensionForce"
		}
	}
}

Config.infoTextsPage = {
	[1] = {
		['icon'] = "images/info.png",
		['title'] = "Informações Básicas",
		['text'] = "Este é o painel de manutenção de veículos. Você precisa cuidar do seu veículo para que ele se mantenha em boas condições para uso. Existem diversos itens de manutenção a serem feitos a cada X KM, por exemplo, o óleo de motor precisa ser trocado a cada 1500 Kms ou seu motor comecará a se danificar. As demais revisões precisam ser feitas a um KM mais alta, leve o veículo a um mecânico para que ele possa lhe informar a vida útil das peças do seu veículo."
	},
	[2] = {
		['icon'] = "images/services.png",
		['title'] = "Como realizar as revisões",
		['text'] = "Você precisa realizar as manutenções preventivas no tempo correto, para isto, basta levar o veículo a um mecânico de confiança. Ele poderá scanear as peças do seu carro e após passar o scanner ele terá as informações atualizadas de cada peça que precisa ser trocada."
	},
	[3] = {
		['icon'] = "images/repair.png",
		['title'] = "Reparos",
		['text'] = "A aba de reparos é usada quando alguma peça do seu veículo está com perda de desempenho, isto acontece quando as manutenções não são feitas na data esperada. Os reparos são caros e precisam ser feitos, pois peças denificadas prejudicam gravemente a performance do seu veículo, portanto não deixe de fazer nenhuma manutenção."
	},
	[4] = {
		['icon'] = "images/performance.png",
		['title'] = "Upgrades",
		['text'] = "Caso você queira apimentar a experiência com o seu veículo você pode instalar algumas peças de performance nele, mas <b>CUIDADO!!</b> As peças de performance são extremamente poderosas e mexem diretamente na física do seu veículo, portanto você deve escolher com sabedoria qual peça instalar ou seu veículo pode se tornar instável ou até mesmo capotar. A mecânica não se responsabiliza por upgrades inadequados."
	}
}
Config.createTable = true