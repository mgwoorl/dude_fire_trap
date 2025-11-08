extends StaticBody2D

const ON_TIME: float = 3.0
@onready var animation = $AnimationPlayer
@onready var hit_area = $HitArea

var is_on: bool = false
var timer: float = 0.0

func off_trap():
	is_on = false
	animation.play("off")

func on_trap():
	timer = 0.0
	if not is_on:
		animation.play("hit")
		await animation.animation_finished
		animation.play("on")
		is_on = true
		check_and_hurt_characters()

func check_and_hurt_characters():
	for body in hit_area.get_overlapping_bodies():
		if body is CharacterBody2D and "Dude" in body.name:
			if body.has_method("_on_burned"):
				body._on_burned()
				var direction = (body.global_position - global_position).normalized()
				body.velocity = direction * 300 + Vector2(0, -200)

func _ready() -> void:
	off_trap()

func _process(delta: float) -> void:
	if is_on:
		timer += delta
		if timer >= ON_TIME:
			off_trap()

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and "Dude" in body.name:
		on_trap()
