local blips = {}
local blipFile = "blips.json"

local function loadBlipsFromFile()
    local resourceName = GetCurrentResourceName()
    local fileContent = LoadResourceFile(resourceName, blipFile)
    if fileContent then
        blips = json.decode(fileContent)
        print("Blips loaded from file.")
    else
        print("Failed to load blips from file.")
    end
end

local function saveBlipsToFile()
    local resourceName = GetCurrentResourceName()
    SaveResourceFile(resourceName, blipFile, json.encode(blips), -1)
    print("Blips saved to file.")
end

local function sendBlipsToClient(playerId)
    TriggerClientEvent('es-blips:client:loadBlips', playerId, blips)
end

local function sendBlipsToAllClients()
    for _, playerId in ipairs(GetPlayers()) do
        sendBlipsToClient(playerId)
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(2500)
    loadBlipsFromFile()
    sendBlipsToAllClients()
end)

AddEventHandler('playerConnecting', function()
    local playerId = source
    Citizen.Wait(5000) 
    sendBlipsToClient(playerId)
end)

AddEventHandler('esx:playerLoaded', function(playerId)
    sendBlipsToClient(playerId)
end)

RegisterNetEvent('QBCore:Server:PlayerLoaded', function()
    local playerId = source
    sendBlipsToClient(playerId)
end)

RegisterNetEvent('es-blips:server:createBlip')
AddEventHandler('es-blips:server:createBlip', function(blipData)
    for _, blip in ipairs(blips) do
        if blip.name == blipData.name and blip.coords.x == blipData.coords.x and blip.coords.y == blipData.coords.y and blip.coords.z == blipData.coords.z then
            print("Blip already exists:", blipData.name)
            return
        end
    end
    
    table.insert(blips, blipData)
    saveBlipsToFile()
    TriggerClientEvent('es-blips:client:createBlip', -1, blipData)
end)

RegisterNetEvent('es-blips:server:saveBlips')
AddEventHandler('es-blips:server:saveBlips', function(clientBlips)
    blips = clientBlips
    saveBlipsToFile()
end)

RegisterNetEvent('es-blips:server:updateBlip')
AddEventHandler('es-blips:server:updateBlip', function(clientBlips)
    blips = clientBlips
    saveBlipsToFile()
end)
