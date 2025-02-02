extends StateKlenganMovement
class_name StateKlenganRanged

onready var Harpune = preload("res://scenes/characters/klengan/attacks/Harpune.tscn")

func enter():
	.enter()
	owner.set_AttackCollision_disabled(false)
	owner.get_node("AnimatedSprite").stop()
	if velocity.x != 0:
		#replace with move attack anim
		owner.play_directional_animation("melee") 
	else:
		#replace with idle attack anim
		owner.play_directional_animation("melee") 


func exit():
	.exit()
	owner.set_AttackCollision_disabled(true)


func _on_animation_finished(_anim_name):
	shoot_harpune()
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


func shoot_harpune():
	var harpune = Harpune.instance()
	get_tree().current_scene.add_child(harpune)
	harpune.start(owner, owner.position, owner.looking_right)
	
	AudioHandler.play_sound("shoot_harpune")

