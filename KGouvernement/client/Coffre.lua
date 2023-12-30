ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

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



function CoffreGouv()
    local CMeca = RageUI.CreateMenu("Stockage", "Menu Intéraction..")
    CMeca:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(CMeca, not RageUI.Visible(CMeca))
            while CMeca do
            Citizen.Wait(0)
            RageUI.IsVisible(CMeca, true, true, true, function()

                RageUI.Separator("↓ ~y~   Gestion des stocks  ~s~↓")
                
                    RageUI.ButtonWithStyle("Retirer un objet(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            GouvRetire()
                            RageUI.CloseAll()
                        end
                    end)
                    
                    RageUI.ButtonWithStyle("Déposer un objet(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            GHouvDepose()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.Separator("↓ ~o~   Gestion des armes  ~s~↓")

                    RageUI.ButtonWithStyle("Retirer une arme(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            retirergouv()
                            RageUI.CloseAll()
                        end
                    end)

                    RageUI.ButtonWithStyle("Déposer une arme(s)",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            deposergouv()
                            RageUI.CloseAll()
                        end
                    end)

                    
                    
                end, function()
                end)
            if not RageUI.Visible(CMeca) then
            CMeca = RMenu:DeleteType("CMeca", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.Coffre.position.x, Config.pos.Coffre.position.y, Config.pos.Coffre.position.z)
        if dist3 <= 1.5 and Config.genre then
            Timer = 0
            DrawMarker(25, Config.pos.Coffre.position.x, Config.pos.Coffre.position.y, Config.pos.Coffre.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0 , 255, false, true, p19, true)
            end
            if dist3 <= 1.5 then
                FreezeEntityPosition(PlayerPedId(), false)
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour ouvrir le coffre", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            FreezeEntityPosition(PlayerPedId(), true)
                            CoffreGouv()    
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)

itemstock = {}
function GouvRetire()
    local KGouvernementtt = RageUI.CreateMenu("Coffre", "Menu Intéraction..")
    KGouvernementtt:SetRectangleBanner(0, 0, 0)
    ESX.TriggerServerCallback('KGouvernement:getStockItems', function(items) 
    itemstock = items
    RageUI.Visible(KGouvernementtt, not RageUI.Visible(KGouvernementtt))
        while KGouvernementtt do
            Citizen.Wait(0)
                RageUI.IsVisible(KGouvernementtt, true, true, true, function()
                        for k,v in pairs(itemstock) do 
                            if v.count ~= 0 then
                            RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.count}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    local count = KeyboardInput("Combien ?", '' , 8)
                                    TriggerServerEvent('KGouvernement:getStockItem', v.name, tonumber(count))
                                    RageUI.CloseAll()
                                end
                            end)
                        end
                    end
                end, function()
                end)
            if not RageUI.Visible(KGouvernementtt) then
            KGouvernementtt = RMenu:DeleteType("Coffre", true)
        end
    end
end)
end

local PlayersItem = {}
function GHouvDepose()
    local DeposerShiganshina = RageUI.CreateMenu("Coffre", "Menu Intéraction..")
    DeposerShiganshina:SetRectangleBanner(0, 0, 0)
    ESX.TriggerServerCallback('KGouvernement:getPlayerInventory', function(inventory)
        RageUI.Visible(DeposerShiganshina, not RageUI.Visible(DeposerShiganshina))
    while DeposerShiganshina do
        Citizen.Wait(0)
            RageUI.IsVisible(DeposerShiganshina, true, true, true, function()
                for i=1, #inventory.items, 1 do
                    if inventory ~= nil then
                            local item = inventory.items[i]
                            if item.count > 0 then
                                        RageUI.ButtonWithStyle(item.label, nil, {RightLabel = item.count}, true, function(Hovered, Active, Selected)
                                            if Selected then
                                            local count = KeyboardInput("Combien ?", '' , 8)
                                            TriggerServerEvent('KGouvernement:putStockItems', item.name, tonumber(count))
                                            RageUI.CloseAll()
                                        end
                                    end)
                                end
                            else
                                RageUI.Separator('Chargement en cours')
                            end
                        end
                    end, function()
                    end)
                if not RageUI.Visible(DeposerShiganshina) then
                DeposerShiganshina = RMenu:DeleteType("Coffre", true)
            end
        end
    end)
end

----------------------------------------------------
function retirergouv()

	ESX.TriggerServerCallback('KGouvernement:getArmoryWeapons', function(weapons)
		local elements = {}

		for i=1, #weapons, 1 do
			if weapons[i].count > 0 then
				table.insert(elements, {
					label = 'x' .. weapons[i].count .. ' ' .. ESX.GetWeaponLabel(weapons[i].name),
					value = weapons[i].name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_get_weapon',
		{
			title    = 'Armurerie',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)

			menu.close()

			ESX.TriggerServerCallback('KGouvernement:removeArmoryWeapon', function()
				retirergouv()
			end, data.current.value)

		end, function(data, menu)
			menu.close()
		end)
	end)

end

function deposergouv()
	local elements   = {}
	local playerPed  = PlayerPedId()
	local weaponList = ESX.GetWeaponList()

	for i=1, #weaponList, 1 do
		local weaponHash = GetHashKey(weaponList[i].name)

		if HasPedGotWeapon(playerPed, weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
			table.insert(elements, {
				label = weaponList[i].label,
				value = weaponList[i].name
			})
		end
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_put_weapon',
	{
		title    = 'Armurerie',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		menu.close()

		ESX.TriggerServerCallback('KGouvernement:addArmoryWeapon', function()
			deposergouv()
		end, data.current.value, true)

	end, function(data, menu)
		menu.close()
	end)
end
