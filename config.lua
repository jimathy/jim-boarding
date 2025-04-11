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

isCat = false
isDog = false
isCoyote = false
notSmallDog = false

surfboard = false