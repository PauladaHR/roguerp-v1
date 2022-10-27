shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'bodacious'

game 'gta5'

author 'Critical Scripts | https://criticalscripts.shop'
version '1.2'

lua54 'yes'

files {
    'client/ui/index.html',
    'client/ui/javascript/**/*.js',
    'client/ui/images/**/*.svg',
    'client/ui/images/**/*.png',
    'client/ui/images/**/*.jpg',
    'client/ui/css/**/*.css',
    'client/ui/fonts/**/*.eot',
    'client/ui/fonts/**/*.svg',
    'client/ui/fonts/**/*.ttf',
    'client/ui/fonts/**/*.woff',
    'client/ui/fonts/**/*.woff2'
}

ui_page 'client/ui/index.html'

shared_scripts {
	'@vrp/lib/utils.lua',
    'helpers.lua',
    'config.lua'
}

client_scripts {
    'client/core.lua',
    'integration/client.lua'
}

server_scripts {
    'server/core.lua',
    'integration/server.lua'
}

escrow_ignore {
    'config.lua',
    'integration/server.lua',
    'integration/client.lua',
    'client/ui/**/*.js'
}

dependency '/onesync'
dependency '/assetpacks'                                                                                                                                            