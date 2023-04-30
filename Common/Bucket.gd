class_name GlobalBucket
extends Node


var Party = [
	preload("res://Entity/AllyEntity/BrynhildrStats.tres"),
	preload("res://Entity/AllyEntity/FreijaStats.tres"),
	preload("res://Entity/AllyEntity/SigrunStats.tres")
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
