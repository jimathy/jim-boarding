local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local Props = {}
local Targets = {}
local Peds = {}

local skateboard = {}
local Dir = {}
RegisterNetEvent("jim-skateboard:PickPlace", function()
	if not IsPedSittingInAnyVehicle(PlayerPedId()) then
		if DoesEntityExist(skateboard.Entity) then
			exports["qb-target"]:RemoveTargetEntity(skateboard.Skate)
			Attached = false
			Wait(100)
			TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
			Wait(600)
			AttachEntityToEntity(skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
			Wait(900)
			DeleteVehicle(skateboard.Entity)
			destroyProp(skateboard.Skate)
			DeleteEntity(skateboard.Driver)
			toggleItem(true, "skateboard", 1)
			skateboard = {}
			Dir = {}
		else
			loadModel(`triBike3`)
			loadModel(`S_M_M_AutoShop_01`)
			loadModel(`v_res_skateboard`)
			skateboard.Entity = CreateVehicle(`triBike3`, 0, 0, 0, 0, true)
			skateboard.Skate = makeProp({ prop = `v_res_skateboard`, coords = vector4(0,0,0,0) }, 0, 1)
			SetEntityNoCollisionEntity(skateboard.Entity, PlayerPedId(), false)
			SetEntityNoCollisionEntity(skateboard.Skate, PlayerPedId(), false)

			-- Load models
			while not DoesEntityExist(skateboard.Entity) do Wait(5) end
			while not DoesEntityExist(skateboard.Skate) do Wait(5) end
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSteeringLock", 9.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fDriveInertia", 0.05)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fMass", 1800.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fPercentSubmerged", 105.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fDriveBiasFront", 0.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fInitialDriveForce", 0.25)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fInitialDriveMaxFlatVel", 135.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionCurveMax", 2.2)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionCurveMin", 2.12)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionCurveLateral", 22.5)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionSpringDeltaMax", 0.1)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fLowSpeedTractionLossMult", 0.7)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fCamberStiffnesss", 0.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionBiasFront", 0.478)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fTractionLossMult", 0.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionForce", 5.2)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionForce", 1.2)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionReboundDamp", 1.7)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionUpperLimit", 0.1)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionLowerLimit", -0.3)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionRaise", 0.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fSuspensionBiasFront", 0.5)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fAntiRollBarForce", 0.0)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fAntiRollBarBiasFront", 0.65)
			SetVehicleHandlingFloat(skateboard.Entity, "CHandlingData", "fBrakeForce", 0.53)

			SetEntityCompletelyDisableCollision(skateboard.Entity, true, true)
			SetEntityVisible(skateboard.Entity, false)
			AttachEntityToEntity(skateboard.Skate, skateboard.Entity, GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)

			local loc = vector4(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0).x, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0).y, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0).z, GetEntityHeading(PlayerPedId()))
			skateboard.Driver = makePed(68070371, loc, 0, 1, nil, nil)
			SetEntityNoCollisionEntity(skateboard.Driver, PlayerPedId(), false)

			-- Driver properties
			SetEnableHandcuffs(skateboard.Driver, true)
			SetEntityInvincible(skateboard.Driver, true)
			SetEntityVisible(skateboard.Driver, false)
			FreezeEntityPosition(skateboard.Driver, true)
			TaskWarpPedIntoVehicle(skateboard.Driver, skateboard.Entity, -1)

			Targets[#Targets+1] =
				exports["qb-target"]:AddTargetEntity(skateboard.Skate, { options = {
					{ event = "jim-skateboard:GetOn", icon = "fas fa-car", label = "Get on", board = skateboard.Skate },
					{ event = "jim-skateboard:PickPlace", icon = "fas fa-hand-holding", label = "Pick up", board = skateboard.Skate },
				}, distance = 2.5,	})

			loadAnimDict("pickup_object")
			AttachEntityToEntity(skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.10, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
			TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
			Wait(800)
			DetachEntity(skateboard.Entity, false, true)
			PlaceObjectOnGroundProperly(skateboard.Entity)
			toggleItem(false, "skateboard", 1)
			Dir = {}
		end
	end
end)

RegisterKeyMapping('skategetoff', 'Skateboard: Get Off', 'keyboard', 'G')
RegisterCommand('skategetoff', function()
	if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then
		if not IsEntityInAir(skateboard.Entity) then
			DetachEntity(PlayerPedId(), false, false)
			TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 100)
			Attached = false
			Dir = {}
			StopAnimTask(PlayerPedId(), "move_strafe@stealth", "idle", 1.0)
		end
	end
end)

RegisterKeyMapping('+skateforward', 'Skateboard: Forward', 'keyboard', 'W')
RegisterCommand('+skateforward', function()
	if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) and not overSpeed then
		CreateThread(function()
			if not Dir.forward then
				Dir.forward = true
				while Dir.forward do
					if not Dir.right and not Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 9, 0.1) end
					if Dir.left then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 7, 0.1) end
					if Dir.right then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 8, 0.1) end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skateforward', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then Dir.forward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 1) end end)

RegisterKeyMapping('+skatebackward', 'Skateboard: Backward', 'keyboard', 'S')
RegisterCommand('+skatebackward', function()
	if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) and not overSpeed then
		CreateThread(function()
			if not Dir.backward then
				Dir.backward = true
				while Dir.backward do
					if Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 13, 0.1)
					elseif Dir.right then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 14, 0.1)
					elseif not Dir.right and not Dir.left then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 22, 0.1)
					end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skatebackward', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then Dir.backward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 1) end end)

RegisterKeyMapping('+skateleft', 'Skateboard: Left', 'keyboard', 'A')
RegisterCommand('+skateleft', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) and not overSpeed then Dir.left = true end end)
RegisterCommand('-skateleft', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then	Dir.left = nil end end)


RegisterKeyMapping('+skateright', 'Skateboard: Right', 'keyboard', 'D')
RegisterCommand('+skateright', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) and not overSpeed then Dir.right = true end end)
RegisterCommand('-skateright', function() if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then Dir.right = nil end end)

RegisterKeyMapping('skatejump', 'Skateboard: Jump', 'keyboard', 'SPACE')
RegisterCommand('skatejump', function()
	if IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then
		if not IsEntityInAir(skateboard.Entity) then
			local vel = GetEntityVelocity(skateboard.Entity)
			TaskPlayAnim(PlayerPedId(), "move_crouch_proto", "idle_intro", 5.0, 8.0, -1, 0, 0, false, false, false)
			local duration = 0
			local boost = 0
			while IsControlPressed(0, 22) do
				Wait(10)
				duration = duration + 10.0
				ForceVehicleEngineAudio(skateboard.Entity, 0)
			end
			boost = 6.0 * duration / 250.0
			if boost > 6.0 then boost = 6.0 end
			StopAnimTask(PlayerPedId(), "move_crouch_proto", "idle_intro", 1.0)
			SetEntityVelocity(skateboard.Entity, vel.x, vel.y, vel.z + boost)
			TaskPlayAnim(PlayerPedId(), "move_strafe@stealth", "idle", 8.0, 2.0, -1, 1, 1.0, false, false, false)
		end
	end
end)

local Attached = false
local overSpeed
RegisterNetEvent("jim-skateboard:GetOn", function()
	loadAnimDict("move_strafe@stealth")
	loadAnimDict("move_crouch_proto")
	TaskPlayAnim(PlayerPedId(), "move_strafe@stealth", "idle", 8.0, 8.0, -1, 1, 1.0, false, false, false)
	AttachEntityToEntity(PlayerPedId(), skateboard.Entity, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
	SetEntityCollision(PlayerPedId(), true, true)
	Attached = true
	CreateThread(function()
		while Attached do
			StopCurrentPlayingAmbientSpeech(skateboard.Driver)
			overSpeed = (GetEntitySpeed(skateboard.Entity)*3.6) > 90
			local x, y, z = table.unpack(GetEntityRotation(skateboard.Entity))
			if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
				DetachEntity(PlayerPedId(), false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 1)
				Attached = false
				Dir = {}
				StopAnimTask(PlayerPedId(), "move_strafe@stealth", "idle", 1.0)
				SetPedToRagdoll(PlayerPedId(), 5000, 4000, 0, true, true, false)
			end

			if not DoesEntityExist(skateboard.Entity) then
				exports["qb-target"]:RemoveTargetEntity(skateboard.Skate)
				Attached = false
				Wait(100)
				TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
				Wait(600)
				AttachEntityToEntity(skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
				Wait(900)
				DeleteVehicle(skateboard.Entity)
				destroyProp(skateboard.Skate)
				DeleteEntity(skateboard.Driver)
				skateboard = {}
				Dir = {}
			end
			if not IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then
				DetachEntity(PlayerPedId(), false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 6, 2000)
				Attached = false
				Dir = {}
				StopAnimTask(PlayerPedId(), "move_strafe@stealth", "idle", 1.0)
			end
			Wait(1000)
		end
	end)
end)

AddEventHandler('onResourceStop', function(resource) if resource ~= GetCurrentResourceName() then return end
	for _, v in pairs(Peds) do unloadModel(GetEntityModel(v)) DeletePed(v) end
	for i = 1, #Props do unloadModel(GetEntityModel(Props[i])) DeleteObject(Props[i]) end
	DeleteEntity(cardHat)
	if DoesEntityExist(skateboard.Entity) then
		DeletePed(skateboard.Driver)
		DeleteVehicle(skateboard.Entity)
		DeleteObject(skateboard.Skate)
	end
end)