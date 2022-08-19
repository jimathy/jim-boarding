local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject', function() if source ~= '' then return false end	QBCore = exports['qb-core']:GetCoreObject() end)

QBCore.Functions.CreateUseableItem("skateboard", function(source, item) TriggerClientEvent("jim-skateboard:PickPlace", source) end)

RegisterNetEvent('jim-skateboard:server:toggleItem', function(give, item, amount)
	local src = source
	if not give then
		if QBCore.Functions.GetPlayer(src).Functions.RemoveItem(item, amount or 1) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "remove", amount or 1)
		end
	elseif give then
		if QBCore.Functions.GetPlayer(src).Functions.AddItem(item, amount or 1) then
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount or 1)
		end
	end
end)