extends CharacterBody2D

const type = "ship"
const allegiance = "UNN"

var rng = RandomNumberGenerator.new()

var player = "/root/Node/player"

var missileFile = load("res://scenes/weapon/missile.tscn")
var missileMarkerFile = load("res://radar_map/missile_marker.tscn")

var shoot_timer = 0

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.global_position = global_position
	missile.rotation = rotation
	get_parent().add_child(missile)
	missile.velocity = Vector2(100,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.missile = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !get_node(player):
		move_and_slide()
		return
	look_at(get_node(player).global_position)
	
	if shoot_timer > 180:
		shoot_missile()
		shoot_timer = 0
	
	shoot_timer += 1

	move_and_slide()
