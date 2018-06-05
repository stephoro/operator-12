# Map Development

As you can see, we have a sample map (test.tmx), and a spritesheet for slug heads, tails, and the map tiles. Each has their own unique style of writing them using Tiled.

## General

So this folder will ignore any .png and .lua files you create or move here. You should copy the contents of the [/resources/images](../resources/images) folder to this folder. This is necessary due to the way Tiled saves things. It saves the shortest relative or absolute path to the images used. However, we want these paths to be relative to the images folder. Thus we put the images right in this folder and the saved files will reflect that in their path.

Additionally, you must save and export map and tilesheet files into the tiled folder so that the relative paths are formed correctly.

## Maps

So maps have some properties that the game relies on. The first layer is a layer of tiles, which is fairly straight-forward. The second layer must be an object layer. 

The object layer must have points dropped on the map that adhere to the following:

- `name` parameter denotes unique slugs
    - If multiple points are named the same, they will be part of the same slug
- `type` parameter denotes the slug's type
    - List of types can be found in [resources/slug/slugdefs.lua](../resources/slug/slugdefs.lua)
- `index` custom `int` property should denote the order of slug segements.
	- `1` is the first index, not zero.
- `team` the head point should have a `team` custom `int` property
	- `1` denotes player team
	- any other number denotes enemy team

Spawner points must have:

- `name` parameter set to `spawner`
- `type` parameter set to `spawner`
- `index` custom `int` property set to a unique int
	- starting at 1, increment in order pieces should be placed
- `spawner` custom `boolean` property set to `true`

## Tilesheets

Tilesheets are relatively uninteresting, but may have a `color` custom `string` property set to the hex string of a color like `ffffff` or `ff0033`.