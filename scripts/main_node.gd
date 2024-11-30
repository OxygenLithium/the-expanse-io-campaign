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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !inGame:
		if Input.is_action_pressed("key_1") or Input.is_action_pressed("key_2") or Input.is_action_pressed("key_3"):
			inGame = true
			TitlePage.visible = false
			game_map = gameMapFile.instantiate()
			
			if Input.is_action_pressed("key_1"):
				game_map.level = 1
			if Input.is_action_pressed("key_2"):
				game_map.level = 2
			if Input.is_action_pressed("key_3"):
				game_map.level = 3
			self.add_child(game_map)
			mainCamera.gameStart(game_map.player)
			
