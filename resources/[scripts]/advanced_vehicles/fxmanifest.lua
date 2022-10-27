shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'adamant'

game 'gta5'

ui_page 'nui/index.html'

files {
	'nui/lang/*',
	'nui/font/*',
	'nui/images/*',
	'nui/images/repair/*',
	'nui/images/maintenance/*',
	'nui/images/upgrades/*',
	'nui/jquery-3.5.1.min.js',
	'nui/animations.css',
	'nui/style.css',
	'nui/index.html',
	'nui/script.js',
	"audio/*",
	"audio/**/*"
}

client_scripts{
	'@vrp/lib/utils.lua',
	'lang/*.lua',
	
	'config.lua',
	'utils.lua',
	'client.lua',
}

server_scripts{
	'@mysql-async/lib/MySQL.lua',
	'@vrp/lib/utils.lua',

	'lang/*.lua',
	'config.lua',
	'server_utils.lua',
	'server.lua',
}                                                        