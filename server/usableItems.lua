onResourceStart(function()
    for k, v in pairs(SkateboardItemModels) do
        createUseableItem(k, function(source, item)
            TriggerClientEvent(getScript()..":Skateboard:PickPlace", source, { name = k })
        end)
    end

    for k, v in pairs(SurfboardItemModels) do
        createUseableItem(k, function(source, item)
            TriggerClientEvent(getScript()..":SurfBoard:PickPlace", source, { name = k })
        end)
    end
end, true)
