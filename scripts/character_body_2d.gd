extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Tambahkan gravitasi
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Lompat
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Gerakan kiri/kanan
	var direction := Input.get_axis("move_left", "move_right")
	var is_crouching := Input.is_action_pressed("down")
	
	if is_crouching and is_on_floor():
		velocity.x = 0
		$AnimatedSprite2D.play("crouch")
	else:
		if direction:
			velocity.x = direction * SPEED
			$AnimatedSprite2D.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Animasi berdasarkan kondisi
		if not is_on_floor():
			$AnimatedSprite2D.play("jump")
			$Jejak_kaki.stop()
		elif direction != 0:
			$AnimatedSprite2D.play("move")
			if not $Jejak_kaki.playing:
				$Jejak_kaki.play()
		else:
			$AnimatedSprite2D.play("default")  # idle
			$Jejak_kaki.stop()

	move_and_slide()
