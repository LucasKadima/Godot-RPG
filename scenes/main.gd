extends Node2D

@onready var player = $world/Player
@onready var world = $world
@onready var died = $died
var inventory=[]
var found = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    remove_child(died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    
    if player.hp<=0:
        globals.current_scene='died'
        for i in range(1):
         switch_scene(world,died)
        
        
func switch_scene(prev,next):
    add_child(next)
    prev.remove_child(player)
    next.add_child(player)
    remove_child(prev)
    

func inv_search(item):
    for i in inventory:
        
        if i == item:
            
            found = 1
            break
        else:
            
            found = 0
    if len(inventory) == 0:
        found = 0
    if found == 1:
        return true
    elif found ==0:
        return false
    
        
        
    
