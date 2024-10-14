extends CharacterBody2D

const type = "ship"
const allegiance = "UNN"

var rng = RandomNumberGenerator.new()

var player = "/root/Node/player"

var missileFile = load("res://scenes/weapon/missile.tscn")
var missileMarkerFile = load("res://radar_map/unn_missile_marker.tscn")

var shoot_timer = 0
var acceleration = 0

func shoot_missile():
	var missile = missileFile.instantiate()
	missile.allegiance = "UNN"
	missile.target = $/root/Node/player
	missile.set_collision_layer_value(10, true)
	missile.set_collision_mask_value(1, true)
	missile.set_collision_mask_value(2, true)
	missile.global_position = global_position
	get_parent().add_child(missile)
	missile.rotation = rotation
	missile.velocity = Vector2(100,0).rotated(rotation)
	
	var missile_marker = missileMarkerFile.instantiate()
	missile_marker.markerTarget = missile
	$/root/Node/map_canvas/radar_map.add_child(missile_marker)

func take_damage_missile():
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !get_node(player):
		move_and_slide()
		return
	look_at(get_node(player).global_position)
	
	if shoot_timer > 300:
		shoot_missile()
		shoot_timer = 0
	
	shoot_timer += 1
	
	velocity += Vector2(randf_range(-3,3),randf_range(-3,3))

	move_and_slide()
