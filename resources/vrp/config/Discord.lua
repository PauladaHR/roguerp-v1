-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORD
-----------------------------------------------------------------------------------------------------------------------------------------
local Discord = {
	["Police"] = "https://discordapp.com/api/webhooks/1014933768668192768/bw_yEwTlTjAZUHVC6PbddvcmHoNOY20oXAysk3yQGcdyJiKetEkA8sJrqtDXwJC-RhHW",
	["Paramedic"] = "https://discord.com/api/webhooks/1018708563620810874/3YYjBmWOhkGMeEvG8zVL81sKlkinDtqJEG11Xw6oyq0cww9TUv0kZzwgUNhujs2pP5t9",
	["Barragem"] = "https://discord.com/api/webhooks/1021079548789538929/1zBDE32Z6PBqMDucPGcYz_eSTSU5tnsBG3uJBI_vYBH8FWWsy3G6SWHGbev4ABuP4p5U",
	["Cupim"] = "https://discord.com/api/webhooks/1021079608717750293/MPggupDrpUwljId1yYaXirOqI3sYjhGgErmJO7XxY_COQY15dkG_tETlBiJyQbmhY--z",
	["Helipa"] = "https://discord.com/api/webhooks/1021079644948135957/0wQ5dIi_bXJE5buorL2YsFubswSNxivM5v02FhiULhQpGYGlAjV8RypBgeZLu4F6AwLF",
	["catCoffe"] = "https://discord.com/api/webhooks/1021079687017021480/KyuwvJCHOAlRNpIvrWhItoDpd5bBCqGOn34iUW1mbsclH0pja92hF3EBTvyQfxZL26l7",
	["coolBeans"] = "https://discord.com/api/webhooks/1021079721397719100/VHKMu3SYVJc7G9umkQR0Gl6tiwHfDbTc5ZGzt4aX3bKPtHi0e0p0hMDW8qdNquSZIzGI",
	["Pearls"] = "https://discord.com/api/webhooks/1023302248798896299/17eBC_x5wAZvYYeGKtuzyTyIZRBBr1xbGE2_qKRH8ItwlizLUjPMjhhvlalGOjDPfwGH",
	["Lavagem01"] = "https://discord.com/api/webhooks/1021079752875974706/gnDWHJkHGS9P8SE98dqFD9kUEJBN1Fn2qegmIi9MBug4Zcz2QHaRXkNENKFjCDmEIJ3F",
	["Lavagem02"] = "https://discordapp.com/api/webhooks/1021079784933032057/35KDzV2vhoPdU0QGObfT_CEDTRUYYeQwzvzFougkPmHYcVz6YrQmwsQJ2rg0sHlGmWOe",
	-- ["Lavagem03"] = "https://discord.com/api/webhooks/1023301888021643330/3yF_W05Hak87biasPq1N8xNO8egJKRYXLAo8ElNwOzaNa5U3WjMkha2OpuLVbm2p8e3r",
	["Arma01"] = "https://discord.com/api/webhooks/1021079893582286938/z0gAndhshA2bF3mFHpoagX2wI3ewvYxzHoZvZt_umxOdr5i1UX8kLe8rXZq-StGNJ3s5",
	["Arma02"] = "https://discord.com/api/webhooks/1021079928365662239/uo7qznDcMZXsrVtXV_i6B7JDlwomlVbpGjMEBqwvA8xLq6cEH_rGGMusbEQm-uk-5IaG",
	["Arma03"] = "https://discord.com/api/webhooks/1023301730185773077/WkxHx9xzHWWFv2d7Da69tWrvz40luuWUC2cTB-s5WNwGwgjmybL2FtusmH9HQ2BJHYjF",
	["Municao01"] = "https://discord.com/api/webhooks/1021079820983083160/qj_2VFd_NYfoeDVCCqYcbnxwHTR_CsUwjR_GpokUj1wxx9I5iY94ioYvlah9TIvThL2P",
	["Municao02"] = "https://discord.com/api/webhooks/1021079862888378378/FCZ2buv7MXUOdf9Le-IK36pHKgxEDzkPYnwgLom8I02dPZRo1rGRsQjjUfrAPMsn8Irk",
	["CasaLago"] = "https://discord.com/api/webhooks/1023302047581352067/ISyJvcQuDYk1HkWxOOVLp5YjMV0qZ9y3G1ptK1ArrNW-EKYUZzT1T0i_jv89lI0Y9yK_",
	["Homes"] = "https://discord.com/api/webhooks/1026547242410180759/yYQHi3xpOodR8cymZ5AcNcCzAO3RAGhZFdx0lmnZ1jA80Fb6gadIeDC6D0d7Mz-a2Zok"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCORDLOGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("discordLogs")
AddEventHandler("discordLogs",function(webhook,message,color)
	PerformHttpRequest(Discord[webhook],function(err,text,headers) end,"POST",json.encode({
		username = "Hiro Logs",
		embeds = { { color = color, description = message } }
	}),{ ["Content-Type"] = "application/json" })
end)