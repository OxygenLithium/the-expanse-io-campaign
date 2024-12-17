extends "res://scripts/levels/abstract_level.gd"

func unn_ship_destroyed(ship):
	construct_mission_label()
	if UNNShips.size() < 1:
		victory()

func place_ships():
	var enemy
	
	addCorvette(Vector2(-1600,800), "MCRN Wukong")
	addMorrigan(Vector2(-1600,-800), "MCRN Nagamaki")
	addMorrigan(Vector2(-3200,1600), "MCRN Hester Prynne")
	#addDonnager(Vector2(-500,-300), "MCRN Ragnarok")
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(54000,6000)
	enemy.displayName = "UNN Milton"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(54000,10000)
	enemy.displayName = "UNN Milton"
	add_child(enemy)
	
	enemy = andronicusFile.instantiate()
	enemy.position = Vector2(48000,0)
	enemy.displayName = "UNN Jasper"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(54000,-6000)
	enemy.displayName = "UNN Beirut"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(58000,-10000)
	enemy.displayName = "UNN Beirut"
	add_child(enemy)
	
	enemy = munroeFile.instantiate()
	enemy.position = Vector2(80000,2800)
	enemy.displayName = "UNN St. Elmo's Fire"
	add_child(enemy)
	
	enemy = munroeFile.instantiate()
	enemy.position = Vector2(80000,-2800)
	enemy.displayName = "UNN Maracaibo"
	add_child(enemy)
	
	enemy = andronicusFile.instantiate()
	enemy.position = Vector2(96000,0)
	enemy.displayName = "UNN Beowulf"
	add_child(enemy)
	
	enemy = murphyFile.instantiate()
	enemy.position = Vector2(160000,-20000)
	enemy.displayName = "UNN Hou Yi"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(200000,-20000)
	enemy.displayName = "UNN Austin"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(200000,-24000)
	enemy.displayName = "UNN Chelsea"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(200000,-16000)
	enemy.displayName = "UNN San Jose"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(200000,-12000)
	enemy.displayName = "UNN Donald Knuth"
	add_child(enemy)
	
	enemy = mulanFile.instantiate()
	enemy.position = Vector2(200000,-8000)
	enemy.displayName = "UNN Mary Shelley"
	add_child(enemy)
	
	enemy = murphyFile.instantiate()
	enemy.position = Vector2(208000,-24000)
	enemy.displayName = "UNN Hayha"
	add_child(enemy)
	
	enemy = murphyFile.instantiate()
	enemy.position = Vector2(208000,-20000)
	enemy.displayName = "UNN Basilic"
	add_child(enemy)
	
	enemy = murphyFile.instantiate()
	enemy.position = Vector2(212000,-16000)
	enemy.displayName = "UNN Typhoon"
	add_child(enemy)
