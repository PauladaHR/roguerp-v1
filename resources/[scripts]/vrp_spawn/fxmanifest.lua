-- shared_script "@vrp/lib/lib.lua" -- Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version "bodacious"
game "gta5"

ui_page "src/nui/index.html"
files {
	"src/nui/**"
}

shared_script "@vrp/lib/utils.lua"
client_script "src/client.lua"
server_script "src/server.lua"
                                                                                                                