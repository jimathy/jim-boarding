local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local Props = {}
local Targets = {}
local Peds = {}

local skateboard = {}
RegisterNetEvent("jim-skateboard:PickPlace", function()
	if DoesEntityExist(skateboard.Entity) then
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
	else
		loadModel(`triBike3`)
		loadModel(68070371)
		loadModel(`v_res_skateboard`)
		skateboard.Entity = CreateVehicle(`triBike3`, 0, 0, 0, 0, true)
		skateboard.Skate = makeProp({prop = `v_res_skateboard`, coords = vector4(0,0,0,0)}, 0, 1)
		SetEntityNoCollisionEntity(skateboard.Entity,PlayerPedId(), false)
		SetEntityNoCollisionEntity(skateboard.Skate,PlayerPedId(), false)

		-- load models
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

		SetEntityNoCollisionEntity(skateboard.Entity, PlayerPedId(), false) -- disable collision between the player and the rc
		SetEntityNoCollisionEntity(skateboard.Skate,PlayerPedId(), false)
		SetEntityCollision(skateboard.Entity, true, true)
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
			exports["qb-target"]:AddTargetEntity(skateboard.Entity, { options = {
				{ event = "jim-skateboard:GetOn", icon = "fas fa-car", label = "Get on", board = skateboard.Entity },
				{ event = "jim-skateboard:PickPlace", icon = "fas fa-hand-holding", label = "Pick up", board = skateboard.Entity },
			}, distance = 2.5,	})

		--TriggerServerEvent("jim-skateboard:ShareTarget", NetworkGetNetworkIdFromEntity(skateboard.Entity))
		--can't figure out how to an entity id with other players so they can target it too

		loadAnimDict("pickup_object")
		AttachEntityToEntity(skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.10, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
		TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
		Wait(800)
		DetachEntity(skateboard.Entity, false, true)
		PlaceObjectOnGroundProperly(skateboard.Entity)
		toggleItem(false, "skateboard", 1)
	end
end)

--[[RegisterNetEvent("jim-skateboard:GetTarget", function(board, src)
	print(src)
	print(PlayerPedId())
	print(board)

	print(NetToEnt(board))
	Targets[#Targets+1] =
		exports["qb-target"]:AddTargetEntity(NetToEnt(board), { options = {
			{ event = "jim-skateboard:PickPlace", icon = "fas fa-hand-holding", label = "Pick up", board = NetToEnt(board) },
		}, distance = 2.5,	})
end)]]

local Attached = false
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

			local x = GetEntityRotation(skateboard.Entity).x
			local y = GetEntityRotation(skateboard.Entity).y
			if (-40.0 < x and x > 40.0) or (-40.0 < y and y > 40.0) then
				DetachEntity(PlayerPedId(), false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 1)
				Attached = false
				StopAnimTask(PlayerPedId(), "move_strafe@stealth", "idle", 1.0)
				SetPedToRagdoll(PlayerPedId(), 5000, 4000, 0, true, true, false)
			end

			if IsControlJustReleased(0, 113) then DetachEntity(PlayerPedId(), false, false) end
			local overSpeed = (GetEntitySpeed(skateboard.Entity)*3.6) > 90
			TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 1)
			ForceVehicleEngineAudio(skateboard.Entity, 0)

			if IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then
				TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 9, 1)
			end
			if IsControlPressed(0, 22) then
				-- Jump system
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
			if IsControlJustReleased(0, 87) or IsControlJustReleased(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 6, 2500)	end
			if IsControlPressed(0, 88) and not IsControlPressed(0, 87) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 22, 1) end
			if IsControlPressed(0, 89) and IsControlPressed(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 13, 1) end
			if IsControlPressed(0, 90) and IsControlPressed(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 14, 1) end
			if IsControlPressed(0, 87) and IsControlPressed(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 30, 100) end
			if IsControlPressed(0, 89) and IsControlPressed(0, 87) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 7, 1) end
			if IsControlPressed(0, 90) and IsControlPressed(0, 87) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 8, 1) end
			if IsControlPressed(0, 89) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 4, 1) end
			if IsControlPressed(0, 90) and not IsControlPressed(0, 87) and not IsControlPressed(0, 88) and not overSpeed then TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 5, 1) end

			if not DoesEntityExist(skateboard.Entity) then
				Attached = false
				Wait(100)
				TaskPlayAnim(PlayerPedId(), "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
				Wait(600)
				AttachEntityToEntity(skateboard.Entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(),  28422), -0.1, 0.0, -0.2, 70.0, 0.0, 270.0, 1, 1, 0, 0, 2, 1)
				Wait(900)
				DeleteVehicle(skateboard.Entity)
				destroyProp(skateboard.Skate)
				DeleteEntity(skateboard.Driver)
				skateboard = {}
			end
			if not IsEntityAttachedToEntity(PlayerPedId(), skateboard.Entity) then
				DetachEntity(PlayerPedId(), false, false)
				TaskVehicleTempAction(skateboard.Driver, skateboard.Entity, 1, 100)
				Attached = false
				StopAnimTask(PlayerPedId(), "move_strafe@stealth", "idle", 1.0)
			end
			Wait(7)
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