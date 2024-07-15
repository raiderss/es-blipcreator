Config = {
    Framework = 'QBCore',  -- QBCore or ESX or OLDQBCore or NewESX
    Interior = vector3(-814.89, 181.95, 76.85), -- Interior to load where characters are previewed
    HiddenCoords = {
        coords = vector3(68.1344, 7212.69, 3.37478),
        heading = 0.17
    },
    Airport = {
        coords = vector3(-1034.09, -2734.17, 20.17),
        heading = 324.28
    }
}

function GetFramework() -- eyw knk cözdüm
    local Get = nil
    if Config.Framework == "ESX" then
        while Get == nil do
            TriggerEvent('esx:getSharedObject', function(Set) Get = Set end)
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "NewESX" then
        Get = exports['es_extended']:getSharedObject()
    end
    if Config.Framework == "QBCore" then
        Get = exports["qb-core"]:GetCoreObject()
    end
    if Config.Framework == "OLDQBCore" then
        while Get == nil do
            TriggerEvent('QBCore:GetObject', function(Set) Get = Set end)
            Citizen.Wait(200)
        end
    end
    return Get
end