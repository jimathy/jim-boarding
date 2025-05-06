onPlayerLoaded(function()
	Wait(1000)
	local Ped = PlayerPedId()
	local pedModel = GetEntityModel(Ped)
	isCat = (isCat() or pedModel == `ft-raccoon`) and (pedModel ~= `ft-sphynx`)
	isDog, notSmallDog = isDog()
	if isDog and pedModel == `a_c_coyote` then isDog = false end
	isCoyote = (pedModel == `ft-sphynx` or pedModel == `a_c_coyote`)
	if pedModel == `ft-capmonkey2` then isDog = true end
end, true)

onResourceStop(function()
	removeBoard()
end, true)

function makeFakeSkateboard(Ped, remove, model) -- The animation for picking up and placing the board
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
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 57005), 0.3, 0.08, 0.09, -86.0, -60.0, 50.0, true, true, false, false, 1, true)
	end
	if remove then
		removeBoard()
	end
	Wait(900)
	destroyProp(prop)
end

RegisterNetEvent(getScript()..":Skateboard:PickPlace", function(data)
	if not data.prop then
		data.prop = SkateboardItemModels[data.name]
	end
	if not IsModelValid(GetHashKey(data.prop)) then
		print("^1Error^7: ^1Can't currently place this model, try another location")
		return
	end
	jsonPrint(data)
	local Ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(Ped) then
		if DoesEntityExist(skateboard.Bike) then
			Attached = false
			Wait(100)
			stopTempCam()
			makeFakeSkateboard(Ped, true, data.prop) -- pick up animation
			currentToken = triggerCallback(AuthEvent)
			addItem(lastItem, 1)
			skateboard = {}
			Dir = {}
		else
			local pedCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, 0.5)
			skateboard.Bike = makeVeh("tribike3", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0))
			skateboard.Skate = makeProp({ prop = data.prop, coords = vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0) }, 1, 1)
			while not DoesEntityExist(skateboard.Bike) or not DoesEntityExist(skateboard.Skate) do Wait(5) end

			SetEntityNoCollisionEntity(skateboard.Bike, Ped, false)
			SetEntityNoCollisionEntity(skateboard.Skate, Ped, false)

			Wait(500)

			configureSkateboard(skateboard.Bike)

			SetEntityCompletelyDisableCollision(skateboard.Bike, true, true)
			SetEntityCompletelyDisableCollision(skateboard.Skate, true, true)

			SetEntityVisible(skateboard.Bike, false, 0)

			AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

			skateboard.Driver = makePed("a_c_chimp", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0), 0, 1, nil, nil) -- change to chimp, dies on ragdoll, doesnt talk, might be best model for it

			while not DoesEntityExist(skateboard.Driver) do Wait(0) end
			SetEntityCoords(skateboard.Driver, pedCoords.x, pedCoords.y, pedCoords.z, true)
			SetEntityNoCollisionEntity(skateboard.Driver, Ped, false)
			SetEntityCompletelyDisableCollision(skateboard.Driver, true, true)

			SetPedCanBeTargetted(skateboard.Driver, false)
			SetBlockingOfNonTemporaryEvents(skateboard.Driver, true)
			SetPedDiesWhenInjured(skateboard.Driver, false)
			SetPedCanRagdollFromPlayerImpact(skateboard.Driver, false)

			while not IsPedSittingInAnyVehicle(skateboard.Driver) do
				SetEntityVisible(skateboard.Driver, false, 0)
				TaskWarpPedIntoVehicle(skateboard.Driver, skateboard.Bike, -1)
				Wait(10)
			end

			SetEnableHandcuffs(skateboard.Driver, true)
			SetEntityInvincible(skateboard.Driver, true)
			FreezeEntityPosition(skateboard.Driver, true)

			local options = {
				{ action = function() TriggerEvent(getScript()..":Skateboard:GetOn", { board = skateboard.Skate, item = data.item, prop = data.prop }) end,
					icon = "fas fa-car", label = locale("targets", "getOn"), },
				{ action = function() TriggerEvent(getScript()..":Skateboard:PickPlace", { board = skateboard.Skate, item = data.item, prop = data.prop }) end,
					icon = "fas fa-hand-holding", label = locale("targets", "pickUp"), },
				{ action = function() TriggerEvent(getScript()..":client:showoff", data) end,
					icon = "far fa-user", label = locale("targets", "showOff"), },
				{ action = function() TriggerEvent(getScript()..":client:holdBoard", data) end,
					icon = "fas fa-hands-holding", label = locale("targets", "hold"), },
			}
			createEntityTarget(skateboard.Skate, options, 2.5)
			createEntityTarget(skateboard.Driver, options, 2.5)
			createEntityTarget(skateboard.Bike, options, 2.5)

			makeFakeSkateboard(Ped, false, data.prop)

			DisableCamCollisionForEntity(Ped)
			DisableCamCollisionForEntity(skateboard.Bike)
			DisableCamCollisionForEntity(skateboard.Skate)
			DisableCamCollisionForEntity(skateboard.Driver)
			SetVehicleDoorsLocked(skateboard.Bike, 10)
			storedVariables = skateboard
			SetEntityCoords(skateboard.Bike, GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, 1.5))
			SetEntityHeading(skateboard.Bike, GetEntityHeading(Ped)+90)
			lastItem = data.name
			if hasItem(data.name, 1) then
				removeItem(data.name, 1)
			end
			Dir = {}
		end
	end
end)

RegisterNetEvent(getScript()..":Skateboard:GetOn", function()
	local Ped = PlayerPedId()
	surfboard = false

	if isCat then
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.10, -0.78, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		playAnim("creatures@cat@move", "idle_upp", -1, 1)
	elseif isDog or isCoyote then
		if notSmallDog then
			AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.30, -0.55, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		else
			AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.40, -0.70, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		end
	else
		playAnim("move_strafe@stealth", "idle", -1, 1)
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
	end
	SetEntityCollision(Ped, true, true)
	Attached = true
	updateCamLoc()

	CreateThread(function()
		while Attached do
			overSpeed = (GetEntitySpeed(skateboard.Bike)*3.6) > 90
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
			end
			Wait(1000)
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