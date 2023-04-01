extends HBoxContainer


@onready var names = get_node("Names").get_children()
@onready var hps = get_node("HP").get_children()


func _ready():
	
	var i = 2
	
	for ally in get_tree().get_nodes_in_group("Allies"):
		names[i].text = ally.stats.name
		hps[i].text = str(ally.stats.hp)
		names[i].visible = true
		hps[i].visible = true
		
		i -= 1
	
	while i >= 0:
		names[i].visible = false
		hps[i].visible = false
		i -= 1


func update_hitpoints(who):
	for i in range(0, 3):
		if names[i].text == who.name:
			hps[i].text = str(who.hp)
			return
	
	
