ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('esx_society:registerSociety', 'gouvernement', 'gouvernement', 'society_gouvernement', 'society_gouvernement', 'society_gouvernement', {type = 'private'})

------------------------------------ STOCKAGE -----------------------------------------------------------------
ESX.RegisterServerCallback('KGouvernement:getStockItems', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('KGouvernement:getStockItem')
AddEventHandler('KGouvernement:getStockItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Un objet a été retiré', count, inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('KGouvernement:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('KGouvernement:putStockItems')
AddEventHandler('KGouvernement:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_gouvernement', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end
	end)
end)
-----------------------------------------------------------------------------------------------

------------------------ BLABLABLA -------------------------------------------------------------------------
AddEventHandler('playerDropped', function()
	local _source = source

	if _source ~= nil then
		local xPlayer = ESX.GetPlayerFromId(_source)

		if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'gouvernement' then
			Citizen.Wait(5000)
			TriggerClientEvent('KGouvernement:updateBlip', -1)
		end
	end
end)

RegisterServerEvent('KGouvernement:spawned')
AddEventHandler('KGouvernement:spawned', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer ~= nil and xPlayer.job ~= nil and xPlayer.job.name == 'gouvernement' then
		Citizen.Wait(5000)
		TriggerClientEvent('KGouvernement:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.Wait(5000)
		TriggerClientEvent('KGouvernement:updateBlip', -1)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		TriggerEvent('esx_phone:removeNumber', 'gouvernement')
	end
end)

RegisterServerEvent('mecanosous')
AddEventHandler('mecanosous', function(id)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM addon_account_data WHERE account_name = 'society_mechanic'", {}, function(result)
        for index,data in pairs(result) do 
            TriggerClientEvent('esx:showNotification', _src, "Le compte du Mécano possède =~r~ "..data.money.." $")
        end
    end)
end)
    

RegisterServerEvent('concessSous')
AddEventHandler('concessSous', function(id)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM addon_account_data WHERE account_name = 'society_concess'", {}, function(result) ---- A VOUS DE CHANGER LE NOM DU SOCIETY par celui de votre serveur
        for index,data in pairs(result) do 
            TriggerClientEvent('esx:showNotification', _src, "Le compte du Concessionnaire possède = ~r~"..data.money.." $")
        end
    end)
end)

RegisterServerEvent('LSPDSOUS')
AddEventHandler('LSPDSOUS', function(id)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM addon_account_data WHERE account_name = 'society_police'", {}, function(result) ---- A VOUS DE CHANGER LE NOM DU SOCIETY par celui de votre serveur
        for index,data in pairs(result) do 
            TriggerClientEvent('esx:showNotification', _src, "Le compte du LSPD possède = ~r~"..data.money.." $")
        end
    end)
end)

RegisterServerEvent('EMSOUS')
AddEventHandler('EMSOUS', function(id)
    local _src = source
    MySQL.Async.fetchAll("SELECT * FROM addon_account_data WHERE account_name = 'society_ambulance'", {}, function(result) ---- A VOUS DE CHANGER LE NOM DU SOCIETY par celui de votre serveur
        for index,data in pairs(result) do 
            TriggerClientEvent('esx:showNotification', _src, "Le compte des EMS possède = ~r~"..data.money.." $")
        end
    end)
end)
------------- COFFRE ARME ---------------------


ESX.RegisterServerCallback('KGouvernement:getArmoryWeapons', function(source, cb)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernement', function(store)

		local weapons = store.get('weapons')



		if weapons == nil then

			weapons = {}

		end



		cb(weapons)

	end)

end)



ESX.RegisterServerCallback('KGouvernement:addArmoryWeapon', function(source, cb, weaponName, removeWeapon)

	local xPlayer = ESX.GetPlayerFromId(source)



	if removeWeapon then

		xPlayer.removeWeapon(weaponName)

	end



	TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernement', function(store)

		local weapons = store.get('weapons') or {}

		local foundWeapon = false



		for i=1, #weapons, 1 do

			if weapons[i].name == weaponName then

				weapons[i].count = weapons[i].count + 1

				foundWeapon = true

				break

			end

		end



		if not foundWeapon then

			table.insert(weapons, {

				name  = weaponName,

				count = 1

			})

		end



		store.set('weapons', weapons)

		cb()

	end)

end)



ESX.RegisterServerCallback('KGouvernement:removeArmoryWeapon', function(source, cb, weaponName)

	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.addWeapon(weaponName, 500)



	TriggerEvent('esx_datastore:getSharedDataStore', 'society_gouvernement', function(store)

		local weapons = store.get('weapons') or {}



		local foundWeapon = false



		for i=1, #weapons, 1 do

			if weapons[i].name == weaponName then

				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)

				foundWeapon = true

				break

			end

		end



		if not foundWeapon then

			table.insert(weapons, {

				name = weaponName,

				count = 0

			})

		end



		store.set('weapons', weapons)

		cb()

	end)

end)

------------------------- ZIAK TEN PENSES QUOI -----------------------

RegisterServerEvent('renfortkaito')

AddEventHandler('renfortkaito', function(coords, raison)

	local _source = source

	local _raison = raison

	local xPlayer = ESX.GetPlayerFromId(_source)

	local xPlayers = ESX.GetPlayers()

	local name = xPlayer.getName(_source)



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

		if thePlayer.job.name == 'gouvernement' then

			TriggerClientEvent('renfort:setBlip', xPlayers[i], coords, _raison, name)

		end

	end

end)


---------------------------------------------------------

function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end


RegisterServerEvent('kaitovip:handcuff')
AddEventHandler('kaitovip:handcuff', function(target)
  TriggerClientEvent('kaitovip:handcuff', target)
end)

RegisterServerEvent('kaitovip:drag')
AddEventHandler('kaitovip:drag', function(target)
  local _source = source
  TriggerClientEvent('kaitovip:drag', target, _source)
end)

RegisterServerEvent('kaitovip:putInVehicle')
AddEventHandler('kaitovip:putInVehicle', function(target)
  TriggerClientEvent('kaitovip:putInVehicle', target)
end)

RegisterServerEvent('kaitovip:OutVehicle')
AddEventHandler('kaitovip:OutVehicle', function(target)
    TriggerClientEvent('kaitovip:OutVehicle', target)
end)

-------------------------------- Fouiller


RegisterNetEvent('kaitovip:confiscatePlayerItem')

AddEventHandler('kaitovip:confiscatePlayerItem', function(target, itemType, itemName, amount)

    local _source = source

    local sourceXPlayer = ESX.GetPlayerFromId(_source)

    local targetXPlayer = ESX.GetPlayerFromId(target)



    if itemType == 'item_standard' then

        local targetItem = targetXPlayer.getInventoryItem(itemName)

		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		

			targetXPlayer.removeInventoryItem(itemName, amount)

			sourceXPlayer.addInventoryItem   (itemName, amount)

            TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount..' '..sourceItem.label.."~s~.")

            TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a pris ~b~"..amount..' '..sourceItem.label.."~s~.")

        else

			TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide")

		end

        

    if itemType == 'item_account' then

        targetXPlayer.removeAccountMoney(itemName, amount)

        sourceXPlayer.addAccountMoney   (itemName, amount)

        

        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount.." d' "..itemName.."~s~.")

        TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous aconfisqué ~b~"..amount.." d' "..itemName.."~s~.")

        

    elseif itemType == 'item_weapon' then

        if amount == nil then amount = 0 end

        targetXPlayer.removeWeapon(itemName, amount)

        sourceXPlayer.addWeapon   (itemName, amount)



        TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")

        TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")

    end

end)

ESX.RegisterServerCallback('kaitovip:getOtherPlayerData', function(source, cb, target, notify)
    local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", target, "~r~~Quelqu'un vous fouille")

    if xPlayer then
        local data = {
            name = xPlayer.getName(),
            job = xPlayer.job.label,
            grade = xPlayer.job.grade_label,
            inventory = xPlayer.getInventory(),
            accounts = xPlayer.getAccounts(),
            weapons = xPlayer.getLoadout()
        }

        cb(data)
    end
end)


RegisterServerEvent('gnegneservice')

AddEventHandler('gnegneservice', function(PriseOuFin)

	local _source = source

	local _raison = PriseOuFin

	local xPlayer = ESX.GetPlayerFromId(_source)

	local xPlayers = ESX.GetPlayers()

	local name = xPlayer.getName(_source)



	for i = 1, #xPlayers, 1 do

		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])

		if thePlayer.job.name == 'gouvernement' then

			TriggerClientEvent('gnegneserviceeee', xPlayers[i], _raison, name)

		end

	end

end)

------------- ARMU -----------

RegisterNetEvent('armurerierecrue')

AddEventHandler('armurerierecrue', function()

local _source = source

local xPlayer = ESX.GetPlayerFromId(source)

xPlayer.addWeapon('WEAPON_STUNGUN', 42)

xPlayer.addWeapon('WEAPON_NIGHTSTICK', 42)

TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre équipement~b~")

end)



RegisterNetEvent('armurerieexperimente')

AddEventHandler('armurerieexperimente', function()

local _source = source

local xPlayer = ESX.GetPlayerFromId(source)

xPlayer.addWeapon('WEAPON_STUNGUN', 42)

xPlayer.addWeapon('WEAPON_NIGHTSTICK', 42)

xPlayer.addWeapon('WEAPON_COMBATPISTOL', 42)

TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre équipement~b~")

end)



RegisterNetEvent('armureriechef')

AddEventHandler('armureriechef', function()

local _source = source

local xPlayer = ESX.GetPlayerFromId(source)

xPlayer.addWeapon('WEAPON_STUNGUN', 42)

xPlayer.addWeapon('WEAPON_NIGHTSTICK', 42)

xPlayer.addWeapon('WEAPON_COMBATPISTOL', 42)

xPlayer.addWeapon('WEAPON_COMBATPDW', 42)

TriggerClientEvent('esx:showNotification', source, "Vous avez reçu votre équipement~b~")

end)