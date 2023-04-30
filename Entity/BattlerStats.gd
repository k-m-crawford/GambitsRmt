class_name BattleStats
extends EntityStats

@export var name:String
@export var lvl:int = 1

@export_group("Point Stats")
@export var max_hp:int = 100
@export var hp:int = 100
@export var max_mp:int = 10
@export var mp:int = 10

@export_group("Damage Stats")
@export var stn:int = 10
@export var vit:int = 10
@export var mag:int = 10
@export var spr:int = 10

@export_group("Agility Stats")
@export var acc:float = 1.0
@export var eva:float = 0.0

@export_group("Ability and Spells")
@export var spell_book:Dictionary = {
	"Abilities": [],
	"BlackMagic": [],
	"WhiteMagic": [],
}

@export_group("Engine Reference")
@export var tscn_path:String
