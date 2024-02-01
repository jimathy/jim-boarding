name "jim-skateboard"
author "Jimathy"
version "2.0.1"
description "Electric Skateboard Script By Jimathy"
fx_version "cerulean"
game "gta5"
lua54 'yes'

shared_scripts {
    'locales/*.lua',
    'config.lua',
    -- Required core scripts
    '@ox_lib/init.lua',
    '@ox_core/imports/client.lua',
    '@es_extended/imports.lua',
    '@qbx_core/modules/playerdata.lua',

    --Jim Bridge
    '@jim_bridge/exports.lua',
    '@jim_bridge/functions.lua',
    '@jim_bridge/wrapper.lua',
    '@jim_bridge/crafting.lua',
}
client_script 'client.lua'
server_script 'server.lua'

dependancy 'jim_bridge'