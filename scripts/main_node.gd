extends Node

var gameMapFile = load("res://scenes/game_map.tscn")

var inGame = false
var game_map = null

@export var TitlePage : Node2D
@export var mainCamera : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TitlePage.visible = true
	pass # Replace with function body.

func reset():
	game_map = null
	inGame = false
	
	mainCamera.global_position = Vector2(0,0)
	mainCamera.closeGame()
	
	TitlePage.visible = true

func setUpGame(level):
	inGame = true
	TitlePage.visible = false
	game_map = gameMapFile.instantiate()
	game_map.level = level
	self.add_child(game_map)
	mainCamera.gameStart(game_map.player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !inGame:
		if Input.is_action_pressed("key_1"):
			setUpGame(1)
		if Input.is_action_pressed("key_2"):
			setUpGame(2)
		if Input.is_action_pressed("key_3"):
			setUpGame(3)
		if Input.is_action_pressed("key_4"):
			setUpGame(4)
		if Input.is_action_pressed("key_5"):
			setUpGame(5)
			
