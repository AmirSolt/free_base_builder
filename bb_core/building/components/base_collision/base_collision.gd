extends CollisionShape3D


func _ready() -> void:
	assert(owner is Building)
	(owner as Building).update_requested.connect(_on_building_update)
	position.y=0.51

func _on_building_update()->void:
	var size := (owner as Building).data.size
	var box = BoxShape3D.new()
	box.size=Vector3(size.x*0.9, 1, size.y*0.9)
	shape=box
