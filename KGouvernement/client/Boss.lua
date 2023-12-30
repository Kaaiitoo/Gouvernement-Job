ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}
local GouvernementBoss = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
     ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
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


function Boss_actions()
    local GouvernementBoss = RageUI.CreateMenu("Gouvernement", "Menu Intéraction..")
    local compte = RageUI.CreateSubMenu(GouvernementBoss, "Gouvernement", "Menu Intéraction..")
    GouvernementBoss:SetRectangleBanner(0, 0, 0)
    compte:SetRectangleBanner(0, 0, 0)
      RageUI.Visible(GouvernementBoss, not RageUI.Visible(GouvernementBoss))
              while GouvernementBoss do
                  Citizen.Wait(0)
                      RageUI.IsVisible(GouvernementBoss, true, true, true, function()

            RageUI.ButtonWithStyle("~h~→ Retirer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:withdrawMoney', 'gouvernement', amount)
                        RefreshGouv()
                    end
                end
            end)

            RageUI.ButtonWithStyle("~h~→ Déposer argent de société",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "Montant invalide"})
                    else
                        TriggerServerEvent('esx_society:depositMoney', 'gouvernement', amount)
                        RefreshGouv()
                    end
                end
            end) 

            RageUI.ButtonWithStyle("~h~→ Voir le montant des comptes entreprises",nil, {}, true, function(Hovered, Active, Selected)
                if Selected then                   
                end
            end, compte)

           RageUI.ButtonWithStyle("~h~→ Accéder aux actions de Management",nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                if Selected then
                    aboss()
                    RageUI.CloseAll()
                end
            end)


        end, function()
        end)

        RageUI.IsVisible(compte, true, true, true, function()

            RageUI.ButtonWithStyle("~h~→ Voir le montant du Mécano",nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('mecanosous')            
                end
            end)

            RageUI.ButtonWithStyle("~h~→ Voir le montant du Concessionnaire",nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('concessSous')           
                end
            end)

            RageUI.ButtonWithStyle("~h~→ Voir le montant du LSPD",nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('LSPDSOUS')         
                end
            end)

            RageUI.ButtonWithStyle("~h~→ Voir le montant des EMS",nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('EMSOUS')         
                end
            end)

        end, function()
        end)
        if not RageUI.Visible(GouvernementBoss) and not RageUI.Visible(compte) then
            FreezeEntityPosition(PlayerPedId(), false)
        GouvernementBoss = RMenu:DeleteType("GouvernementBoss", true)
    end
end
end

---------------------

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'gouvernement' and ESX.PlayerData.job.grade_name == 'boss' then 
        local plyCoords3 = GetEntityCoords(GetPlayerPed(-1), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.pos.Boss.position.x, Config.pos.Boss.position.y, Config.pos.Boss.position.z)
        if dist3 <= 1.0 and Config.genre then
            Timer = 0
            end
            if dist3 <= 1.0 then
                Timer = 0   
                    RageUI.Text({  message = "Appuyez sur [~b~E~w~] pour gérer ton entreprise", time_display = 1 })
                        if IsControlJustPressed(1,51) then
                            FreezeEntityPosition(PlayerPedId(), true)
                            Boss_actions()
                end
                end
            end 
        Citizen.Wait(Timer)
    end
end)

function RefreshGouv()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            UpdateGoouv(money)
        end, ESX.PlayerData.job.name)
    end
end

function UpdateGoouv(money)
    GouvernementBoss = ESX.Math.GroupDigits(money)
end

function aboss()
    TriggerEvent('esx_society:openBossMenu', 'gouvernement', function(data, menu)
        menu.close()
    end, {wash = false})
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end
