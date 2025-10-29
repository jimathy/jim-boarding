Config = {
    Lan = "en",
    System = {
        Debug = false,
        EventDebug = false,

		Menu = "qb",				-- "qb", "ox", "lation", "gta"
		Notify = "gta",				-- "qb", "ox", "esx", "lation", "okok", "gta"

		enableCam = true,			-- Enables customs cameras when crafting etc.
    },
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

-- Function for locales
-- Don't touch unless you know what you're doing
-- This needs to be here because it loads before everything else
function locale(section, string)
    if not Config.Lan or Config.Lan == "" then
        print("^1Error^7: ^3Config^7.^3Lan ^1not set^7, ^2falling back to Config.Lan = 'en'")
        Config = Config or {}
        Config.Lan = "en"
    end

    local localTable = Loc[Config.Lan]
    -- If Loc[..] doesn't exist, warn user
    if not localTable then
		print("Locale Table '"..Config.Lan.."' Not Found")
        return "Locale Table '"..Config.Lan.."' Not Found"
    end

    -- If Loc[..].section doesn't exist, warn user
    if not localTable[section] then
		print("^1Error^7: Locale Section: ['"..section.."'] Invalid")
        return "Locale Section: ['"..section.."'] Invalid"
    end

    -- If Loc[..].section.string doesn't exist, warn user
    if not localTable[section][string] then
		print("^1Error^7: Locale String: ['"..section.."']['"..string.."'] Invalid")
        return "Locale String: ['"..string.."'] Invalid"
    end

    -- If no issues, return the string
    return localTable[section][string]
end