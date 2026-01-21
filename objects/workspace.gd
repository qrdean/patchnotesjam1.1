extends StaticBody3D

@export var interaction_component: InteractionComponent
@export var marker: Marker3D

var current_recipe: RecipeResource

var contexts: Dictionary[String, String] = {
	"something": "else"
}

var all_recipes: Array[RecipeResource]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func check_ingredient(ingredient: IngredientResource) -> bool:
	if current_recipe.has_ingredient(ingredient):
		interaction_component.context = "Place " + ingredient.name + " on board."
		return true
	else:
		interaction_component.context = ingredient.name + " not in " + current_recipe.name
		return false

func first_item(ingredient: IngredientResource) -> void:
	for r in all_recipes:
		if r.has_ingredient(ingredient):
			current_recipe = r
			break
	
	var pickup = current_recipe.pickup_scene.instantiate()
	add_child(pickup)
	pickup.global_position = marker.global_position
	self.collision.disabled = true
