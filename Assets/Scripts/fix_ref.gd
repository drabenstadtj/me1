@tool
extends EditorScript

func _run():
	var editor_iface = get_editor_interface()
	var root = editor_iface.get_edited_scene_root()
	if root == null:
		push_error("No edited scene is loaded.")
		return

	var world_path = "SubViewportContainer/SubViewport/World"
	if not root.has_node(world_path):
		push_error("Node '%s' not found." % world_path)
		return

	var world = root.get_node(world_path)
	_clear_skeletons(world)
	print("✅ Done clearing skeleton references.")

func _clear_skeletons(node: Node):
	for child in node.get_children():
		_clear_skeletons(child)

	var prop_list = node.get_property_list()
	for prop in prop_list:
		if prop.name == "skeleton":
			node.set(prop.name, null)
			print("Cleared skeleton in:", node.get_path())
