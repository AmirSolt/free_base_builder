class_name BuildingHighlight extends Node3D

@export var mesh:MeshInstance3D
var mat := StandardMaterial3D.new()

class BuildingHighlightParam:
	var on:bool
	var color:Color
	func _init(_on:bool, _color:Color,) -> void:
		on=_on
		color=_color

func _ready() -> void:
	assert(owner is Building)
	(owner as Building).component_call.connect(_on_req_highlight)
	
	mat.transparency=BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode=BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.no_depth_test=true

func _on_req_highlight(params:Variant)->void:
	if params is BuildingHighlightParam:
		if params.on:
			highlight(params.color)
		else:
			close_highlight()
	
func highlight(color:Color=Color(0,1,0,0.45))->void:
	mat.albedo_color=color
	mesh.material_override=mat

func close_highlight()->void:
	mesh.material_override=null
