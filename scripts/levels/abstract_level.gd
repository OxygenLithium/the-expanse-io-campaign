extends Node

@export var map_canvas : CanvasLayer
@export var hud_canvas : CanvasLayer
@export var message_canvas : CanvasLayer
@export var player : Node2D

var missionType = "destroyAll"

#For Destroy Target missions

var target = null
var targets = []

var timer = 0

#UNN Ships
var mulanFile = load("res://scenes/ships/unn/unn_frigate.tscn")
var andronicusFile = load("res://scenes/ships/unn/andronicus_destroyer.tscn")
var munroeFile = load("res://scenes/ships/unn/munroe_frigate.tscn")
var murphyFile = load("res://scenes/ships/unn/murphy_destroyer.tscn")
var trentonFile = load("res://scenes/ships/unn/trenton_cruiser.tscn")
var asimovFile = load("res://scenes/ships/unn/asimov_cruiser.tscn")

#MCRN Ships
var morriganFile = load("res://scenes/ships/mcrn/morrigan.tscn")
var corvetteFile = load("res://scenes/ships/mcrn/corvette.tscn")
var raptorFile = load("res://scenes/ships/mcrn/raptor.tscn")
var sciroccoFile = load("res://scenes/ships/mcrn/scirocco.tscn")
var donnagerFile = load("res://scenes/ships/mcrn/donnager.tscn")

var initialUNNShipCount
var UNNShips = []
var MCRNShips = []

var gameOver = false

func place_ships():
	pass

func level_ready():
	pass

func level_init():
	pass

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	print("hi")
	map_canvas = get_children()[0]
	hud_canvas = get_children()[1]
	message_canvas = get_children()[2]
	player = get_children()[3]
	
	#UI
	gameOver = false
	map_canvas.visible = true
	hud_canvas.visible = true
	message_canvas.visible = true
	
	place_ships()
	level_init()

func construct_mission_label():
	if missionType == "destroyAll":
		hud_canvas.mission_status.text = str(initialUNNShipCount - UNNShips.size()) + "/" + str(initialUNNShipCount) + " UNN Ships Destroyed"
	elif missionType == "destroySingleTarget":
		hud_canvas.mission_status.text = "Destroy the " + target.displayName
	pass

func _ready() -> void:
	initialUNNShipCount = UNNShips.size()
	if missionType == "destroyAll":
		message_canvas.missionDescription.text = "Destroy UNN ships"
	construct_mission_label()

func _process(delta: float) -> void:
	if timer > 90:
		message_canvas.missionLabel.visible = false
		message_canvas.missionDescription.visible = false
	
	if Input.is_action_just_pressed("key_enter"):
		if gameOver:
			queue_free()
			get_parent().reset()
	
	timer += 1

func player_death():
	if gameOver:
		return
	gameOver = true
	map_canvas.visible = false
	hud_canvas.visible = false
	message_canvas.missionFailed()
	
func victory():
	if gameOver:
		return
	gameOver = true
	map_canvas.visible = false
	hud_canvas.visible = false
	message_canvas.missionAccomplished()
	
func unn_ship_destroyed(ship):
	pass
		
func mcrn_ship_destroyed(ship):
	pass

#Add UNN ship
func addMulan(ePos, eName, eStance = "active"):
	var enemy = mulanFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy

func addMunroe(ePos, eName, eStance = "active"):
	var enemy = munroeFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy

func addAndronicus(ePos, eName, eStance = "active"):
	var enemy = andronicusFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy
	
func addMurphy(ePos, eName, eStance = "active"):
	var enemy = murphyFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy

func addTrenton(ePos, eName, eStance = "active"):
	var enemy = trentonFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy

func addAsimov(ePos, eName, eStance = "active"):
	var enemy = asimovFile.instantiate()
	enemy.position = ePos
	enemy.displayName = eName
	enemy.defaultStance = eStance
	add_child(enemy)
	return enemy


#Add MCRN ships
func addMorrigan(ePos, eName, eStance = "active"):
	var ally = morriganFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.defaultStance = eStance
	add_child(ally)
	return ally

func addCorvette(ePos, eName, eStance = "active"):
	var ally = corvetteFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.defaultStance = eStance
	add_child(ally)
	return ally

func addRaptor(ePos, eName, eStance = "active"):
	var ally = raptorFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.defaultStance = eStance
	add_child(ally)
	return ally


func addScirocco(ePos, eName, eStance = "active"):
	var ally = sciroccoFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.defaultStance = eStance
	add_child(ally)
	return ally

func addDonnager(ePos, eName, eStance = "active"):
	var ally = donnagerFile.instantiate()
	ally.position = ePos
	ally.displayName = eName
	ally.defaultStance = eStance
	add_child(ally)
	return ally


func setEscort(escort, target):
	escort.defaultStance = "escort"
	escort.escortTarget = target
	
