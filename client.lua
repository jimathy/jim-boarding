
local skateboard, Dir, customCam, Attached, overSpeed = {}, {}, nil, false, nil

local function configureSkateboard(entity)
	for k, v in pairs({
		["fSteeringLock"] = 9.0,
		["fDriveInertia"] = 0.05,
		["fMass"] = 1800.0,
		["fPercentSubmerged"] = 105.0,
		["fDriveBiasFront"] = 0.0,
		["fInitialDriveForce"] = 0.25,
		["fInitialDriveMaxFlatVel"] = 135.0,
		["fTractionCurveMax"] = 2.2,
		["fTractionCurveMin"] = 2.12,
		["fTractionCurveLateral"] = 22.5,
		["fTractionSpringDeltaMax"] = 0.1,
		["fLowSpeedTractionLossMult"] = 0.7,
		["fCamberStiffnesss"] = 0.0,
		["fTractionBiasFront"] = 0.478,
		["fTractionLossMult"] = 0.0,
		["fSuspensionForce"] = 1.2,
		["fSuspensionReboundDamp"] = 1.7,
		["fSuspensionUpperLimit"] = 0.1,
		["fSuspensionLowerLimit"] = -0.3,
		["fSuspensionRaise"] = 0.0,
		["fSuspensionBiasFront"] = 0.5,
		["fAntiRollBarForce"] = 0.0,
		["fAntiRollBarBiasFront"] = 0.65,
		["fBrakeForce"] = 0.53 }) do
		SetVehicleHandlingFloat(entity, "CHandlingData", k, v)
	end
end

local function makeFakeSkateboard(Ped, remove) -- The animation for picking up and placing the board
	local prop = makeProp({ prop = "v_res_skateboard", coords = vec4(0,0,0,0), false, true})
	if GetEntityModel(Ped) == `a_c_cat_01` then
		SetPedCanRagdoll(PlayerPedId(), false)
		AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 31086), 0.18, -0.14, 0.0, -87.0, -100.0, 1.0, true, true, false, false, 1, true)
	else
		AttachEntityToEntity(prop, Ped, GetPedBoneIndex(Ped, 57005), 0.3, 0.08, 0.09, -86.0, -60.0, 50.0, true, true, false, false, 1, true)
		playAnim("pickup_object", "pickup_low", -1, 0)
	end
	if remove then
		DeleteVehicle(skateboard.Bike)
		destroyProp(skateboard.Skate)
		DeletePed(skateboard.Driver)
	end
	Wait(900)
	destroyProp(prop)
end

RegisterNetEvent("jim-skateboard:PickPlace", function() local Ped = PlayerPedId()
	if not IsPedSittingInAnyVehicle(Ped) then
		if DoesEntityExist(skateboard.Bike) then
			removeEntityTarget(skateboard.Skate)
			removeEntityTarget(skateboard.Driver)
			removeEntityTarget(skateboard.Bike)
			Attached = false
			Wait(100)
			stopTempCam()
			makeFakeSkateboard(Ped, true) -- pick up animation
			addItem("skateboard", 1)
			skateboard = {}
			Dir = {}
		else
			local pedCoords = GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, -40.5)
			skateboard.Bike = makeVeh("triBike3", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0))
			skateboard.Skate = makeProp({ prop = "v_res_skateboard", coords = vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0) }, 1, 1)
			while not DoesEntityExist(skateboard.Bike) or not DoesEntityExist(skateboard.Skate) do Wait(5) end

			SetEntityNoCollisionEntity(skateboard.Bike, Ped, false)
			SetEntityNoCollisionEntity(skateboard.Skate, Ped, false)

			Wait(500)

			configureSkateboard(skateboard.Bike)

			SetEntityCompletelyDisableCollision(skateboard.Bike, true, true)
			SetEntityCompletelyDisableCollision(skateboard.Skate, true, true)

			SetEntityVisible(skateboard.Bike, Config.System.Debug, 0)

			AttachEntityToEntity(skateboard.Skate, skateboard.Bike, GetPedBoneIndex(Ped, 28422), 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

			skateboard.Driver = ClonePed(Ped, true, false, true)
			SetEntityCoords(skateboard.Driver, pedCoords.x, pedCoords.y, pedCoords.z, true)
			while not DoesEntityExist(skateboard.Driver) do Wait(0) end
			--skateboard.Driver = makePed("S_M_M_AutoShop_01", vec4(pedCoords.x, pedCoords.y, pedCoords.z, 0.0), 0, 1, nil, nil)
			SetEntityNoCollisionEntity(skateboard.Driver, Ped, false)
			SetEntityCompletelyDisableCollision(skateboard.Driver, true, true)

			SetEnableHandcuffs(skateboard.Driver, true)
			SetEntityInvincible(skateboard.Driver, true)
			FreezeEntityPosition(skateboard.Driver, true)

			while not IsPedSittingInAnyVehicle(skateboard.Driver) do
				SetEntityVisible(skateboard.Driver, Config.System.Debug, 0)
				TaskWarpPedIntoVehicle(skateboard.Driver, skateboard.Bike, -1)
				Wait(10)
			end

			local options = {
				{ action = function() TriggerEvent("jim-skateboard:GetOn", { board = skateboard.Skate }) end,
					icon = "fas fa-car", label = "Get on", board = skateboard.Skate },
				{ action = function() TriggerEvent("jim-skateboard:PickPlace", { board = skateboard.Skate }) end,
					icon = "fas fa-hand-holding", label ="Pick up", board = skateboard.Skate },
			}
			createEntityTarget(skateboard.Skate, options, 2.5)
			createEntityTarget(skateboard.Driver, options, 2.5)
			createEntityTarget(skateboard.Bike, options, 2.5)

			makeFakeSkateboard(Ped)

			DisableCamCollisionForEntity(skateboard.Bike)
			DisableCamCollisionForEntity(skateboard.Skate)
			DisableCamCollisionForEntity(skateboard.Driver)
			SetVehicleDoorsLocked(skateboard.Bike, 10)

			SetEntityCoords(skateboard.Bike, GetOffsetFromEntityInWorldCoords(Ped, 0.0, 0.5, 1.5))
			SetEntityHeading(skateboard.Bike, GetEntityHeading(PlayerPedId())+90)
			removeItem("skateboard", 1)
			Dir = {}
		end
	end
end)

RegisterKeyMapping('skategetoff', 'Skateboard: Get Off', 'keyboard', 'G')
RegisterCommand('skategetoff', function()
	if Attached then
		if not IsEntityInAir(skateboard.Bike) then
			stopTempCam()
			DetachEntity(PlayerPedId(), false, false)
			TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 100)
			Attached = false
			Dir = {}
			ClearPedTasks(PlayerPedId())
		end
	end
end)

RegisterKeyMapping('+skateforward', 'Skateboard: Forward', 'keyboard', 'W')
RegisterCommand('+skateforward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.forward then
				Dir.forward = true
				while Dir.forward do
					if not Dir.right and not Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 9, 0.1) end
					if Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 7, 0.1) end
					if Dir.right then TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 8, 0.1) end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skateforward', function() if Attached then Dir.forward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

RegisterKeyMapping('+skatebackward', 'Skateboard: Backward', 'keyboard', 'S')
RegisterCommand('+skatebackward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.backward then
				Dir.backward = true
				while Dir.backward do
					if Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 13, 0.1)
					elseif Dir.right then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 14, 0.1)
					elseif not Dir.right and not Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 22, 0.1)
					end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skatebackward', function() if Attached then Dir.backward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

RegisterKeyMapping('+skateleft', 'Skateboard: Left', 'keyboard', 'A')
RegisterCommand('+skateleft', function() if Attached and not overSpeed then Dir.left = true end end)
RegisterCommand('-skateleft', function() if Attached then	Dir.left = nil end end)

RegisterKeyMapping('+skateright', 'Skateboard: Right', 'keyboard', 'D')
RegisterCommand('+skateright', function() if Attached and not overSpeed then Dir.right = true end end)
RegisterCommand('-skateright', function() if Attached then Dir.right = nil end end)

RegisterKeyMapping('skatejump', 'Skateboard: Jump', 'keyboard', 'SPACE')
RegisterCommand('skatejump', function() local Ped = PlayerPedId()
	if Attached then
		if not IsEntityInAir(skateboard.Bike) then
			local vel = GetEntityVelocity(skateboard.Bike)
			if GetEntityModel(Ped) == `a_c_cat_01` then
				playAnim("creatures@cat@move", "idle_dwn", -1, 1)
			else
				playAnim("move_crouch_proto", "idle_intro", -1, 1)
			end
			local duration = 0
			local boost = 0
			while IsControlPressed(0, 22) do
				Wait(10)
				duration = duration + 10.0
			end
			boost = 6.0 * duration / 250.0
			if boost > 6.0 then boost = 6.0 end

			SetEntityVelocity(skateboard.Bike, vel.x, vel.y, vel.z + boost)
			if GetEntityModel(Ped) == `a_c_cat_01` then
				stopAnim("move_crouch_proto", "idle_dwn")
				playAnim("creatures@cat@move", "idle_upp", -1, 1)
			else
				stopAnim("move_crouch_proto", "idle_intro")
				playAnim("move_strafe@stealth", "idle", -1, 1)
			end
		end
	end
end)

local toggleCam = false
local flipCam = false
RegisterKeyMapping('skatecam', 'Skateboard: Unlock/Lock Cam', 'keyboard', 'H')
RegisterCommand('skatecam', function()
	if Attached then
		toggleCam = not toggleCam
		updateCamLoc()
	end
end)
RegisterKeyMapping('+flipcam', 'Skateboard: Flip Cam', 'keyboard', 'C')
RegisterCommand('+flipcam', function()
	if Attached then
		AttachCamToEntity(customCam, skateboard.Bike, 0.25, 2.0, 1.5, true)
		flipCam = true
	end
end)
RegisterCommand('-flipcam', function()
	if Attached then
		AttachCamToEntity(customCam, skateboard.Bike, 0.25, -2.0, 1.0, true)
		flipCam = false
	end
end)
function updateCamLoc()
	CreateThread(function()
		while toggleCam and Attached do
			local coord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, flipCam and -5.0 or 5.0, 0.0)
			if customCam == nil then
				customCam = createTempCam(coord, coord)
				AttachCamToEntity(customCam, skateboard.Bike, 0.25, -2.0, 1.0, true)
				startTempCam(customCam)
			end
			PointCamAtCoord(customCam, coord.x, coord.y, coord.z)
			Wait(0)
		end
		RenderScriptCams(false, true, 500, true, true)
		DestroyAllCams()
		customCam = nil
	end)
end

RegisterNetEvent("jim-skateboard:GetOn", function() local Ped = PlayerPedId()
	if GetEntityModel(Ped) == `a_c_cat_01` then
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.10, -0.78, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
		playAnim("creatures@cat@move", "idle_upp", -1, 1)
	else
		playAnim("move_strafe@stealth", "idle", -1, 1)
		AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
	end
	SetEntityCollision(Ped, true, true)
	Attached = true
	updateCamLoc()
	drawText(nil, {
		(Config.System.drawText == "gta" and "~INPUT_VEH_FLY_UNDERCARRIAGE~" or "[G]").." - "..Loc[Config.Lan].getoff,
		(Config.System.drawText == "gta" and "~INPUT_VEH_HEADLIGHT~" or "[H]") .." - "..Loc[Config.Lan].lockcam,
	}, "w")
	CreateThread(function()
		while Attached do
			StopCurrentPlayingAmbientSpeech(skateboard.Driver)
			overSpeed = (GetEntitySpeed(skateboard.Bike)*3.6) > 90
			local x, y, z = table.unpack(GetEntityRotation(skateboard.Bike))
			if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1)
				Attached = false
				Dir = {}
				if GetEntityModel(Ped) ~= `a_c_cat_01` then stopAnim("move_strafe@stealth", "idle") end
				SetPedToRagdoll(Ped, 5000, 4000, 0, true, true, false)
			end

			if not DoesEntityExist(skateboard.Bike) or GetPedInVehicleSeat(skateboard.Bike, -1) ~= skateboard.Driver then
				removeEntityTarget(skateboard.Skate)
				removeEntityTarget(skateboard.Bike)
				removeEntityTarget(skateboard.Driver)
				Attached = false
				Wait(100)
				makeFakeSkateboard(Ped, true)
				addItem("skateboard", 1)
				skateboard = {}
				Dir = {}
			end
			if not IsEntityAttachedToEntity(Ped, skateboard.Bike) then
				DetachEntity(Ped, false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 6, 2000)
				Attached = false
				Dir = {}
				if GetEntityModel(Ped) == `a_c_cat_01` then
					stopAnim("creatures@cat@move", "idle_upp")
					stopAnim("creatures@cat@move", "idle_dwn")
				else
					stopAnim("move_strafe@stealth", "idle")
				end
			end
			Wait(1000)
		end
		hideText()
	end)
end)

AddEventHandler('onResourceStop', function(r) if r ~= GetCurrentResourceName() then return end
	hideText()
	if DoesEntityExist(skateboard.Bike) then
		DeleteVehicle(skateboard.Bike)
	end
end)