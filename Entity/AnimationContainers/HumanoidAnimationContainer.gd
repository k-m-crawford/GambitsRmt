extends AnimationContainer

export var battle_textures = {}
export var move_textures = {}

onready var body_texture = $Body
onready var hair_texture = $Hair
onready var outfit_texture = $Outfit
onready var weapon_texture = $Weapon

func _ready():
	weapon_texture.visible = false

func set_textures(type):
	
	match type:
		
		"Move":
			weapon_texture.visible = false
			body_texture.texture = move_textures["body_p1"]
			outfit_texture.texture = move_textures["outfit_p1"]
			hair_texture.texture = move_textures["hair_p1"]
			
		"DrawWeapon":
			weapon_texture.visible = true
			body_texture.texture = battle_textures["body_p1"]
			hair_texture.texture = battle_textures["hair_p1"]
			outfit_texture.texture = battle_textures["outfit_p1"]
			weapon_texture.texture = battle_textures["weapon_p1"]

		"BattleEngagedMove":
			weapon_texture.visible = true
			body_texture.texture = battle_textures["body_p2"]
			hair_texture.texture = battle_textures["hair_p2"]
			outfit_texture.texture = battle_textures["outfit_p2"]
			weapon_texture.texture = battle_textures["weapon_p2"]
			
		"Attack":
			weapon_texture.visible = true
			body_texture.texture = battle_textures["body_p3"]
			hair_texture.texture = battle_textures["hair_p3"]
			outfit_texture.texture = battle_textures["outfit_p3"]
			weapon_texture.texture = battle_textures["weapon_p3"]
			
