function makeFakeSurfboard(Ped, remove, model) -- The animation for picking up and placing the board
	lastModel = model
	local prop = makeProp({ prop = model, coords = vec4(0, 0, 0, 0), false, true})
	if isCat then
		SetPedCanRagdoll(Ped, false)
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 31086), 0.18, -0.14, 0.0, -87.0, -100.0, 1.0, true, true, false, false, 1, true)
		ClearPedTasks(Ped)
	elseif isDog then
		if notSmallDog then
			SetPedCanRagdoll(Ped, false)
			AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 65068), 0.29, 0.02, -0.18, 0.0, 0.0, 100.0, true, true, false, false, 1, true)
		else
		end
	elseif isCoyote then
		SetPedCanRagdoll(Ped, false)
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 39317), 0.11, 0.0, -0.3, -10.0, 40.0, -90.0, true, true, false, false, 1, true)
	else
		playAnim("pickup_object", "pickup_low", -1, 0)
		if remove then Wait(700) end
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 57005), 0.22, 0.11, 0.17, -105.0, -80.0, 10.0, true, true, false, false, 1, true)
	end
	if remove then
		removeBoard()
	end
	Wait(900)
	destroyProp(prop)
end

RegisterNetEvent(getScript()..":SurfBoard:PickPlace", function(data)
	if not data.prop then
		data.prop = SurfboardItemModels[data.name]
	end
	if not IsModelValid(GetHashKey(data.prop)) then
		print("^1Error^7: ^1Can't place this model, try another location")
		return
	end
	surfboard = true
	local Ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(Ped) then
		if DoesEntityExist(skateboard.Bike) then
			Attached = false
			Wait(100)
			stopTempCam()
			makeFakeSurfboard(Ped, true, data.prop) -- pick up animation
			currentToken = triggerCallback(AuthEvent)
			addItem(lastItem, 1)
			skateboard = {}
			Dir = {}
		else
			local pedCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -40.5)
			skateboard.Bike = makeVeh("seashark3", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0))
			SetEntityCoords(skateboard.Bike, pedCoords)
			skateboard.Skate = makeProp({ prop = data.prop, coords = vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0) }, 1, 1)
			while not DoesEntityExist(skateboard.Bike) or not DoesEntityExist(skateboard.Skate) do Wait(5) end
			SetEntityVisible(skateboard.Bike, false, 0)
			pushVehicle(skateboard.Bike)
            -- Set the engine sound volume to 0 (may affect nearby same models too)
            ForceVehicleEngineAudio(skateboard.Bike, "NULL") -- Sometimes works for audio style
            -- Optionally mute all sounds from this vehicle
            SetVehicleAudioEngineDamageFactor(skateboard.Bike, 0.0)

			SetBoatAnchor(skateboard.Bike, true)
			SetBoatFrozenWhenAnchored(skateboard.Bike, true)

			SetEntityNoCollisionEntity(skateboard.Bike, Ped, false)
			SetEntityNoCollisionEntity(skateboard.Skate, Ped, false)

			Wait(500)

			configureSurfboard(skateboard.Bike)

			SetEntityCompletelyDisableCollision(skateboard.Bike, true, true)
			SetEntityCompletelyDisableCollision(skateboard.Skate, true, true)

			SetVehicleSilent(skateboard.Bike, true)
			ForceUseAudioGameObject(skateboard.Bike, "RAIDEN")
			SetVehicleEngineOn(skateboard.Bike, false, false, true)
			SetVehicleAudioEngineDamageFactor(skateboard.Bike, 0.0)
			SetVehicleAudioBodyDamageFactor(skateboard.Bike, 0.0)

			AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, 0.15, 270.0, 270.0, 270.0, false, true, true, true, 2, true)

			skateboard.Driver = makePed("a_c_chimp", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0), 0, 1, nil, nil)

			while not DoesEntityExist(skateboard.Driver) do Wait(0) end
			SetEntityCoords(skateboard.Driver, pedCoords.x, pedCoords.y, pedCoords.z, true)
			SetEntityNoCollisionEntity(skateboard.Driver, Ped, false)
			SetEntityCompletelyDisableCollision(skateboard.Driver, true, true)

			SetPedCanBeTargetted(skateboard.Driver, false)
			SetBlockingOfNonTemporaryEvents(skateboard.Driver, true)
			SetPedDiesWhenInjured(skateboard.Driver, false)
			SetPedCanRagdollFromPlayerImpact(skateboard.Driver, false)

			SetEnableHandcuffs(skateboard.Driver, true)
			SetEntityInvincible(skateboard.Driver, true)
			FreezeEntityPosition(skateboard.Driver, true)

			while not IsPedSittingInAnyVehicle(skateboard.Driver) do
				SetEntityVisible(skateboard.Driver, false, 0)
				TaskWarpPedIntoVehicle(skateboard.Driver, skateboard.Bike, -1)
				Wait(10)
			end

			local options = {
				{ action = function() TriggerEvent(getScript()..":Surfboard:GetOn", { board = skateboard.Skate, item = data.item, prop = data.prop }) end,
					icon = "fas fa-car", label = locale("targets", "getOn"), },
				{ action = function() TriggerEvent(getScript()..":SurfBoard:PickPlace", { board = skateboard.Skate, item = data.item, prop = data.prop }) end,
					icon = "fas fa-hand-holding", label = locale("targets", "pickUp"), },
			}

			createEntityTarget(skateboard.Skate, options, 2.5)
			createEntityTarget(skateboard.Driver, options, 2.5)
			createEntityTarget(skateboard.Bike, options, 2.5)

			makeFakeSurfboard(Ped, false, data.prop)

			DisableCamCollisionForEntity(Ped)
			DisableCamCollisionForEntity(skateboard.Bike)
			DisableCamCollisionForEntity(skateboard.Skate)
			DisableCamCollisionForEntity(skateboard.Driver)
			SetVehicleDoorsLocked(skateboard.Bike, 10)
			storedVariables = skateboard
			SetEntityCoords(skateboard.Bike, GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.8, 0.0))
			SetEntityHeading(skateboard.Bike, GetEntityHeading(Ped)+90)
			lastItem = data.name
			if hasItem(data.name, 1) then
				removeItem(data.name, 1)
			end
			Dir = {}
		end
	end
end)

RegisterNetEvent(getScript()..":Surfboard:GetOn", function() local Ped = PlayerPedId()

	SetBoatAnchor(skateboard.Bike, false)

	if isCat then
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.10, 0.78, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		playAnim("creatures@cat@move", "idle_upp", -1, 1)
	elseif isDog or isCoyote then
		if notSmallDog then
			AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.30, 0.55, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		else
			AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.40, 0.70, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		end
	else
		playAnim("move_strafe@stealth", "idle", -1, 1)
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.0, 1.15, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
	end
	SetEntityCollision(Ped, true, true)
	Attached = true
	updateCamLoc()

	CreateThread(function()
		while Attached do
			overSpeed = (GetEntitySpeed(skateboard.Bike)*3.6) > 90
			if (GetEntitySpeed(skateboard.Bike)*3.6) > 10 then
				if not IsEntityPlayingAnim(Ped, "move_strafe@stealth", "idle", 3) then
					playAnim("move_strafe@stealth", "idle", -1, 1)
				end
			else
				if not IsEntityPlayingAnim(Ped, "move_crouch_proto", "idle", 3) then
					playAnim("move_crouch_proto", "idle", -1, 0)
				end
			end
			local getRot = GetEntityRotation(skateboard.Bike)
			if (-80.0 < getRot.x and getRot.x > 80.0) or (-80.0 < getRot.y and getRot.y > 80.0) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1)
				Attached = false
				Dir = {}
				SetPedToRagdoll(Ped, 5000, 4000, 0, true, true, false)
			end

			if not IsEntityAttachedToEntity(Ped, skateboard.Bike) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 6, 2000)
				Attached = false
				Dir = {}
				if isCat then
					stopAnim("creatures@cat@move", "idle_upp")
					stopAnim("creatures@cat@move", "idle_dwn")
				elseif (isDog or isCoyote) then
					--
				else
					stopAnim("move_strafe@stealth", "idle")
				end
				SetBoatAnchor(skateboard.Bike, true)
			end
			Wait(700)
		end
	end)

	CreateThread(function()
		-- Extra separate check to see if the Entity Exists
		-- Moved from above because if you get ejected from the bike, and its flipped
		while DoesEntityExist(skateboard.Driver) and DoesEntityExist(skateboard.Bike) and GetPedInVehicleSeat(skateboard.Bike, -1) == skateboard.Driver and not IsEntityDead(skateboard.Driver) do
			Wait(2000)
		end
		if Attached then
			makeFakeSkateboard(Ped, true, lastModel)
			removeEntityTarget(skateboard.Skate)
			removeEntityTarget(skateboard.Bike)
			removeEntityTarget(skateboard.Driver)
			Attached = false
			Wait(100)
			currentToken = triggerCallback(AuthEvent)
			addItem(lastItem, 1)
			skateboard = {}
			Dir = {}
		end
	end)
end)

if debugMode then
	RegisterCommand("surf", function() TriggerEvent(getScript()..":SurfBoard:PickPlace", { item = "skateboard", prop = `prop_surf_board_01` }) end)
end