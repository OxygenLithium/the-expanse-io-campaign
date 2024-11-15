extends "res://scripts/unn_ships/enemy_ship.gd"


#Railgun stuff
@export var railgun : Node2D
var railgunRoundFile = load("res://scenes/weapon/enemyRailgunRound.tscn")
var railgunRoundMarkerFile = load("res://radar_map/railgun_round_marker.tscn")
var railgunWarning = load("res://hud/railgunWarning.tscn")
var railgunTimer = rng.randi_range(0,150)
const railgunRoundSpeed = 15000
const railgunRange = 15000

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
	
	var railgun_warning = railgunWarning.instantiate()
	railgun_warning.target = railgunRound
	$/root/Node/map_canvas.add_child(railgun_warning)

func calc_railgun_lead():
	if "acceleration" in target:
		return (target.velocity - velocity)*((target.global_position-global_position).length()/railgunRoundSpeed) + Vector2(target.acceleration,0).rotated(target.rotation)*(((target.global_position-global_position).length()/railgunRoundSpeed)**2)*30
	return (target.velocity - velocity)*((target.global_position-global_position).length()/railgunRoundSpeed)

func special_actions():
	railgun.look_at(target.global_position + calc_railgun_lead())
	railgunTimer += 1
	if railgunTimer > 600 and (target.global_position-global_position).length() < railgunRange:
		shoot_railgun()
		railgunTimer = rng.randi_range(0,60)
	pass
