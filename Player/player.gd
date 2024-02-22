extends CharacterBody2D


var movement_speed = 40.0
var hp = 80

var windBall = preload("res://Player/Attack/wind_ball.tscn")

@onready var windBallTimer = get_node("%WindBallTimer")
@onready var windBallAttackTimer = get_node("%WindBallAttackTimer")

var windball_ammo = 0
var windball_baseammo = 1
var windball_attackspeed = 1.5
var windball_level = 1

var enemy_close = []

@onready var sprite = $AnimationPlayer

func _ready():
	attack()

func _physics_process(delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov, y_mov)
	if mov.x < 0:
		$coRun.flip_h = true
	elif mov.x > 0:
		$coRun.flip_h = false
		
	if x_mov:
		sprite.play("walk")
	elif y_mov:
		sprite.play("walk")
	else:
		sprite.play("idle")
		
	velocity = mov.normalized()*movement_speed 
	move_and_slide()

func attack():
	if windball_level > 0:
		windBallTimer.wait_time = windball_attackspeed
		if windBallTimer.is_stopped():
			windBallTimer.start()

func _on_hurt_box_hurt(damage):
	hp -= damage
	print(hp)


func _on_wind_ball_timer_timeout():
	windball_ammo += windball_baseammo
	windBallAttackTimer.start()


func _on_wind_ball_attack_timer_timeout():
	if windball_ammo > 0 :
		var windball_attack = windBall.instantiate()
		windball_attack.position = global_position
		windball_attack.target = get_random_target()
		windball_attack.level = windball_level
		add_child(windball_attack)
		windball_ammo -= 1
		if windball_ammo > 0:
			windBallAttackTimer.start()
		else:
			windBallAttackTimer.stop()
		
func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else :
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)
