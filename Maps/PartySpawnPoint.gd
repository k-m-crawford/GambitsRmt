extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 2
	for ally in _b.Party:
		var tscn = load(ally.tscn_path)
		var inst = tscn.instantiate()
		get_parent().add_child.call_deferred(inst)
		if i == 2:
			inst.manual_control = true
		inst.stats = ally
		inst.position.y = position.y + inst.position.y + i * 15
		inst.position.x = position.x + inst.position.x + i * 15
		EntityMgr.ally_entities.append(inst)
		inst.set_leader_entity(EntityMgr.ally_entities[0])
		i -= 1
	
	
