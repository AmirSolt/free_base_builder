extends Button

@export var building_data:BuildingData
@export var ghost_builder:GhostBuilder

func _ready() -> void:
	pressed.connect(_on_pressed)
	icon=building_data.icon
	tooltip_text=building_data.description

func _on_pressed() -> void:
	if ghost_builder.is_open() and ghost_builder.building_data==building_data:
		ghost_builder.close()
	else:
		ghost_builder.open(building_data)
