require("util")
Map = {}

Map.__index = metareplacer(Map)

Map.tilesep = 10
Map.tilesize = 40 -- rewritten

-- create a new Map
-- assumes control of data
function Map.new (data)
   tilew = data.tilesets[1].tilewidth
   tileh = data.tilesets[1].tileheight
   local tilesets = data.tilesets
   for i, v in ipairs(tilesets) do
	  local t, w, h = Texture.new("images/" .. v.image)
	  v.sheet = t
	  v.w = w // v.tilewidth
   end
   
   local tilesize = tilew
   Map.tilesize = tilesize
   local tilesep = 10
   local tmap = data.layers[1].data
   local objects = {}
   local t = {map=tmap,
			  objects = objects,
			  tilesets=tilesets,
			  width=data.width,
			  height=data.height,
			  x=0,
			  y=0,
			  dx=0, dy=0, speed=5}
   --print(t.x, t.y)
   setmetatable(t, Map)
   map = t
   for i, dat in ipairs(tmap) do
	  objects[i] = false
	  local j = 1
	  if dat <= 0 then
		 tmap[i] = false
	  else
		 while dat > tilesets[j].tilecount do
			dat = dat - tilesets[j].tilecount
			j = j + 1
		 end
		 
		 local v = tilesets[j]
		 --print((i % data.width) * (tilesize + tilesep),  (i// data.width) * (tilesize + tilesep))
		 dat = dat - 1
		 local x, y = Map.basePosition((i-1) % data.width + 1, (i-1) // data.width + 1)
		 tmap[i] = Sprite.new(v.sheet,
							  x,
							  y,
							 tilesize,
							 tilesize,
							 (dat % v.w)*v.tilewidth,
							 (dat // v.w)*v.tileheight)
	  end
   end
   Slug.load()
   Slug.spawn(data.layers[2].objects)
   for k,v in pairs(slugs) do
	  t.slug = v
   end
   map.x = (SCREEN_WIDTH - (data.width * (tilesize + tilesep) - tilesep))//2
   map.y = (SCREEN_HEIGHT - (data.height * (tilesize + tilesep) - tilesep))//2
   return t
end

function Map.indexOf(self,x,y)
   return (x-1) + (y - 1) * self.width + 1
end

-- map game logic
function Map.update(self)
   self.x = self.x - self.dx
   self.y = self.y - self.dy
end

function Map.positionToCoords(x,y)
   return (x - map.x)//(Map.tilesize + Map.tilesep) + 1,
   (y - map.y)//(Map.tilesize + Map.tilesep) + 1
end

-- get map pixel position from grid coords
function Map.position(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return ((x - 1) * (Map.tilesize + Map.tilesep) + map.x), ((y - 1) * (Map.tilesize + Map.tilesep) + map.y)
end

-- get map pixel position from grid coords
function Map.basePosition(x,y)
   --ehhhhhh global var abuse but like who cares rn
   return ((x - 1) * (Map.tilesize + Map.tilesep)), ((y - 1) * (Map.tilesize + Map.tilesep))
end

-- click on map -> do someting 
function Map.mousedown(self,x,y)
   local x,y = Map.positionToCoords(x,y)
   if x > 0 and x <= self.width and y > 0 and y <= self.width then
	  if self.slug then
		 self.slug:move(x, y)
	  end
   end
end

-- draw map to screen
function Map.draw (self)
   for i, v in ipairs(self.map) do
	  if v then
		 v:draw(map.x, map.y)
	  end
	  if self.objects[i] then
		 self.objects[i]:draw()
	  end
   end
end

-- deallocate map
function Map.destroy (self)
   for i, v in ipairs(self.tilesets) do
	  Texture.destroy(v.sheet)
   end

   for i, v in ipairs(self.map) do
	  if v then
		 v:destroy()
	  end
   end
end
