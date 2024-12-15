extends CharacterBody2D

@export var explosion_light : Sprite2D
@export var explosion_cloud : Sprite2D
@export var explosion_flash : Sprite2D

var timer = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !explosion_light:
		explosion_light = get_children()[1]
	if !explosion_cloud:
		explosion_cloud = get_children()[0]
	if !explosion_flash:
		explosion_flash = get_children()[2]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 1
	
	if timer < 10:
		explosion_flash.modulate.a = timer/10.0
	elif timer > 50:
		explosion_flash.modulate.a = 6-timer/10.0
	
	var lightscale = timer/6.0
	var lighta = 1-0.04*timer
	explosion_light.scale = Vector2(lightscale, lightscale)
	explosion_light.modulate.a = lighta
	
	var cloudscale = timer*0.05
	explosion_cloud.scale = Vector2(cloudscale, cloudscale)
	modulate.a = 1 - timer/80.0
	
	if timer > 150:
		queue_free()
	move_and_slide()
