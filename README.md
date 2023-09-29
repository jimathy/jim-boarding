# ElectricSkateboardFiveM

```
Electric Skateboard is a script in develop who use a base of the script rd_cars.
If you have a supposition of upgrade to add in the script contact me in fiveM forum, my pseudo: 'Super_Chocolatine'.
```

## How to install:
1. Place the folder `ElectricSkateboard`` in your resources folder
2. Add `start ElectricSkateboard` in your `server.cfg`
3. Add the item to your items.lua:
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

This script use a base of the script `rdrp_rccars`` by qalle:
https://forum.fivem.net/t/release-rc-car-script/525015