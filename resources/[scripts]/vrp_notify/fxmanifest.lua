shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version "adamant"

game "gta5"

files {
	"src/nui/**"
}

ui_page "src/nui/ui.html"

client_script "src/client.lua"
                                                                      