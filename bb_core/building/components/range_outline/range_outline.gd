extends MeshInstance3D

@export var range_outline_mat:ShaderMaterial

func _ready() -> void:
	assert(owner is Building)
	(owner as Building).update_requested.connect(_on_building_update)
	
	mesh=PlaneMesh.new()
	mesh.material=range_outline_mat

func _on_building_update()->void:
	var size := (owner as Building).data.size
	var range := (owner as Building).data.range
	if range==0:
		hide()
		return
	var w:=size.x+(range*2)
	var h:=size.y+(range*2)
	(mesh as PlaneMesh).size=Vector2(w,h)
	show()
	
