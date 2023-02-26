extends HBoxContainer

func _ready():
	
	var i = 2

	var names = get_node("Names").get_children()
	var hps = get_node("HP").get_children()
	
	for ally in get_tree().get_nodes_in_group("Allies"):
		names[i].text = ally.stats.name
		hps[i].text = str(ally.stats.hp)
		names[i].visible = true
		hps[i].visible = true
		
		i -= 1
