require("util")
local isMain = Util.isMain()
require("battle/map")
require("ai/ai")
require("ai/player")
require("tiled/tilesets")
require("battle/ui")
require("battle/selection-mode")
Battle = {}

--[[--
Load the slugs, load the map, prepare for battle

@param argv[2] name of map to load
]]
function Battle.Start(argc, argv)
   player = PlayerModel.new()
   name = argv[2]
   dofile("slug/slug.lua")
   framedelay = 1000//60
   if name == nil then
	  name = "test.lua"
   end
   map = Map.new(dofile("maps/"..name))
   overlay = {dofile("battle/overlay.lua")}
   Tileset.loadSurfaces(overlay)
   overlay:asTextures()
   overlay:loadTilesets()
   BattleUI.init()
   BattleUI.map = map
   static.framedelay(framedelay)
   SlugSelect.Begin(dofile("data/static/inv.lua"))
end

--[[
   resize things

   @param w 
   @param h 
]]
function Battle.Resize(w, h)
   SCREEN_WIDTH = w
   SCREEN_HEIGHT = h
   map:recenter()
   BattleUI.resize()
end

--[[--
draw things, update map
]]
function Battle.Update()
   --Update = static.quit
   map:update()
   map:draw()
   if Player.slug then
	  Player.slug:drawOverlay()
   end
   BattleUI.draw()
end

--[[
destroy things
]]
function Battle.End()
   Tileset.destroyTilesets(overlay)
   overlay = nil
   Slug.unload()
   map:destroy()
   BattleUI.destroy()
   map = nil
   player:destroy()
   player = nil
end

--[[--
   pan camera about map or quit

@param key 
]]
function Battle.KeyDown(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP then
	  map.dy = -map.speed
   elseif key == KEY_DOWN then
	  map.dy = map.speed
   elseif key == KEY_LEFT then
	  map.dx = -map.speed
   elseif key == KEY_RIGHT then
	  map.dx = map.speed
   end
end

--[[--
Stop panning or quit

@param key 
]]
function Battle.KeyUp(key)
   if key == KEY_ESCAPE then
	  static.quit()
   elseif key == KEY_UP and map.dy < 0 then
	  map.dy = 0
   elseif key == KEY_DOWN and map.dy > 0 then
	  map.dy = 0
   elseif key == KEY_LEFT and map.dx < 0 then
	  map.dx = 0
   elseif key == KEY_RIGHT and map.dx > 0 then
	  map.dx = 0
   elseif key == KEY_SPACE then
	  if active == Player.move then
		 Player.beginAttack()
	  elseif active == Player.attack then
		 Player.nextTurn()
	  end
   end
end

function Battle.MouseWheel(x,y,dx,dy)
   BattleUI.MouseWheel(x, y, dx, dy)
end

--[[
   Trigger movement/attack or whatever other action is currently active

@param x 
@param y 

@return
]]
function Battle.MouseDown(x, y)
   BattleUI.MouseDown(x,y)
end

function Battle.MouseMove(x, y)
   BattleUI.MouseMove(x, y)
end

function Battle.MouseUp(x, y)
   if BattleUI.MouseUp(x, y) then
	  return
   end
   if active ~= nil then
	  local px, py = Map.positionToCoords(x,y)	  
	  active(px,py)
   end
end

Util.try(isMain, Battle)
