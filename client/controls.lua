RegisterKeyMapping('skategetoff', locale("keyMaps", "getOff"), 'keyboard', 'G')
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

RegisterKeyMapping('+skateforward', locale("keyMaps", "forward"), 'keyboard', 'W')
RegisterCommand('+skateforward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.forward then
				Dir.forward = true
				while Dir.forward do
					TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, ((Dir.left == true and 7) or (Dir.right == true and 8) or 9), 0.1)
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skateforward', function() if Attached then Dir.forward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

RegisterKeyMapping('+skatebackward', locale("keyMaps", "backward"), 'keyboard', 'S')
RegisterCommand('+skatebackward', function()
	if Attached and not overSpeed then
		CreateThread(function()
			if not Dir.backward then
				Dir.backward = true
				while Dir.backward do
					if surfboard then
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 0.1)
					else
						TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, ((Dir.left == true and 13) or (Dir.right == true and 14) or 22), 0.1)
					end
					Wait(50)
				end
			else return	end
		end)
	end
end)
RegisterCommand('-skatebackward', function() if Attached then Dir.backward = nil TaskVehicleTempAction(skateboard.Driver, skateboard.Bike, 1, 1) end end)

local pressed = false
RegisterKeyMapping('+skateleft', locale("keyMaps", "left"), 'keyboard', 'A')
RegisterCommand('+skateleft', function()
	if Attached and not overSpeed then
		if surfboard then
			surfBoardRotate(false)
		else
			Dir.left = true
		end
	end
end)
RegisterCommand('-skateleft', function()
	if Attached then
		pressed = false
		Dir.left = nil
	end
end)

RegisterKeyMapping('+skateright', locale("keyMaps", "right"), 'keyboard', 'D')
RegisterCommand('+skateright', function()
	if Attached and not overSpeed then
		if surfboard then
			surfBoardRotate(true)
		else
			Dir.right = true
		end
	end
end)
RegisterCommand('-skateright', function()
	if Attached then
		pressed = false
		Dir.right = nil
	end
end)

function surfBoardRotate(right)
	if not pressed then pressed = true end
	CreateThread(function()
		while pressed do
			local getRot = GetEntityRotation(skateboard.Bike, 2)
			if right then
				SetEntityRotation(skateboard.Bike, getRot.x, getRot.y, getRot.z-1, 2)
			else
				SetEntityRotation(skateboard.Bike, getRot.x, getRot.y, getRot.z+1, 2)
			end
			Wait(0)
		end
	end)
end

RegisterKeyMapping('skatejump', locale("keyMaps", "jump"), 'keyboard', 'SPACE')
RegisterCommand('skatejump', function() local Ped = PlayerPedId()
	if Attached and not surfboard then
		if not IsEntityInAir(skateboard.Bike) then
			if isCat then
				playAnim("creatures@cat@move", "idle_dwn", -1, 1)
			elseif (isDog or isCoyote) then
				--
			else
				playAnim("move_crouch_proto", "idle_intro", -1, 1)
			end
			local duration = 0
			local boost = 0
			local manual = false
			while IsControlPressed(0, 22) do
				Wait(10)
				duration += 10.0

				if duration > 1500 and not manual then
					manual = true
					AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.45, 0.0, -40.0, 90.0, false, true, true, true, 0, true)

					if isCat then
						AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, -0.10, -0.82, 40.04, 0.0, 0.0, true, true, false, true, 1, true)
					elseif (isDog or isCoyote) then
						AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.0, -0.45, 40.4, 0.0, 0.0, true, true, false, true, 1, true)
					else
						stopAnim("move_crouch_proto", "idle_intro")
						playAnim("move_strafe@stealth", "idle", -1, 1)
						AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, -0.5, -0.1, 40.0, 0.0, 0.0, true, true, false, true, 1, true)
					end
				end
			end
			boost = 6.0 * duration / 250.0
			if boost > 6.0 then boost = 6.0 end
			local vel = GetEntityVelocity(skateboard.Bike)

			manual = false
			--Reset if changes
			AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, -15.0, true, true, true, 2, true)
			if isCat then
				AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.10, -0.78, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
				playAnim("creatures@cat@move", "idle_upp", -1, 1)
			elseif (isDog or isCoyote) then
				if notSmallDog then
					AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.30, -0.55, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
				else
					AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.40, -0.70, 0.4, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
				end
			else
				playAnim("move_strafe@stealth", "idle", -1, 1)
				AttachEntityToEntity(Ped, skateboard.Bike, 20, 0.0, 0.15, 0.05, 0.0, 0.0, -15.0, true, true, false, true, 1, true)
			end

			SetEntityVelocity(skateboard.Bike, vel.x, vel.y, vel.z + boost)
			if isCat then
				stopAnim("move_crouch_proto", "idle_dwn")
				playAnim("creatures@cat@move", "idle_upp", -1, 1)

			elseif (isDog or isCoyote) then
				--
			else
				stopAnim("move_crouch_proto", "idle_intro")
				playAnim("move_strafe@stealth", "idle", -1, 1)
			end
		else
			if trick then return else trick = true end
			local chance = math.random(1, 3)

			local skill = 0
			if isStarted("jim-skills") then
				jsonPrint(exports["jim-skills"]:GetCurrentSkill("Skateboarding"))
				skill = exports["jim-skills"]:GetCurrentSkill("Skateboarding").TimeReduction or 0
			end
			--triggerNotify(nil, "Trick "..chance, "success")
			if chance == 1 then
				CreateThread(function()
					local origHeading = GetEntityHeading(skateboard.Bike)
					local speed = 8
					local spinChance = math.random(1, 2)
					for i = 1, (360 / speed)  do
						if IsEntityInAir(skateboard.Bike) then
							SetEntityHeading(skateboard.Bike, spinChance == 1 and (origHeading + (i * speed)) or (origHeading - (i * speed)))
							Wait(5 - (5 * (skill * 5)))
						else
							--triggerNotify(nil, (i * speed).."° full cab", "success")
							if isStarted("jim-skills") then
								exports["jim-skills"]:UpdateSkill("Skateboarding", (i * speed) / 100)
							end
							trick = false
							break
						end
					end
					--triggerNotify(nil, "Full 360° full cab", "success")
					trick = false
					if isStarted("jim-skills") then
						exports["jim-skills"]:UpdateSkill("Skateboarding", 3.6)
					end
				end)
			end
			if chance == 2 then
				CreateThread(function()
					local origRot = 0.0
					local speed = 8
					local spinChance = math.random(1, 2)
					for i = 1, (360 / speed)  do
						if IsEntityInAir(skateboard.Bike) then
							AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, spinChance == 1 and (origRot + (i * speed)) or (origRot - (i * speed)), 90.0, false, true, true, true, 1, true)
							Wait(5 - (5 * skill))
						else
							DetachEntity(Ped, false, false)
							SetPedToRagdoll(Ped, 5000, 4000, 0, true, true, false)
							AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)
							if isStarted("jim-skills") then exports["jim-skills"]:UpdateSkill("Skateboarding", (i * speed) / 100) end
							trick = false
							break
						end
					end
					trick = false
					if isStarted("jim-skills") then exports["jim-skills"]:UpdateSkill("Skateboarding", 3.6) end
				end)
			end
			if chance == 3 then
				CreateThread(function()
					local origRot = 90.0
					local speed = 8
					local spinChance = math.random(1, 2)
					for i = 1, (360 / speed)  do
						if IsEntityInAir(skateboard.Bike) then
							AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, 0.0, spinChance == 1 and (origRot + (i * speed)) or (origRot - (i * speed)), -15.0, true, true, true, 2, true)
							Wait(5 - (5 * skill))
						else
							DetachEntity(Ped, false, false)
							SetPedToRagdoll(Ped, 5000, 4000, 0, true, true, false)
							AttachEntityToEntity(skateboard.Skate, skateboard.Bike, nil, 0.0, 0.0, -0.60, 0.0, 0.0, 90.0, false, true, true, true, 1, true)
							if isStarted("jim-skills") then exports["jim-skills"]:UpdateSkill("Skateboarding", (i * speed) / 100) end
							trick = false
							break
						end
					end
					trick = false
					if isStarted("jim-skills") then exports["jim-skills"]:UpdateSkill("Skateboarding", 3.6) end
				end)
			end
		end
	end
end)

RegisterCommand('fixstuckskateboard', removeBoard)