function configureSkateboard(entity)
	print("Configuring skateboard")
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
		["fBrakeForce"] = 0.53
	}) do
		SetVehicleHandlingFloat(entity, "CHandlingData", k, v)
	end
end

function configureSurfboard(entity)
	ModifyVehicleTopSpeed(entity, -40.0) -- Negative values reduce top speed
	SetVehicleEnginePowerMultiplier(entity, -20.0) -- Negative values reduce power
end

function removeBoard()
	--Clean up targets
	removeEntityTarget(storedVariables.Skate)
	removeEntityTarget(storedVariables.Driver)
	removeEntityTarget(storedVariables.Bike)
	removeEntityTarget(skateboard.Skate)
	removeEntityTarget(skateboard.Driver)
	removeEntityTarget(skateboard.Bike)
	--Remove entities
	DeleteVehicle(storedVariables.Bike)
	destroyProp(storedVariables.Skate)
	DeletePed(storedVariables.Driver)
	DeleteVehicle(skateboard.Bike)
	destroyProp(skateboard.Skate)
	DeletePed(skateboard.Driver)
	--Make sure tables are flushed
	surfboard = false
	storedVariables = {}
	skateboard = {}
end