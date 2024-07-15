local blips = {}

local blipIcons = {
    { label = "Standard", value = 1 },
    { label = "Big Circle", value = 2 },
    { label = "Small Circle", value = 3 },
    { label = "Police Officer", value = 4 },
    { label = "Police Area", value = 5 },
    { label = "Square", value = 6 },
    { label = "Player Position", value = 7 },
    { label = "North", value = 8 },
    { label = "Waypoint", value = 9 },
    { label = "Big Circle Outline", value = 10 },
    { label = "Arrow Up Outline", value = 11 },
    { label = "Arrow Down Outline", value = 12 },
    { label = "Arrow Up", value = 13 },
    { label = "Arrow Down", value = 14 },
    { label = "Police Helicopter", value = 15 },
    { label = "Chat Bubble", value = 16 },
    { label = "Garage", value = 17 },
    { label = "Drugs", value = 18 },
    { label = "Store", value = 19 },
    { label = "Weapon", value = 21 },
    { label = "Hospital", value = 22 },
    { label = "Star", value = 23 },
    { label = "Flag", value = 24 },
    { label = "Helicopter", value = 43 },
    { label = "Boat", value = 427 },
    { label = "Parachute", value = 251 },
    { label = "Motorcycle", value = 226 },
    { label = "Bike", value = 348 },
    { label = "Car", value = 225 },
    { label = "Truck", value = 477 },
    { label = "Car Wash", value = 100 },
    { label = "Clothing Store", value = 73 },
    { label = "Barber Shop", value = 71 },
    { label = "Tattoo Shop", value = 75 },
    { label = "Bank", value = 108 },
    { label = "ATM", value = 277 },
    { label = "Restaurant", value = 52 },
    { label = "Fire Station", value = 60 },
    { label = "Prison", value = 237 },
    { label = "Airport", value = 90 },
    { label = "Gas Station", value = 361 },
    { label = "Bar", value = 93 },
    { label = "Amusement Park", value = 102 },
    { label = "Cinema", value = 135 },
    { label = "Museum", value = 136 },
    { label = "Theater", value = 137 },
    { label = "Park", value = 160 },
    { label = "Hotel", value = 475 },
    { label = "Bus Station", value = 513 },
    { label = "Train Station", value = 515 },
    { label = "Subway Station", value = 512 },
    { label = "School", value = 430 },
    { label = "College", value = 431 },
    { label = "University", value = 432 },
    { label = "Library", value = 433 },
    { label = "Church", value = 304 },
    { label = "Mosque", value = 305 },
    { label = "Temple", value = 306 },
    { label = "Synagogue", value = 307 },
    { label = "Hospital", value = 61 },
    { label = "Clinic", value = 362 },
    { label = "Pharmacy", value = 363 },
    { label = "Dental Clinic", value = 364 },
    { label = "Veterinary Clinic", value = 365 },
    { label = "Police Station", value = 60 },
    { label = "Ambulance Station", value = 74 },
    { label = "Fire Station", value = 59 },
    { label = "Government Building", value = 304 },
    { label = "Court", value = 305 },
    { label = "City Hall", value = 306 },
    { label = "Library", value = 307 },
    { label = "School", value = 430 },
    { label = "College", value = 431 },
    { label = "University", value = 432 },
    { label = "Library", value = 433 },
}

local blipColors = {
    { label = "White", value = 0 },
    { label = "Red", value = 1 },
    { label = "Green", value = 2 },
    { label = "Blue", value = 3 },
    { label = "Yellow", value = 5 },
    { label = "Purple", value = 7 },
    { label = "Orange", value = 17 },
    { label = "Dark Red", value = 76 },
    { label = "Pink", value = 24 },
    { label = "Gray", value = 3 },
    { label = "Dark Purple", value = 83 },
    { label = "Dark Green", value = 52 },
    { label = "Dark Blue", value = 26 },
    { label = "Light Blue", value = 4 },
    { label = "Light Green", value = 30 },
    { label = "Dark Yellow", value = 35 },
    { label = "Light Red", value = 6 },
    { label = "Light Orange", value = 8 },
    { label = "Dark Orange", value = 9 },
    { label = "Gold", value = 46 },
    { label = "Silver", value = 47 },
    { label = "Bronze", value = 48 },
    { label = "Dark Brown", value = 49 },
    { label = "Light Brown", value = 50 },
    { label = "Dark Gray", value = 51 },
    { label = "Light Gray", value = 52 },
    { label = "Dark Pink", value = 84 },
    { label = "Light Pink", value = 85 },
}

local function openBlipMenu(header, isMenuHeader, params)
    return {
        header = header,
        isMenuHeader = isMenuHeader or false,
        params = params or {}
    }
end

RegisterCommand('createblip', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    exports['qb-menu']:openMenu({
        openBlipMenu("Blip Manager", true),
        openBlipMenu("Create Blip", false, { event = 'es-blips:client:openInput', args = { coords = coords } }),
        openBlipMenu("Edit Blips", false, { event = 'es-blips:client:editBlips' }),
        openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' })
    })
end, false)

RegisterKeyMapping('createblip', 'Open Blip Manager', 'keyboard', 'F7')

RegisterNetEvent('es-blips:client:openInput', function(data)
    local dialog = {
        { type = "text", name = "blipName", label = "Blip Name", default = "Blip Name" }
    }

    local input = exports['qb-input']:ShowInput({
        header = "Enter Blip Details",
        submitText = "Next",
        inputs = dialog
    })

    if input and input.blipName then
        local blipName = input.blipName

        local blipIconMenu = {
            openBlipMenu("Custom Icon", false, { event = 'es-blips:client:customIcon', args = { name = blipName, coords = data.coords } }),
            openBlipMenu("Select Blip Icon", true)
        }

        for _, icon in ipairs(blipIcons) do
            table.insert(blipIconMenu, openBlipMenu(icon.label, false, { event = 'es-blips:client:selectIcon', args = { name = blipName, coords = data.coords, icon = icon.value } }))
        end

        table.insert(blipIconMenu, openBlipMenu("Back", false, { event = 'es-blips:client:openInput', args = data }))
        table.insert(blipIconMenu, openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' }))

        exports['qb-menu']:openMenu(blipIconMenu)
    end
end)

RegisterNetEvent('es-blips:client:customIcon', function(data)
    local dialog = {
        { type = "number", name = "customIcon", label = "Enter Custom Icon ID", default = "" }
    }
    local input = exports['qb-input']:ShowInput({
        header = "Enter Custom Icon ID",
        submitText = "Next",
        inputs = dialog
    })
    if input and input.customIcon then
        data.icon = tonumber(input.customIcon) 
        TriggerEvent('es-blips:client:selectIcon', data)
    end
end)

RegisterNetEvent('es-blips:client:selectIcon', function(data)
    local blipColorMenu = {
        openBlipMenu("Custom Color", false, { event = 'es-blips:client:customColor', args = data }),
        openBlipMenu("Select Blip Color", true)
    }
    for _, color in ipairs(blipColors) do
        table.insert(blipColorMenu, openBlipMenu(color.label, false, { event = 'es-blips:client:createBlip', args = { name = data.name, coords = data.coords, icon = data.icon, color = color.value } }))
    end
    table.insert(blipColorMenu, openBlipMenu("Back", false, { event = 'es-blips:client:selectIcon', args = data }))
    table.insert(blipColorMenu, openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' }))
    exports['qb-menu']:openMenu(blipColorMenu)
end)

RegisterNetEvent('es-blips:client:customColor', function(data)
    local dialog = {
        { type = "number", name = "customColor", label = "Enter Custom Color ID", default = "" }
    }

    local input = exports['qb-input']:ShowInput({
        header = "Enter Custom Color ID",
        submitText = "Next",
        inputs = dialog
    })

    if input and input.customColor then
        data.color = tonumber(input.customColor) 
        TriggerEvent('es-blips:client:createBlip', data)
    end
end)

RegisterNetEvent('es-blips:client:createBlip', function(data)
    local blipName = data.name
    local blipCoords = data.coords
    local blipIcon = data.icon
    local blipColor = data.color
    local blip = AddBlipForCoord(blipCoords.x, blipCoords.y, blipCoords.z)
    SetBlipSprite(blip, blipIcon)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, blipColor)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(blipName)
    EndTextCommandSetBlipName(blip)

    table.insert(blips, { blip = blip, name = blipName, coords = blipCoords, icon = blipIcon, color = blipColor })
    TriggerServerEvent('es-blips:server:saveBlips', blips)
end)

RegisterNetEvent('es-blips:client:loadBlips', function(serverBlips)
    for _, blipData in ipairs(serverBlips) do
        local blip = AddBlipForCoord(blipData.coords.x, blipData.coords.y, blipData.coords.z)
        SetBlipSprite(blip, blipData.icon or 1)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, blipData.color or 2)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(blipData.name)
        EndTextCommandSetBlipName(blip)

        table.insert(blips, { blip = blip, name = blipData.name, coords = blipData.coords, icon = blipData.icon, color = blipData.color })
    end
end)

RegisterNetEvent('es-blips:client:editBlips', function()
    local menu = {
        openBlipMenu("Edit Blips", true)
    }

    for i, blipData in ipairs(blips) do
        table.insert(menu, openBlipMenu(blipData.name, false, { event = 'es-blips:client:manageBlip', args = { index = i, blipData = blipData } }))
    end

    table.insert(menu, openBlipMenu("Back", false, { event = 'createblip' }))
    table.insert(menu, openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' }))

    exports['qb-menu']:openMenu(menu)
end)

RegisterNetEvent('es-blips:client:manageBlip', function(data)
    local blipData = data.blipData
    local index = data.index

    exports['qb-menu']:openMenu({
        openBlipMenu("Manage Blip - " .. blipData.name, true),
        openBlipMenu("Change Icon", false, { event = 'es-blips:client:changeIcon', args = { index = index, name = blipData.name, coords = blipData.coords } }),
        openBlipMenu("Change Color", false, { event = 'es-blips:client:changeColor', args = { index = index, name = blipData.name, coords = blipData.coords } }),
        openBlipMenu("Delete Blip", false, { event = 'es-blips:client:deleteBlip', args = { index = index } }),
        openBlipMenu("Back", false, { event = 'es-blips:client:editBlips' }),
        openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' })
    })
end)

RegisterNetEvent('es-blips:client:changeIcon', function(data)
    local blipIconMenu = {
        openBlipMenu("Custom Icon", false, { event = 'es-blips:client:customIcon', args = data }),
        openBlipMenu("Select Blip Icon", true)
    }
    for _, icon in ipairs(blipIcons) do
        table.insert(blipIconMenu, openBlipMenu(icon.label, false, { event = 'es-blips:client:updateIcon', args = { index = data.index, icon = icon.value, name = data.name, coords = data.coords } }))
    end
    table.insert(blipIconMenu, openBlipMenu("Back", false, { event = 'es-blips:client:manageBlip', args = data }))
    table.insert(blipIconMenu, openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' }))
    exports['qb-menu']:openMenu(blipIconMenu)
end)

RegisterNetEvent('es-blips:client:updateIcon', function(data)
    local blip = blips[data.index].blip
    SetBlipSprite(blip, data.icon)
    blips[data.index].icon = data.icon
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(data.name)
    EndTextCommandSetBlipName(blip)

    TriggerServerEvent('es-blips:server:updateBlip', blips)
end)

RegisterNetEvent('es-blips:client:changeColor', function(data)
    local blipColorMenu = {
        openBlipMenu("Custom Color", false, { event = 'es-blips:client:customColor', args = data }),
        openBlipMenu("Select Blip Color", true)
    }
    for _, color in ipairs(blipColors) do
        table.insert(blipColorMenu, openBlipMenu(color.label, false, { event = 'es-blips:client:updateColor', args = { index = data.index, color = color.value, name = data.name, coords = data.coords } }))
    end
    table.insert(blipColorMenu, openBlipMenu("Back", false, { event = 'es-blips:client:manageBlip', args = data }))
    table.insert(blipColorMenu, openBlipMenu("Close", false, { event = 'qb-menu:client:closeMenu' }))
    exports['qb-menu']:openMenu(blipColorMenu)
end)

RegisterNetEvent('es-blips:client:updateColor', function(data)
    local blip = blips[data.index].blip
    SetBlipColour(blip, data.color)
    blips[data.index].color = data.color
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(data.name)
    EndTextCommandSetBlipName(blip)

    TriggerServerEvent('es-blips:server:updateBlip', blips)
end)

RegisterNetEvent('es-blips:client:deleteBlip', function(data)
    local blip = blips[data.index].blip
    RemoveBlip(blip)
    table.remove(blips, data.index)
    TriggerServerEvent('es-blips:server:updateBlip', blips)
end)
