Config = {
    Lan = "en",
    System = {
        Debug = false,
        EventDebug = false,

        Menu = "qb",
        Notify = "gta",
    },
    Crafting = {
        craftCam = true,
    }
}

SkateboardItemModels = {
    skateboard_01 = "v_res_skateboard"
}
SurfboardItemModels = {
    surfboard_01 = "prop_surf_board_01",
	surfboard_02 = "prop_surf_board_02",
    surfboard_03 = "prop_surf_board_03",
	surfboard_04 = "prop_surf_board_04",
	surfboard_05 = "prop_beach_lg_surf",
}


skateboard = {}
Dir = {}
storedVariables = {}

hold = false
Attached = false
trick = false
toggleCam = false
flipCam = false

lastModel = nil
customCam = nil
lastItem = nil

surfboard = false

function locale(section, string)
	if not string then
		print(section, "string is nil")
	end
    if not Config.Lan or Config.Lan == "" then return print("Error, no langauge set") end
    local localTable = Loc[Config.Lan]
    if not localTable then return "Locale Table Not Found" end
    if not localTable[section] then return "["..section.."] Invalid" end
    if not localTable[section][string] then return "["..string.."] Invalid" end
    return localTable[section][string]
end