# Jim-Skateboard

## What is it?

"Electric" Skateboard is a script completely remade from, but based on rd_cars.

This script handles using skateboards as items to ride them around the map

The player can do skate tricks on the skateboard to show off their skills

The best part is they can fail them and faceplant it <3

There is also support for animal peds to ride them, they wil thank you but the other players with complain like its the worst thing in their life

Supports the addition of multiple skateboard items if you have custom models you wish to add
 - Just add a new item, and place the itemname and model in the config

Starting support for SurfBoards, but cant figure out how to shut them up, any help with that would be great
- I believe I need a placeholder jetski vehicle with the audio muted, but this is beyond my abilities

### Disclaimer:
```
This is based originally on "ElectricSkateboardFiveM" but completely rewritten and changed to handle newer fivem features

With the help of `jim_bridge` this also brings more optimization and more features and works on multiple frameworks
```

## How to install:
1. Install `jim_bridge` from github and add it before this script in your server load order
2. Place the folder `jim-skateboard` in your resources folder
3. Add `start jim-skateboard` in your `server.cfg`

### QB:
4. Add the items to your `[qb]/qb-core/shared/items.lua`:
```lua
skateboard_01 = { name = "skateboard_01", label = "Skateboard", weight = 100, type = "item", image = "skateboard_01.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Skateboard"},

surfboard_01 = { name = "surfboard_01", label = "Surfboard", weight = 100, type = "item", image = "surfboard_01.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Surfboard"},
surfboard_02 = { name = "surfboard_02", label = "Surfboard", weight = 100, type = "item", image = "surfboard_02.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Surfboard"},
surfboard_03 = { name = "surfboard_03", label = "Surfboard", weight = 100, type = "item", image = "surfboard_03.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Surfboard"},
surfboard_04 = { name = "surfboard_04", label = "Surfboard", weight = 100, type = "item", image = "surfboard_04.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Surfboard"},
surfboard_05 = { name = "surfboard_05", label = "Surfboard", weight = 100, type = "item", image = "surfboard_05.png", unique = true, useable = true, shouldClose = true, combinable = nil, description = "Surfboard"},
```
4. Add the images from `_install/images` to your inventory eg. `[qb]/qb-inventory/html/images`

### OX:
4. Add the items to your `[ox]/ox_inventory/data/items.lua`:
```lua
    ["skateboard_01"] = {
		label = "Skateboard", weight = 500, stack = false, close = true, description = "Skateboard",
		client = { image = "skateboard_01.png", event = "jim-boarding:Skateboard:PickPlace" },
		buttons = {
            {   label = "Show Board",
                action = function()
                    TriggerEvent('jim-boarding:client:showoff', { item = "skateboard_01", skip = true })
                end,
            }
        }
	},

    ["surfboard_01"] = {
        label = "Surfboard",
        weight = 500,
        stack = false,
        close = true,
        description = "",
        client = { image = "surfboard_01.png", event = "jim-boarding:Surfboard:PickPlace" },
    },
    ["surfboard_02"] = {
        label = "Surfboard",
        weight = 500,
        stack = false,
        close = true,
        description = "",
        client = { image = "surfboard_02.png", event = "jim-boarding:Surfboard:PickPlace" },
    },
    ["surfboard_03"] = {
        label = "Surfboard",
        weight = 500,
        stack = false,
        close = true,
        description = "",
        client = { image = "surfboard_03.png", event = "jim-boarding:Surfboard:PickPlace" },
    },
    ["surfboard_04"] = {
        label = "Surfboard",
        weight = 500,
        stack = false,
        close = true,
        description = "",
        client = { image = "surfboard_04.png", event = "jim-boarding:Surfboard:PickPlace" },
    },
    ["surfboard_05"] = {
        label = "Surfboard",
        weight = 500,
        stack = false,
        close = true,
        description = "Surf Rescue",
        client = { image = "surfboard_05.png", event = "jim-boarding:Surfboard:PickPlace" },
    },

```
4. Add the images from `_install/images` to your inventory eg. `[ox]/ox_inventory/web/images`

5. Start your server

## How to use:
```
- Use the board in your inventory to place on the ground
- Target the board and choose "Get on"
- When you want to get off the skateboard press "G"
- Target the board again and choose "Pick up" to pick it up again
- Press the arrows to move the skateboard
```
## How to add new skateboards/surfboards
```
- You would need to add the items to yoyr inventory
- Make an image or just use skateboard_01 until then
- You would need a model hash/name and place it in the table config of this script
- When placing the board, the model is spawned and detected using that table
- Done
```

### This script uses a base of the script rdrp_rccars by qalle:
https://forum.fivem.net/t/release-rc-car-script/525015
