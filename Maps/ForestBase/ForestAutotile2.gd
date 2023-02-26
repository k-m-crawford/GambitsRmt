tool
extends TileSet

const GRASS_HILL = 0
const DIRT_HILL = 1
const GRASS = 2
const DIRT = 3
const WATER_AUTO = 4
const WATER_BASE = 5
const CLIFFSIDE = 6
const CLIFFSIDE_SPECIALS = 7
const STAIRS = [8, 9]

var binds = {
	DIRT: [DIRT_HILL, GRASS_HILL] + STAIRS,
	GRASS_HILL: [GRASS, DIRT, DIRT_HILL] + STAIRS,
	DIRT_HILL: [GRASS, DIRT, GRASS_HILL] + STAIRS,
	CLIFFSIDE: [GRASS, DIRT, CLIFFSIDE_SPECIALS] + STAIRS,
	WATER_AUTO: [WATER_BASE, GRASS_HILL, DIRT_HILL, CLIFFSIDE, CLIFFSIDE_SPECIALS] + STAIRS
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
