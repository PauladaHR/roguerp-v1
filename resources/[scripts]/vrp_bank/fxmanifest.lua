--shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"


fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

files {
	"web-side/*",
	"web-side/**/*",
	"web-side/**/**/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"client-side/*",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config.lua",
	"server-side/*",
}                                                                                                  