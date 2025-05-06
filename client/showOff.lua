function showOff(data)
	--exports.ox_inventory:closeInventory()
	local showProp = nil
	local animTable = {
		{ animDict = "molly@boombox1",		anim = "boombox1_clip",			bone = 60309, pos = vec3(-0.0050, 0.0320, 0.1640), rot = vec3(44.6076, -112.2983, -86.1199) },
		{ animDict = "beachanims@molly", 	anim = "beachanim_surf_clip", 	bone = 28422, pos = vec3(-0.1020, 0.2240,  0.0840), rot = vec3(5.6655, 175.3526, 49.7964) },
		{ animDict = "chocoholic@skate4", 	anim = "skate4_clip", 			bone = 28422, pos = vec3(0.2780, -0.0200, -0.0700), rot = vec3(-180.0000, 28.0000, 0.0) },
	}
	local Menu = {}
	for i = 1, #animTable do
		Menu[#Menu+1] = {
			header = locale("menus", "holdUp").." "..i,
			onSelect = function()
				if not data.skip then
					TriggerEvent(getScript()..":Skateboard:PickPlace", data)
					Wait(1500)
				end
				showProp = makeProp({ prop = data.prop, coords = vec4(0, 0, 0, 0) }, true, true)
				AttachEntityToEntity(showProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), animTable[i].bone), animTable[i].pos.x, animTable[i].pos.y, animTable[i].pos.z, animTable[i].rot.x, animTable[i].rot.y, animTable[i].rot.z, true, true, false, true, 1, true )
				loadAnimDict(animTable[i].animDict)
				playAnim(animTable[i].animDict, animTable[i].anim, -1, 11)
				hold = true
				drawText(nil, { locale("info", "putDown") })
				lockInv(true)
				while hold do
					Wait(0)
					if IsControlJustReleased(0, 202) then
						hold = false
						break
					end
				end
				lockInv(false)
				hideText()
				stopAnim(animTable[i].animDict, animTable[i].anim)
				if not data.skip then
					TriggerEvent(getScript()..":Skateboard:PickPlace", data)
				end
				DeleteEntity(showProp)
				showProp = nil
			end
		}
	end
	openMenu(Menu, { header = locale("info", "header"), })
end

function holdBoard(data)
	local showProp = nil
	TriggerEvent(getScript()..":Skateboard:PickPlace", data)
	Wait(1500)
	showProp = makeProp({ prop = data.prop, coords = vec4(0, 0, 0, 0) }, true, true)
	AttachEntityToEntity(showProp, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.17, -0.04, 0.08, 205.0, 29.0, 258.0,true,true, false, true, 1, true )
	hold = true
	drawText(nil, { locale("info", "putDown") })
	while hold do
		Wait(0)
		if IsControlJustReleased(0, 202) then
			hold = false
			break
		end
	end
	hideText()
	TriggerEvent(getScript()..":Skateboard:PickPlace", data)
	DeleteEntity(showProp)
	showProp = nil
end

RegisterNetEvent(getScript()..":client:showoff", showOff)
RegisterNetEvent(getScript()..":client:holdBoard", holdBoard)