shared_script "lib/lib.lua"

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "gui/index.html"

shared_scripts {
	"lib/utils.lua",
}

server_scripts {
	"config/Discord.lua",
	"config/Module.lua",
	"modules/*"
}

client_scripts {
	"config/Native.lua",
	"client/*"
}

files {
	"lib/*",
	"gui/*",
	"loading/*"
}              

loadscreen "loading/index.html"
loadscreen_manual_shutdown "true"