local suggestions = {
	{
		command = "/debug",
		desc = "Recarrega todas as configurações do personagem."
	},{
		command = "/vehs",
		desc = "Visualiza todos os seus veículos."
	},{
		command = "/trancar",
		desc = "Tranca/Destranca a porta de sua residência."
	},{
		command = "/limbo",
		desc = "Reaparecer o personagem na rua mais próxima."
	},{
		command = "/entrar",
		desc = "Entra em sua residência."
	},{
		command = "/hud",
		desc = "Mostra/Esconde a interface na tela."
	},{
		command = "/movie",
		desc = "Mostra/Esconde a interface de video na tela."
	},{
		command = "/fps",
		desc = "Liga/Desliga boost de fps."
	},{
		command = "/garmas",
		desc = "Guardar o armamento equipado na mochila."
	},{
		command = "/wecolor",
		desc = "Mudar a pintura do armamento em suas mãos."
	},{
		command = "/welux",
		desc = "Mudar a pintura do armamento em suas mãos."
	},{
		command = "/premium",
		desc = "Visualiza todas as informações do premium."
	},{
		command = "/pd",
		desc = "Chat de conversa da policia.",
		perm = "Police"
	},{
		command = "/placa",
		desc = "Visualiza a placa de um veículo.",
		perm = "Police"
	},{
		command = "/detido",
		desc = "Apreende o veículo mais próximo.",
		perm = "Police"
	},{
		command = "/servico",
		desc = "Entra/Sair de serviço.",
		perm = "Police"
	},{
		command = "/servico",
		desc = "Entra/Sair de serviço.",
		perm = "Paramedic"
	},{
		command = "/c",
		desc = "Carregar a pessoa mais próxima.",
		perm = "Police"
	},{
		command = "/c",
		desc = "Carregar a pessoa mais próxima.",
		perm = "Paramedic"
	},{
		command = "/c2",
		desc = "Carregar a pessoa mais próxima.",
		perm = "Police"
	},{
		command = "/c2",
		desc = "Carregar a pessoa mais próxima.",
		perm = "Paramedic"
	},{
		command = "/rv",
		desc = "Retirar a pessoa mais próxima do veículo.",
		perm = "Police"
	},{
		command = "/rv",
		desc = "Retirar a pessoa mais próxima do veículo.",
		perm = "Paramedic"
	},{
		command = "/cv",
		desc = "Colocar a pessoa mais próxima no veículo.",
		params = {
			{ name = "local", help = "Banco que a pessoa vai sentar" }
		}
	},{
		command = "/id",
		desc = "Visualiza a identidade da pessoa mais próxima.",
		perm = "Police"
	},{
		command = "/comprar",
		desc = "Utilizado em algumas maquinas de compra."
	},{
		command = "/me",
		desc = "Ativar uma animação não existente."
	},{
		command = "/mascara",
		desc = "Colocar/Retirar uma máscara."
	},{
		command = "/chapeu",
		desc = "Colocar/Retirar um chapéu."
	},{
		command = "/oculos",
		desc = "Colocar/Retirar um óculos."
	},{
		command = "/preset",
		desc = "Coloca uma das roupas predefinidas.",
		params = {
			{ name = "número", help = "De 1 a 5" }
		},
		perm = "Police"
	},{
		command = "/preset",
		desc = "Coloca uma das roupas predefinidas.",
		params = {
			{ name = "número", help = "De 1 a 3" }
		},
		perm = "Paramedic"
	},{
		command = "/preset",
		desc = "Coloca uma das roupas predefinidas.",
		params = {
			{ name = "número", help = "De 1 a 2" }
		},
		perm = "Mechanic"
	},{
		command = "/outfit",
		desc = "Coloca a sua roupa salva.",
		params = {
			{ name = "opção", help = "salvar / aplicar" }
		}
	},{
		command = "/premiumfit",
		desc = "Coloca a sua roupa salva.",
		params = {
			{ name = "opção", help = "salvar / aplicar" }
		}
	},{
		command = "/trunkin",
		desc = "Entra no porta-malas do veículo mais próximo."
	},{
		command = "/checktrunk",
		desc = "Verifica o porta-malas do veículo mais próximo."
	},{
		command = "/procurado",
		desc = "Visualiza seu tempo de procurado."
	},{
		command = "/repouso",
		desc = "Visualiza seu tempo de repouso."
	},{
		command = "/volume",
		desc = "Muda o volume do rádio.",
		params = {
			{ name = "número", help = "De 0 a 100 - Padrão: 30" }
		}
	},{
		command = "/seat",
		desc = "Muda de banco no veículo.",
		params = {
			{ name = "número", help = "De 1 a 6" }
		}
	},{
		command = "/re",
		desc = "Reanimar a pessoa mais próxima.",
		perm = "Police"
	},{
		command = "/re",
		desc = "Reanimar a pessoa mais próxima.",
		perm = "Paramedic"
	},{
		command = "/trunk",
		desc = "Abrir o porta-malas do veículo mais próximo."
	},{
		command = "/yp",
		desc = "Abrir a Yellow Pages."
	},{
		command = "/desmanche",
		desc = "Visualizar a lista de veículos do desmanche."
	},{
		command = "/motorista",
		desc = "Inicia/Termina o emprego de motorista."
	},{
		command = "/chat",
		desc = "Ativa/Desativa o chat."
	},{
		command = "/tow",
		desc = "Coloca/Retira um veículo no reboque.",
		perm = "Mechanic"
	},{
		command = "/entregador",
		desc = "Inicia/Termina o emprego de entregador."
	},{
		command = "/lenhador",
		desc = "Inicia/Termina o emprego de lenhador."
	},{
		command = "/lixeiro",
		desc = "Inicia/Termina o emprego de lixeiro."
	},{
		command = "/transportador",
		desc = "Inicia/Termina o emprego de transportador."
	},{
		command = "/impound",
		desc = "Registra um veículo no reboque.",
		perm = "Police"
	},{
		command = "/onduty",
		desc = "Visualiza todos os policiais em serviço.",
		perm = "Police"
	},{
		command = "/onduty",
		desc = "Visualiza todos os paramédicos em serviço.",
		perm = "Paramedic"
	},{
		command = "/prender",
		desc = "Prender uma pessoa.",
		perm = "Police"
	},{
		command = "/rprender",
		desc = "Diminuir tempo de prisão de uma pessoa.",
		perm = "Police"
	},{
		command = "/multar",
		desc = "Multar uma pessoa.",
		perm = "Police"
	},{
		command = "/cam",
		desc = "Visualiza uma câmera escolhida.",
		params = {
			{ name = "número", help = "Número da câmera" }
		},
		perm = "Police"
	},{
		command = "/setrepose",
		desc = "Adiciona o repouso na pessoa mais próxima.",
		params = {
			{ name = "minutos", help = "Quantidade de minutos." }
		},
		perm = "Paramedic"
	},{
		command = "/hr",
		desc = "Chat de conversa dos paramédicos.",
		perm = "Paramedic"
	},{
		command = "/livery",
		desc = "Muda a livery do veículo.",
		perm = "Police"
	},{
		command = "/fatura",
		desc = "Cria uma fatura para uma pessoa desejada."
	},{
		command = "/garagem",
		desc = "Comprar uma vaga de garagem."
	},{
		command = "/andar",
		desc = "Muda o estilo de andar.",
		params = {
			{ name = "número", help = "De 1 a 59" }
		}
	},{
		command = "/e",
		desc = "Inicia uma animação a sua escolha.",
		params = {
			{ name = "nome", help = "Nome da animação" }
		}
	},{
		command = "/e2",
		desc = "Inicia uma animação a sua escolha.",
		params = {
			{ name = "nome", help = "Nome da animação" }
		},
		perm = "Paramedic"
	},{
		command = "/revistar",
		desc = "Revista a pessoa mais próxima.",
		perm = "Police"
	},{
		command = "/invadir",
		desc = "Invadir uma residência.",
		perm = "Police"
	},{
		command = "/dna",
		desc = "Inicia o teste de dna no microscopio do hospital.",
		params = {
			{ name = "tipo", help = "Tipo do DNA" },
			{ name = "valor", help = "Valor do DNA" }
		},
		perm = "Paramedic"
	}
}

AddEventHandler("vRP:playerSpawn",function(user_id,source)
	local __suggestions__ = {}
	for _,v in pairs(suggestions) do
		if v.perm and vRP.hasPermission(user_id,v.perm) or v.perm == nil then
			table.insert(__suggestions__,{
				name = v.command,
				help = v.desc or nil,
				params = v.params or nil
			})
		end
	end
	TriggerClientEvent('chat:addSuggestion',source,__suggestions__)
end)

AddEventHandler("chat:addedGroup",function(user_id)
	local source = vRP.getUserSource(user_id)
	if source then
		local __suggestions__ = {}
		TriggerClientEvent("chat:clearSuggestions",source)
		for _,v in pairs(suggestions) do
			if v.perm and vRP.hasPermission(user_id,v.perm) or v.perm == nil then
				table.insert(__suggestions__, {
					name = v.command,
					help = v.desc or nil,
					params = v.params or nil
				})
			end
		end
		TriggerClientEvent('chat:addSuggestion',source,__suggestions__)
	end
end)