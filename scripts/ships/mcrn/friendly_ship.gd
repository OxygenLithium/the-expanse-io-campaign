extends "res://scripts/ships/common/ai_ship.gd"

#Stats called by others

#Imported paths
var friendMarkerFile = load("res://scenes/map/friend_marker.tscn")

func ai_ship_init():
	#Defining variables
	missileFile = load("res://scenes/projectiles/mcrn/MCRNMissile.tscn")
	missileMarkerFile = load("res://scenes/map/mcrn_missile_marker.tscn")
	bulletFile = load("res://scenes/projectiles/mcrn/bullet.tscn")
	bulletMarkerFile = load("res://scenes/map/bullet_marker.tscn")
	
	allegiance = "MCRN"
	enemyShips = get_parent().UNNShips
	friendlyShips = get_parent().MCRNShips
	PDCTargetingEffectiveness = 10
	
	health = 100
	acceleration = 2
	standardAcceleration = 2
	
	#Initiation operations
	marker = friendMarkerFile.instantiate()
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
