fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

shared_scripts {
	"@vrp/lib/utils.lua",
	"@vrp/config/Native.lua"
}

client_scripts {
	"client-side/*"
}

server_scripts {
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}                                                                                    