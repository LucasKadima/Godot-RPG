extends Node2D
var output = null
@onready var player = $/root/Main/world/Player
# Called when the node enters the scene tree for the first time.
func _ready():
    #instance(60,60)
    
    if globals.dead == true:
      globals.current_scene = 'died'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
   if globals.current_scene == 'died':
     player.position.x = 175
     player.position.y = 80
         
         
         
func instance(posx,posy):
    output = player.instantiate()
    add_child(output)
    output.position.x = posx
    output.position.y = posy
