tool
extends TileSet

const GRASS = 0
const DIRT = 1
const WATER_CLIFF = 2
const WATER_SHORE = 3
const GRASS_CLIFF_SM = 11
const DIRT_CLIFF_SM = 12
const STAIRS = [5, 6, 7, 8, 9, 10]
const LEDGE_OVERHANG = 14
const LEDGE_OVERHANG_SPECIALS = [15, 16, 17]
const CLIFF_FACE = [25, 26, 27, 28]

var binds = {
	GRASS: [DIRT],
	WATER_CLIFF: [WATER_SHORE] + STAIRS,
	WATER_SHORE: [WATER_CLIFF],
	GRASS_CLIFF_SM: [GRASS, DIRT, LEDGE_OVERHANG] + STAIRS,
	DIRT_CLIFF_SM: [DIRT] + STAIRS,
	LEDGE_OVERHANG: [GRASS, GRASS_CLIFF_SM] + LEDGE_OVERHANG_SPECIALS + CLIFF_FACE,
	LEDGE_OVERHANG_SPECIALS: [GRASS, GRASS_CLIFF_SM] + LEDGE_OVERHANG_SPECIALS + CLIFF_FACE
}

func _is_tile_bound(drawn_id, neighbor_id):
	if drawn_id in binds:
		return neighbor_id in binds[drawn_id]
	return false
