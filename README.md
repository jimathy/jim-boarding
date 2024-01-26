# Jim-Skateboard

```
Electric Skateboard is a script in develop who use a base of the script rd_cars.
If you have a supposition of upgrade to add in the script contact me in fiveM forum, my pseudo: 'Super_Chocolatine'.
```

Disclaimer:
```
This is based originally on ElectricSkateboardFiveM but completely rewritten and changed to handle newer fivem features
With the help of `jim_bridge` this also brings more optimization and more features and works on supported frameworks
```

## How to install:
1. Install `jim_bridge` from github and add it before this script in your server load order
2. Place the folder 'jim-skateboard' in your resources folder
3. Add `start jim-skateboard` in your `server.cfg`
4. Add the item to your items.lua:
```lua
	["skateboard"] 	  	= {["name"] = "skateboard",			["label"] = "Skateboard",		["weight"] = 1,    ["type"] = "item", ["image"] = "skateboard.png", 	["unique"] = true, 	["useable"] = true, 	["shouldClose"] = true,    ["combinable"] = nil,   ["description"] = ""},
```
4. Add the image to your inventory images
5. Start your server

## How to use:
- Use the board in your inventory to place on the ground
- Target the board and choose "Get on"
- When you want to get off the skateboard press "G"
- Target the board again and choose "Pick up" to pick it up again
- Press the arrows to move the skateboard

This script use a base of the script  rdrp_rccars by qalle:
https://forum.fivem.net/t/release-rc-car-script/525015