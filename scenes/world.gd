extends Node2D

var bspeed =600
var bullet = preload("res://scenes/bullet.tscn")
var zombus = preload("res://scenes/zombie.tscn")
var died = preload('res://scenes/died.tscn')
@onready var zombie = $zombie
@onready var player = $Player
@onready var gun = $gun
var max_recoil:=10.0
var current_recoil :=1.0
var count = 100
var output = null
var outerput = null

func _ready():
    globals.current_scene='world'
       # instZ(100,100)
        #instZ(200,100)
         
        

func _physics_process(delta):
    ##print(current_recoil)
    

        
     
    if count<=0:
        gun.outofammo = true
    

func inst(posix,posiy):
    count-=1
    output = bullet.instantiate()
    add_child(output)
    output.position.x = posix
    output.position.y=posiy
    
    output.set_collision_layer_value(3,true)
    output.set_collision_mask_value(3,true)
    
    
    var recoil_deg_max= current_recoil*0.5
    
    
    var recoil_increment = current_recoil*0.2
    current_recoil=clamp(current_recoil+recoil_increment,0.0,max_recoil)
    var recoil_deg_actual =deg_to_rad(randf_range(-recoil_deg_max,recoil_deg_max))
    var acc_bullet_dir = output.position.direction_to(get_global_mouse_position()).rotated(recoil_deg_actual)
    
    
        
        
    
    output.velocity = acc_bullet_dir*bspeed
    
func instZ(posix,posiy):
    outerput = zombus.instantiate()
    add_child(outerput)
    outerput.position.x = posix
    outerput.position.y=posiy
