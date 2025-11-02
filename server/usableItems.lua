onResourceStart(function()
    for k, v in pairs(SkateboardItemModels) do
        createUseableItem(k, function(source, item)
            TriggerClientEvent(getScript()..":Skateboard:PickPlace", source, { name = k })
        end)
    end

    for k, v in pairs(SurfboardItemModels) do
        createUseableItem(k, function(source, item)
            TriggerClientEvent(getScript()..":Surfboard:PickPlace", source, { name = k })
        end)
    end

    local authCheck = {}
    createCallback(getScript()..":auth:logLastBoard", function(source, item)
        local src = source
        if not SkateboardItemModels[item] and not SurfboardItemModels[item] then
            print("^1Error^7: SRC: "..src.."^1Tried to log an item that wasn't a board^7: "..item)
            return false
        end
        if authCheck[src] then
            print("^1Error^7: SRC: "..src.." ^1already logged an item^7: "..authCheck[src])
            return false
        else
            authCheck[src] = item
            removeItem(item, 1, src)
            debugPrint("^5Debug^7: SRC: "..src.." ^2logged an item^7: "..authCheck[src])
            return true
        end
    end)

    createCallback(getScript()..":auth:collectBoard", function(source)
        local src = source
        if not authCheck[src] then
            print("^1Error^7: SRC: "..src.."^1Tried to request an item but it wasn't logged^7")
            return false
        else
            addItem(authCheck[src], 1, nil, src)
            authCheck[src] = nil
            return true
        end
    end)

end, true)
