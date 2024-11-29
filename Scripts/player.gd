extends CharacterBody2D

class_name Player
@onready var animated_sprite_2d:AnimationController = $AnimatedSprite2D
@onready var inventory:Inventory = $Inventory

const SPEED = 5000.0


func _physics_process(delta: float) -> void:
	var input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var input_y = Input.get_action_strength("down") - Input.get_action_strength("up")

	if input_x != 0:
		input_y = 0 
	elif input_y != 0:
		input_x = 0  

	var direction = Vector2(input_x, input_y)
	if direction != Vector2.ZERO:
		velocity = direction * SPEED * delta
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)

	if velocity != Vector2.ZERO:
		animated_sprite_2d.play_movement_animation(velocity)
	else:
		animated_sprite_2d.play_idle_animation()

	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is PickUpItem:
		inventory.add_item(area.inventory_item, area.stacks)
		area.queue_free()
