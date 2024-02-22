extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10
@onready var player = get_tree().get_first_node_in_group("player")
@onready var ani_mob1 = $AnimationPlayer

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	ani_mob1.play("mob1_walk")
	velocity = direction*movement_speed
	move_and_slide()

	if direction.x > 0:
		$Sprite2D.flip_h = true
	elif direction.x < 0:
		$Sprite2D.flip_h = false


func _on_hurt_box_hurt(damage):
	hp -= damage
	if hp < 0:
		queue_free()
