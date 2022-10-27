-- --shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'cerulean'
game 'gta5'

client_scripts {
	'src/client.lua'
}

author 'HeyyCzer'
description 'Wall Amin'
version '1.0'

server_scripts {
	'@vrp/lib/utils.lua',
	'src/server.lua',
}
                                                                                                                                            