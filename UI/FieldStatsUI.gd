class_name FieldStatsUI
extends HBoxContainer


@onready var names = $Names.get_children()
@onready var hps = $HP.get_children()
@onready var _charge_bars = $ChargeBars.get_children()

var charge_bars = [null, null, null]
var charge_bar_ticks = [null, null, null]

func _ready():
	
	var i = 2
	
	for ally in _b.Party:
		names[i].text = ally.name
		hps[i].text = str(ally.hp)
		names[i].visible = true
		hps[i].visible = true
		charge_bars[i] = _charge_bars[i].get_node("Bar")
		charge_bars[i].value = 0
		charge_bars[i].visible = true
		charge_bar_ticks[i] = 0
		
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


func set_charge_bar_val(who, val):
	for i in range(0, 3):
		if names[i].text == who.name:
			print("setting ", names[i].text, " charge bar cap to ", val)
			charge_bars[i].value = 0
			charge_bar_ticks[i] = val
			return


func update_charge_bar(who, val):
	for i in range(0, 3):
		if names[i].text == who.name:
			print("updating ", names[i].text, " charge bar val to ", charge_bar_ticks[i] - val, "(", charge_bar_ticks[i], ",",val,")")
			charge_bars[i].value = charge_bar_ticks[i] - val
