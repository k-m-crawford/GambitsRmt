extends PathFollow2D

@export var speed = 0.5

@onready var path = get_parent()

# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	progress_ratio += delta * speed
