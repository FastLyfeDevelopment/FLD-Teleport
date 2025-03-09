local teleportZones = {
    -- Define your teleport zones here
    MODOS1 = {
        EnterMarker = vector4(-212.6448, 5446.616, 25.62391, 351.0751),  -- Example coordinates
        EnterLanding = vector4(-212.6791, 5449.067, 25.6327, 188.0036),  -- Example landing location
        ZoneName = ""
    },
    MODOS2 = {
        EnterMarker = vector4(-212.295, 5449.273, 25.63269, 177.7824),  -- Example coordinates
        EnterLanding = vector4(-212.6448, 5446.616, 25.62391, 351.0751),  -- Example landing location
        ZoneName = ""
    },
    MODOS3 = {
        EnterMarker = vector4(-205.85, 5453.311, 25.49601, 92.01254),  -- Example coordinates
        EnterLanding = vector4(-208.5898, 5453.275, 25.63233, 272.346),  -- Example landing location
        ZoneName = ""
    },
    MODOS4 = {
        EnterMarker = vector4(-208.5898, 5453.275, 25.63233, 272.346),  -- Example coordinates
        EnterLanding = vector4(-206.1306, 5453.457, 25.53161, 268.0843),  -- Example landing location
        ZoneName = ""
    }
}
 
 

local teleportDistance = 2.0 -- How close the player needs to be to trigger the marker
local isInZone = false
local currentZone = nil
local hasShownMessage = false  
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId()) 
        local zoneFound = false

        for zoneName, zoneData in pairs(teleportZones) do
            local distance = GetDistanceBetweenCoords(playerCoords, zoneData.EnterMarker, true)
            if distance < teleportDistance then
                zoneFound = true
                isInZone = true
                currentZone = zoneData

                if not hasShownMessage then
                    TriggerEvent('chat:addMessage', {
                        args = {"[Teleport]", "Press E to enter"},
                        color = {211, 188, 216}  -- Set the RGB color for the message
                    })
                    hasShownMessage = true  
                end

       
            end
        end

        if not zoneFound then
            if isInZone then
                isInZone = false
                hasShownMessage = false  
            end
        end

        -- Check if the player is pressing the key (E) near the teleport zone
        if isInZone and IsControlJustPressed(0, 38) then  -- 38 is the control for "E"
            if currentZone then
                -- Teleport the player to the landing location
                SetEntityCoords(PlayerPedId(), currentZone.EnterLanding.x, currentZone.EnterLanding.y, currentZone.EnterLanding.z)
                -- Optionally, you can add a fade effect or screen transition here
                TriggerEvent('chat:addMessage', {
                    args = {"[Teleport]", "You have entered Modos " .. currentZone.ZoneName},
                    color = {211, 188, 216}  -- Set the RGB color for the message
                })
            end
        end
    end
end)

-- Optional: Hide the message when the player leaves the zone
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not isInZone then
            if hasShownMessage then
                TriggerEvent('chat:addMessage', {
                    args = {"[Teleport]", "You left Modos."},
                    color = {211, 188, 216}  -- Set the RGB color for the message
                })
                hasShownMessage = false  
            end
        end
    end
end)
