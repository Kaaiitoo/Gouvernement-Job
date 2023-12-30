ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local currentTask = {}
local PlayerData = {}
local IsHandcuffed, DragStatus = false, {}

DragStatus.IsDragged          = false

closestDistance, closestEntity = -1, nil


loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
     ESX.PlayerData = xPlayer
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


-------------- FONCTION DE LA FOUILLE -()
local Items = {} 
local Armes = {}
local ArgentSale = {}
local IsHandcuffed, DragStatus = false, {}
DragStatus.IsDragged          = false

local PlayerData = {}

local function MarquerJoueur()
        local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
        local pos = GetEntityCoords(ped)
        local target, distance = ESX.Game.GetClosestPlayer()
end

local function getPlayerInv(player)
    Items = {}
    Armes = {}
    ArgentSale = {}
    
    ESX.TriggerServerCallback('kaitovip:getOtherPlayerData', function(data)
        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                table.insert(ArgentSale, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })
    
                break
            end
        end
    
        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(Items, {
                    label    = data.inventory[i].label,
                    right    = data.inventory[i].count,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end


        for i=1, #data.weapons, 1 do

            table.insert(Armes, {
    
                label    = ESX.GetWeaponLabel(data.weapons[i].name),
    
                value    = data.weapons[i].name,
    
                right    = data.weapons[i].ammo,
    
                itemType = 'item_weapon',
    
                amount   = data.weapons[i].ammo
    
            })
    
        end
    
    end, GetPlayerServerId(player))
    end
----------- FIN DE LA FONCTION ----------------------


    ------------- COMMENCEMENT MENU F6 ----------------------

function GouvernementF6()
    local Bientot2Milles = RageUI.CreateMenu("Gouvernement", "Menu Intéraction..")
    Bientot2Milles:SetRectangleBanner(0, 0, 0)
    local lasecteapeshit = RageUI.CreateSubMenu(Bientot2Milles, "Gouvernement", "Menu Intéraction..")
    local InteractionP = RageUI.CreateSubMenu(Bientot2Milles, "Gouvernement", "Menu Intéraction..")
    local menugouvv = RageUI.CreateSubMenu(Bientot2Milles, "Gouvernement", "Menu Intéraction..")
    local renfortZEBI = RageUI.CreateSubMenu(Bientot2Milles, "Gouvernement", "Menu Intéraction..")
    InteractionP:SetRectangleBanner(0, 0, 0)
    lasecteapeshit:SetRectangleBanner(0, 0, 0)
    renfortZEBI:SetRectangleBanner(0, 0, 0)
    menugouvv:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(Bientot2Milles, not RageUI.Visible(Bientot2Milles))
            while Bientot2Milles do
                Citizen.Wait(0)
                    RageUI.IsVisible(Bientot2Milles, true, true, true, function()

            RageUI.ButtonWithStyle("→ Infos Gouvernement", nil, {}, true, function(Hovered, Active, Selected)
               if (Selected) then
                  end
                 end, menugouvv)

                 RageUI.ButtonWithStyle("→ Intéraction Citoyen", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                    end
                end, InteractionP) 

                 RageUI.ButtonWithStyle("→ Demande de renfort", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                    end
                end, renfortZEBI)
    
    
        end, function()
        end)

        RageUI.IsVisible(lasecteapeshit, true, true, true, function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            RageUI.Separator("↓ ~r~Argent non déclaré ~s~↓")
            for k,v  in pairs(ArgentSale) do
                RageUI.ButtonWithStyle("Argent non déclaré :", nil, {RightLabel = "~g~"..v.label.."$"}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                            RageUI.Popup({message = "~r~Quantité invalide"})
                        else
                            TriggerServerEvent('kaitovip:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end
    
            RageUI.Separator("↓ ~r~Objets~s~↓")
            for k,v  in pairs(Items) do
                RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~g~x"..v.right}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                            RageUI.Popup({message = "~r~Quantité invalide"})
                        else
                            TriggerServerEvent('kaitovip:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end

            RageUI.Separator("↓ ~r~Armes~s~↓")
            
			for k,v  in pairs(Armes) do

				RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~g~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)

					if s then

						local combien = KeyboardInput("Combien ?", '' , '', 9999999)

						if tonumber(combien) > v.amount then

							RageUI.Popup({message = "~r~Quantité invalide"})

						else

							TriggerServerEvent('kaitovip:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))

						end

						RageUI.GoBack()

					end

				end)

			end
    
            end, function() 
            end)

            RageUI.IsVisible(menugouvv, true, true, true, function()

    
                RageUI.ButtonWithStyle("→ Prise de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

                    if Selected then
        
                        local info = 'prise'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Fin de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'fin'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Pause de service",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'pause'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Standby",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'standby'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Control en cours",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'control'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Refus d'obtempérer",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'refus'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                RageUI.ButtonWithStyle("→ Crime en cours",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
        
                    if Selected then
        
                        local info = 'crime'
        
                        TriggerServerEvent('gnegneservice', info)
        
                    end
        
                end)
        
        
        
                end, function() 
                end)

                RageUI.IsVisible(renfortZEBI, true, true, true, function()

    
		RageUI.ButtonWithStyle("→ Petite demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

			if Selected then

				local raison = 'petit'

				local elements  = {}

				local playerPed = PlayerPedId()

				local coords  = GetEntityCoords(playerPed)

				local name = GetPlayerName(PlayerId())

			TriggerServerEvent('renfortkaito', coords, raison)

		end

	end)



	RageUI.ButtonWithStyle("→ Moyenne demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

		if Selected then

			local raison = 'importante'

			local elements  = {}

			local playerPed = PlayerPedId()

			local coords  = GetEntityCoords(playerPed)

			local name = GetPlayerName(PlayerId())

		TriggerServerEvent('renfortkaito', coords, raison)

	end

end)



RageUI.ButtonWithStyle("→ Grosse demande",nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)

	if Selected then

		local raison = 'omgad'

		local elements  = {}

		local playerPed = PlayerPedId()

		local coords  = GetEntityCoords(playerPed)

		local name = GetPlayerName(PlayerId())

	TriggerServerEvent('renfortkaito', coords, raison, name)

end

end)
            
            
            
                    end, function() 
                    end)

                                  RageUI.IsVisible(InteractionP, true, true, true, function()

                                    

                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                    local target, distance = ESX.Game.GetClosestPlayer()
                                    playerheading = GetEntityHeading(GetPlayerPed(-1))
                                    playerlocation = GetEntityForwardVector(PlayerPedId())
                                    playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                    local target_id = GetPlayerServerId(target)
                                    local searchPlayerPed = GetPlayerPed(target)
                                
                        
                                    RageUI.ButtonWithStyle('→ Fouiller la personne', nil, {}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
                                        if a then
                                            MarquerJoueur()
                                            if s then
                                            getPlayerInv(closestPlayer)
                        
                                        end
                                    end
                                    end, lasecteapeshit)
                            

                    RageUI.ButtonWithStyle("→ Mettre une amende",nil, {}, true, function(_,_,s)
                        local player, distance = ESX.Game.GetClosestPlayer()
                        if s then
                            local raison = ""
                            local montant = 0
                            AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    raison = result
                                    result = nil
                                    AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                    while (UpdateOnscreenKeyboard() == 0) do
                                        DisableAllControlActions(0)
                                        Wait(0)
                                    end
                                    if (GetOnscreenKeyboardResult()) then
                                        result = GetOnscreenKeyboardResult()
                                        if result then
                                            montant = result
                                            result = nil
                                            if player ~= -1 and distance <= 3.0 then
                                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', ('police'), montant)
                                                TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Banque', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                            else
                                                ESX.ShowNotification("~r~Probleme~s~: Aucuns joueurs proche")
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
        
            
                        local searchPlayerPed = GetPlayerPed(target)
                    RageUI.ButtonWithStyle("→ Menotter/démenotter", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local target, distance = ESX.Game.GetClosestPlayer()
                            playerheading = GetEntityHeading(GetPlayerPed(-1))
                            playerlocation = GetEntityForwardVector(PlayerPedId())
                            playerCoords = GetEntityCoords(GetPlayerPed(-1))
                            local target_id = GetPlayerServerId(target)
                            if closestPlayer ~= -1 and closestDistance <= 3.0 then   
                            TriggerServerEvent('kaitovip:handcuff', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)
            
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("→ Escorter", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('kaitovip:drag', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)
                    
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("→ Mettre dans un véhicule", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('kaitovip:putInVehicle', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                            end
                        end)
                    
                        local searchPlayerPed = GetPlayerPed(target)
                        RageUI.ButtonWithStyle("→ Sortir du véhicule", nil, {}, true, function(Hovered, Active, Selected)
                            if (Selected) then
                                local target, distance = ESX.Game.GetClosestPlayer()
                                playerheading = GetEntityHeading(GetPlayerPed(-1))
                                playerlocation = GetEntityForwardVector(PlayerPedId())
                                playerCoords = GetEntityCoords(GetPlayerPed(-1))
                                local target_id = GetPlayerServerId(target)
                                if closestPlayer ~= -1 and closestDistance <= 3.0 then  
                            TriggerServerEvent('kaitovip:OutVehicle', GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification('Aucun joueurs à proximité')
                        end
                        end
                    end)

                                            
                end, function() 
                end)

            if not RageUI.Visible(Bientot2Milles) and not RageUI.Visible(menugouvv) and not RageUI.Visible(renfortZEBI)  and not RageUI.Visible(InteractionP) and not RageUI.Visible(lasecteapeshit) and not RageUI.Visible(kaitoobjets) then
                Bientot2Milles = RMenu:DeleteType("Gouvernement", true)
            end
        end
    end

------------------------- FIN DU MENU F6 ------------------------------




    --- OUVERTURE DU MENU

Keys.Register('F6', 'Gouvernement', 'Ouvrir le Menu Gouvernement', function()
if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then
    GouvernementF6()
end
end)

-------------------------- Intéraction  ----------------------------

RegisterNetEvent('kaitovip:handcuff')
AddEventHandler('kaitovip:handcuff', function()

  IsHandcuffed    = not IsHandcuffed;
  local playerPed = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    if IsHandcuffed then

        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end

      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      DisableControlAction(2, 37, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 37, true) -- Select Weapon
      DisableControlAction(0, 47, true)  -- Disable weapon
      

    else

      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)

    end

  end)
end)

RegisterNetEvent('kaitovip:drag')
AddEventHandler('kaitovip:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = GetPlayerPed(-1)
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(GetPlayerPed(-1), true, false)
      end
    end
  end
end)

RegisterNetEvent('kaitovip:putInVehicle')
AddEventHandler('kaitovip:putInVehicle', function()

  local playerPed = GetPlayerPed(-1)
  local coords    = GetEntityCoords(playerPed)

  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then

    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)

    if DoesEntityExist(vehicle) then

      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil

      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end

      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end

    end

  end

end)

RegisterNetEvent('kaitovip:OutVehicle')
AddEventHandler('kaitovip:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2

  SetEntityCoords(GetPlayerPed(-1), xnew, ynew, plyPos.z)
end)
------------------------ FIN INTERACTION --------------------------

-- MENOTTER TOUCHER DESAC

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 30,  true) -- MoveLeftRight
      DisableControlAction(0, 31,  true) -- MoveUpDown
    end
  end
end)


------------- PRISE SERVICE -----------------------

RegisterNetEvent('gnegneserviceeee')

AddEventHandler('gnegneserviceeee', function(service, nom)

	if service == 'prise' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Prise de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-8\n~w~Information: ~g~Prise de service.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'fin' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Fin de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-10\n~w~Information: ~g~Fin de service.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'pause' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Pause de service', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-6\n~w~Information: ~g~Pause de service.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'standby' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Mise en standby', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-12\n~w~Information: ~g~Standby, en attente de dispatch.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'control' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Control routier', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-48\n~w~Information: ~g~Control routier en cours.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'refus' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Refus d\'obtemperer', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-30\n~w~Information: ~g~Refus d\'obtemperer / Delit de fuite en cours.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	elseif service == 'crime' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Crime en cours', 'Agent: ~g~'..nom..'\n~w~Code: ~g~10-31\n~w~Information: ~g~Crime en cours / poursuite en cours.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

	end

end)


------------------- RENFORT ----------------------------

RegisterNetEvent('renfort:setBlip')

AddEventHandler('renfort:setBlip', function(coords, raison)

	if raison == 'petit' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-2\n~w~Importance: ~g~Légère.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

		color = 2

	elseif raison == 'importante' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-3\n~w~Importance: ~o~Importante.', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

		color = 47

	elseif raison == 'omgad' then

		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)

		PlaySoundFrontend(-1, "OOB_Start", "GTAO_FM_Events_Soundset", 1)

		PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", 1)

		ESX.ShowAdvancedNotification('INFORMATIONS', '~b~Demande de renfort', 'Demande de renfort demandé.\nRéponse: ~g~CODE-99\n~w~Importance: ~r~URGENTE !\nDANGER IMPORTANT', 'CHAR_CHAT_CALL', 8)

		Wait(1000)

		PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)

		PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", 1)

		color = 1

	end

	local blipId = AddBlipForCoord(coords)

	SetBlipSprite(blipId, 161)

	SetBlipScale(blipId, 1.2)

	SetBlipColour(blipId, color)

	BeginTextCommandSetBlipName("STRING")

	AddTextComponentString('Demande renfort')

	EndTextCommandSetBlipName(blipId)

	Wait(80 * 1000)

	RemoveBlip(blipId)

end)
