ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
     PlayerData = xPlayer
end)

Citizen.CreateThread(function()
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

function EquipementGouv()
    local EquipementGouv = RageUI.CreateMenu("Equipement", "Menu Intéraction..")
    EquipementGouv:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(EquipementGouv, not RageUI.Visible(EquipementGouv))
            while EquipementGouv do
            Citizen.Wait(0)
            RageUI.IsVisible(EquipementGouv, true, true, true, function()

                RageUI.ButtonWithStyle("~h~→ Equipement Recrue",nil, {nil}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent('armurerierecrue')
                        RageUI.CloseAll()
                    end
                end)

        if ESX.PlayerData.job.grade_name == 'officer' or ESX.PlayerData.job.grade_name == 'sergeant' then 
        RageUI.ButtonWithStyle("~h~→ Equipement Experimente",nil, {nil}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('armurerieexperimente')
                RageUI.CloseAll()
            end
        end)
    end

    if ESX.PlayerData.job.grade_name == 'sergeant' then 
        RageUI.ButtonWithStyle("~h~→ Equipement Chef d\'Equipe",nil, {nil}, true, function(Hovered, Active, Selected)
            if Selected then
                TriggerServerEvent('armureriechef')
                RageUI.CloseAll()
            end
        end)
    end

            end, function()
            end, 1)

            if not RageUI.Visible(EquipementGouv) then
            EquipementGouv = RMenu:DeleteType("EquipementGouv", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then
           
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.Equipement.position.x, Config.pos.Equipement.position.y, Config.pos.Equipement.position.z)
        if dist3 <= 1.2 and Config.genre then
            Timer = 0
            DrawMarker(25, Config.pos.Equipement.position.x, Config.pos.Equipement.position.y, Config.pos.Equipement.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0 , 255, false, true, p19, true)
            end
            if dist3 <= 1.2 then
                FreezeEntityPosition(PlayerPedId(), false)
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour prendre votre équipement", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            FreezeEntityPosition(PlayerPedId(), true)
                            EquipementGouv()    
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)