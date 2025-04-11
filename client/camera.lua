RegisterKeyMapping('skatecam', 'Skateboard: Unlock/Lock Cam', 'keyboard', 'H')
RegisterCommand('skatecam', function()
	if Attached then
		SetCamActive(customCam, not IsCamActive(customCam))
		RenderScriptCams(IsCamActive(customCam), true, 500, true, true)
		--updateCamLoc()
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
		local ped = PlayerPedId()
		while Attached do
			makeInstructionalButtons({
				{ text = surfboard and Loc[Config.Lan].getoffSurf or Loc[Config.Lan].getoff, keys = { 47 } },
				{ text = Loc[Config.Lan].lockcam..": "..(toggleCam and "On" or "Off"), keys = { 74} },
				(not surfboard and { text = Loc[Config.Lan].jump, keys = { 102 } } or nil),
			})
			local coord = GetOffsetFromEntityInWorldCoords(ped, 0.0, flipCam and -5.0 or 5.0, 0.0)
			if customCam == nil then
				customCam = createTempCam(coord, coord)
				AttachCamToEntity(customCam, skateboard.Driver, 0.25, -2.0, 1.0, true)
			end

			PointCamAtEntity(customCam, skateboard.Skate, 0, 0, 1.7)
			Wait(0)
		end
		RenderScriptCams(false, true, 500, true, true)
		DestroyAllCams()
		customCam = nil
	end)
end