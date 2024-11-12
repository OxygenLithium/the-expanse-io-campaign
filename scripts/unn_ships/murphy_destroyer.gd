extends "res://scripts/unn_ships/enemy_ship.gd"


#Railgun stuff
@export var railgun : Node2D
var railgunRoundFile = load("res://scenes/weapon/enemyRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://radar_map/railgun_round_marker.tscn")
var railgunTimer = 280
const railgunRoundSpeed = 15000

func special_init():
	health = 100
	PDCLockDistance = 2500

func shoot_railgun():
	var railgunRound = railgunRoundFile.instantiate()
	railgunRound.allegiance = "UNN"
	railgunRound.rotation = railgun.rotation + rotation
	railgunRound.position = railgun.global_position + velocity/60 + Vector2(100,0).rotated(railgunRound.rotation)
	railgunRound.set_collision_layer_value(11, true)
	railgunRound.set_collision_mask_value(1, true)
	railgunRound.set_collision_mask_value(2, true)
	
	get_parent().add_child(railgunRound)
	railgunRound.velocity = velocity
	railgunRound.velocity += Vector2(railgunRoundSpeed,0).rotated(railgunRound.rotation)
	railgunRound.set_visible(true)
		
	var railgun_round_marker = railgunRoundMarkerFile.instantiate()
	railgun_round_marker.markerTarget = railgunRound
	$/root/Node/map_canvas/radar_map.add_child(railgun_round_marker)

func special_actions():
	railgun.look_at(target.global_position)
	railgunTimer += 1
	if railgunTimer > 60:
		shoot_railgun()
		railgunTimer = 0
	pass
