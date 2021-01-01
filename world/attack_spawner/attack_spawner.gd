extends Node

const PROJECTILE_SCENE = preload("res://projectile/Projectile.tscn")

func execute_attack(pattern: AttackPatternData, direction: Vector2, position: Vector2, collision_layer: int):
	var dir: Vector2 = direction
	var proj_node = get_tree().get_root().get_node("Main/World/Projectiles")
	if proj_node == null:
		var n = Node.new()
		n.name = "Projectiles"
		get_tree().get_root().get_node("Main/World").add_child(n)
		proj_node = n
	
	for attack_data in pattern.attack_datas:
		var proj_dir = dir.rotated(-attack_data.spread / 2)
		
		for p_data in attack_data.projectiles:
			var proj = PROJECTILE_SCENE.instance()
			proj_node.add_child(proj)
			
			proj.position = position
			proj.setup_projectile(p_data, proj_dir, collision_layer)
			
			proj_dir = proj_dir.rotated(attack_data.spread / attack_data.projectiles.size() - 1)
		
		dir = dir.rotated(deg2rad(pattern.rotation_speed * pattern.inbetween_delay))
		yield(get_tree().create_timer(pattern.inbetween_delay), "timeout")
