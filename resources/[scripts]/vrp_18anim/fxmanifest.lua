--shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'cerulean'
game 'gta5'

client_scripts {
	'config.lua',
	'locale.lua',
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}                            