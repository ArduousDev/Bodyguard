function UnloadBodyguard()
	for k, guard in pairs(Bodyguard.Guards) do
		if(guard ~= nil) then
            DeletePed(guard)
			Bodyguard.Guards[k] = nil
		end
	end
end

Citizen.CreateThread(function()
    while true do
        if IsControlJustPressed(0, Bodyguard.SpawnKey) then
            local BodyGuardSkinID = GetHashKey(Bodyguard.GuardSkin)
		    local playerPed = PlayerPedId()
		    local player = GetPlayerPed(playerPed)
		    local playerPosition = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
		    local playerGroup = GetPedGroupIndex(playerPed)
            if Bodyguard.SpawnMultiple == false then
                UnloadBodyguard()
            end
                Citizen.Wait(10)
                RequestModel(BodyGuardSkinID)
            while(not HasModelLoaded(BodyGuardSkinID)) do
                Citizen.Wait(10)
            end
            for i = 0, Bodyguard.GuardAmount, 1 do
                Bodyguard.Guards[i] = CreatePed(26, BodyGuardSkinID, playerPosition.x, playerPosition.y, playerPosition.z, 1, false, true)	
                SetPedCanSwitchWeapon(Bodyguard.Guards[i],false)
                SetPedAsGroupMember(Bodyguard.Guards[i], playerGroup)
                if Bodyguard.SetInvincible == true then
                    SetEntityInvincible(Bodyguard.Guards[i], true)
                else
                    SetEntityInvincible(Bodyguard.Guards[i], false)
                end
                if Bodyguard.GiveWeapon == true then
                    GiveWeaponToPed(Bodyguard.Guards[i], GetHashKey(Bodyguard.GuardWeapon), 100, true, true)
                end
            end
            SetModelAsNoLongerNeeded(BodyGuardSkinID)
        end
        Citizen.Wait(0)
    end
end)