fx_version "adamant"
description "EyesStore"
author "Raider#0101"
version '1.0.0'
repository 'https://discord.com/invite/EkwWvFS'

game "gta5"

client_script { 
    "client/*.lua"
}

server_script {
    "server/*.lua",
}

dependencies {
    'qb-core',
    'qb-menu',
    'qb-input'
}

lua54 'yes'
-- dependency '/assetpacks'