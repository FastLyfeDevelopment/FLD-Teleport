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
local hasShownMessage = false  -- Track if we've shown the message already

-- Main loop to check player's position
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())  -- Get the player's current position
        local zoneFound = false

        -- Check if player is near any teleport zone
        for zoneName, zoneData in pairs(teleportZones) do
            local distance = GetDistanceBetweenCoords(playerCoords, zoneData.EnterMarker, true)
            if distance < teleportDistance then
                zoneFound = true
                isInZone = true
                currentZone = zoneData

                -- Show the message in the chat only once when entering the zone
                if not hasShownMessage then
                    TriggerEvent('chat:addMessage', {
                        args = {"[Teleport]", "Press E to enter"},
                        color = {211, 188, 216}  -- Set the RGB color for the message
                    })
                    hasShownMessage = true  -- Set the flag to prevent spam
                end

                -- Remove the DrawMarker function to stop drawing the red circle marker
                -- DrawMarker(1, zoneData.EnterMarker.x, zoneData.EnterMarker.y, zoneData.EnterMarker.z - 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            end
        end

        -- If the player is no longer in any zone, reset flags
        if not zoneFound then
            if isInZone then
                isInZone = false
                hasShownMessage = false  -- Reset message flag when leaving the zone
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
            -- Hide the message when the player is not near the teleport zone (message hides when leaving zone)
            if hasShownMessage then
                TriggerEvent('chat:addMessage', {
                    args = {"[Teleport]", "You left Modos."},
                    color = {211, 188, 216}  -- Set the RGB color for the message
                })
                hasShownMessage = false  -- Prevent further "You left" messages
            end
        end
    end
end)
