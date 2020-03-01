extends "res://objects/mechanics/finite_state_machine/states_klengan/movement/movement.gd"
var damage = false
var dashDamage = 0
var dashHeight = 0
func enter():
	.enter()
	damage = false
	owner.set_DashCollision_disabled(false)
	dashHeight = 0
	if owner.is_on_floor():
		velocity.y = -JUMP_VELOCITY * 1.2
	else:
		velocity.y = JUMP_VELOCITY
		damage = true
		dashHeight = owner.position.y
		owner.set_collision_mask_bit(1, false)

func update(_delta):
	.update(_delta)
	if Input.is_action_just_pressed("sneak"):
		dashHeight = owner.position.y
		dashDamage = JUMP_VELOCITY*3
		velocity.y = JUMP_VELOCITY*3
		damage = true
		owner.set_collision_mask_bit(1,false)
	if !Input.is_action_pressed("sneak"):
		owner.set_collision_mask_bit(1,true)
	if owner.is_on_floor() and velocity == Vector2():
		owner.set_collision_mask_bit(1,true)
		do_damage()
		emit_signal("finished", "idle")
	elif owner.is_on_floor() and !Input.is_action_pressed("sneak"):
		owner.set_collision_mask_bit(1,true)
		do_damage()
		emit_signal("finished", "move")
	elif owner.is_on_floor() and Input.is_action_pressed("sneak"):
		owner.set_collision_mask_bit(1,true)
		do_damage()
		emit_signal("finished","sneak")
	elif Input.is_action_just_pressed("jump"):
		emit_signal("finished","doubleJump")
	dashDamage = velocity.y

func do_damage():
	if owner.is_on_floor() and damage:
		RumbleHandler.rumble_dash()
		damage = false
		dashHeight -= owner.position.y
		dashDamage *= (sqrt(pow(-dashHeight,2)/4000)/10 - 0.1) / 5
		var enemies = owner.get_node("AnimatedSprite/DashArea").get_overlapping_bodies()
		for enemy in enemies:
			get_parent().get_parent().attack(KLENGAN_ATTACKS.DASH, enemy, dashDamage * 0.01)
		owner.set_DashCollision_disabled(true)
