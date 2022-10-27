shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version "cerulean"
game "gta5"

dependencies {
    "NativeUI"
}

client_scripts {
    '@NativeUI/NativeUI.lua',
	"@vrp/lib/utils.lua",
    'config.lua',
	"client-side/*" 
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/*"
}
                                                        