class_name GlobalBucket
extends Node


var Party = [
	preload("res://Entity/AllyEntity/BrynhildrStats.tres"),
	preload("res://Entity/AllyEntity/HejraStats.tres")
]

var Inventory = {
	"Potion": 10,
	"Ether": 1,
	"Phoenix Down": 4
}


func _ready():
	randomize()


func debug(msg, obj):
	if obj.debug:
		print(msg)


func dmg_calc(
	base_stat,
	rand,
	def_stat,
	mult_base,
	mult_stat,
	src_lvl,
	add_mult_stat
):
	return (base_stat*rand - def_stat) * (mult_base + mult_stat * (src_lvl+add_mult_stat)/256)
