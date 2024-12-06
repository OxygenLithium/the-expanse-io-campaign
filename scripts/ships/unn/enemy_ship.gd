extends "res://scripts/ships/common/ai_ship.gd"

#Stats called by others

#Imported paths
@onready var player = get_parent().player

var enemyMarkerFile = load("res://scenes/map/enemy_marker.tscn")

func ai_ship_init():
	#Defining variables
	missileFile = load("res://scenes/projectiles/unn/UNNMissile.tscn")
	missileMarkerFile = load("res://scenes/map/unn_missile_marker.tscn")
	bulletFile = load("res://scenes/projectiles/unn/enemyBullet.tscn")
	bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")
	
	allegiance = "UNN"
	enemyShips = get_parent().MCRNShips
	friendlyShips = get_parent().UNNShips
	PDCTargetingEffectiveness = 8
	timeBetweenPDC = 5
	target = player
	
	health = 50
	acceleration = 1.5
	standardAcceleration = 1.5
	
	#Initiation operations
	marker = enemyMarkerFile.instantiate()
	marker.markerTarget = self
	get_parent().map_canvas.radar_map.add_child(marker)
	
	special_init()

#AI Distance Control
const minDistance = 0
const maxDistance = 0

func special_init():
	pass

func special_actions():
	pass
	
func ai_ship_processes():
	special_actions()
