extends "res://objects/mechanics/finite_state_machine/states_klengan/movement/movement.gd"


func enter():
	.enter()
	owner.set_AttackCollision_disabled(false)
	owner.get_node("AnimatedSprite").stop()
	if velocity.x != 0:
		#replace with move attack anim
		owner.play_directional_animation("attack") 
	else:
		#replace with idle attack anim
		owner.play_directional_animation("attack") 


func exit():
	.exit()
	owner.set_AttackCollision_disabled(true)
	print("attack")
	for enemy in get_parent().attackable_enemies:
		print(enemy.name)
		pass
	#attack(KLENGAN_ATTACKS.NORMAL, ):


func _on_animation_finished(_anim_name):
	normal_attack()
	if Input.is_action_pressed("sneak"):
		emit_signal("finished", "sneak")
	else:
		emit_signal("finished", "move")


func apply_forces():
	.apply_forces()
	var input_direction = get_input_direction()
	if (velocity.x < 0 and input_direction.x < 0) or (velocity.x > 0 and input_direction.x > 0):
		velocity.x = clamp(velocity.x + input_direction.x * ACCELERATON, -MAX_SPEED, MAX_SPEED)
		if Input.is_action_pressed("sneak"):
			velocity.x *= 0.75
	else:
		velocity.x = int(lerp(velocity.x, 0, LERP_FACTOR))


func normal_attack():
	var enemies = owner.get_node("AnimatedSprite/AttackArea").get_overlapping_bodies()
	var klengan_node = get_parent().get_parent()
	for enemy in enemies:
		klengan_node.attack(KLENGAN_ATTACKS.NORMAL, enemy)
		enemy.update_life()

