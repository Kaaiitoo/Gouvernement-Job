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

local pos = vector3(-545.18, -201.95, 47.41)
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(pos)

	SetBlipSprite (blip, 358)
	SetBlipScale  (blip, 0.7)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Gouvernement')
    EndTextCommandSetBlipName(blip)
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


function GarageGouvv()
    local GarageGouv = RageUI.CreateMenu("Garage", "Menu Intéraction..")
    GarageGouv:SetRectangleBanner(0, 0, 0)
        RageUI.Visible(GarageGouv, not RageUI.Visible(GarageGouv))
            while GarageGouv do
            Citizen.Wait(0)
            RageUI.IsVisible(GarageGouv, true, true, true, function()


                for k,v in pairs(Vehicle) do
                    RageUI.ButtonWithStyle(v.nom, nil, {RightLabel = ""},true, function(Hovered, Active, Selected)
                        if (Selected) then
                        DoScreenFadeOut(3000)
                        Citizen.Wait(3000)
                        DoScreenFadeIn(3000)
                        spawnC(v.modele)
                            RageUI.CloseAll()
                            end
                        end)
                    end

                end, function()
                end)

            if not RageUI.Visible(GarageGouv) then
            GarageGouv = RMenu:DeleteType("GarageGouv", true)
        end
    end
end


Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.Garage.position.x, Config.pos.Garage.position.y, Config.pos.Garage.position.z)
            if dist3 <= 1.0 then
                FreezeEntityPosition(PlayerPedId(), false)
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour choisir un véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then           
                            FreezeEntityPosition(PlayerPedId(), true)
                            GarageGouvv()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)


-- PED 
local npc2 = {
	{hash="s_m_m_lathandy_01", x = -574.67, y = -172.84, z = 38.05, a=24.02}, 
}

Citizen.CreateThread(function()
	for _, item2 in pairs(npc2) do
		local hash = GetHashKey(item2.hash)
		while not HasModelLoaded(hash) do
		RequestModel(hash)
		Wait(20)
		end
		ped2 = CreatePed("PED_TYPE_CIVFEMALE", item2.hash, item2.x, item2.y, item2.z-0.92, item2.a, false, true)
		SetBlockingOfNonTemporaryEvents(ped2, true)
		FreezeEntityPosition(ped2, true)
		SetEntityInvincible(ped2, true)
	end
end)


-- FUNCTION POUR SORTIR LA VOITURE 

function spawnC(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.pos.SpawnVehicle.position.x, Config.pos.SpawnVehicle.position.y, Config.pos.SpawnVehicle.position.z, Config.pos.SpawnVehicle.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    local plaque = "KAITO"
    SetVehicleNumberPlateText(vehicle, plaque) 
end

  ------------- RANGER VOITURE ----------------

function RANGERCAR(vehicle)
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local props = ESX.Game.GetVehicleProperties(vehicle)
    local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
    local engineHealth = GetVehicleEngineHealth(current)

    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
        if engineHealth < 890 then
            ESX.ShowNotification("Votre véhicule est trop abimé, vous ne pouvez pas le ranger.")
        else
            ESX.Game.DeleteVehicle(vehicle)
            ESX.ShowNotification("~g~Le Véhicule a été rangé dans le garage.")
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' then
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.SupprimerVoiture.position.x, Config.pos.SupprimerVoiture.position.y, Config.pos.SupprimerVoiture.position.z)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) and dist3 <= 3.0 then
            DrawMarker(20, Config.pos.SupprimerVoiture.position.x, Config.pos.SupprimerVoiture.position.y, Config.pos.SupprimerVoiture.position.z,  0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 0, 0, 0 , 255, false, true, p19, true)
                Timer = 0   
                        RageUI.Text({  message = "Appuyez sur [~r~E~w~] pour ranger un véhicule", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            DoScreenFadeOut(3000)
                            Citizen.Wait(3000)
                            DoScreenFadeIn(3000)        
                            RANGERCAR()
                    end   
                end
            end 
        Citizen.Wait(Timer)
    end
end)