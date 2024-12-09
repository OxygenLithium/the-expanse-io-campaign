extends "res://scripts/ships/unn/enemy_ship.gd"

const displayType = "Andronicus-class Destroyer"
var displayName = ""

func special_init():
	health = 50
	PDCTargetingEffectiveness = 8
	missileShootTimes = [1155, 1170, 1185, 1200]
