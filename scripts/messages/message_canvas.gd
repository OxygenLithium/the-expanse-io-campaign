extends CanvasLayer

@export var missionFailedScreen : Label
@export var missionAccomplishedScreen : Label
@export var enterToContinue : Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	missionFailedScreen.visible = false
	missionAccomplishedScreen.visible = false
	enterToContinue.visible = false

func missionFailed():
	missionFailedScreen.visible = true
	enterToContinue.visible = true

func missionAccomplished():
	missionAccomplishedScreen.visible = true
	enterToContinue.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
