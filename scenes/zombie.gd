extends CharacterBody2D


var player = null
var chase = false
var speed = 1
var distanceX = 10000000
var distanceY = 10000000
var distX = 0
var distY = 0
@onready var UP = $UPray
@onready var DOWN = $DOWNray
@onready var RIGHT = $RIGHTray
@onready var LEFT = $LEFTray
@onready var rightup = $upright
@onready var rightdown = $downright
@onready var leftdown = $downleft
@onready var leftup = $upleft
@onready var nav = $NavigationAgent2D as NavigationAgent2D



var collision = false
var b = null
# Called when the node enters the scene tree for the first time.
func _ready():
    makepath()
func _on_detection_area_body_entered(body):
    chase = true
    player = body
    


func _on_detection_area_body_exited(body):
    chase = false
    player = null

func _on_collision_area_body_entered(body):
   collision = true
   b = body
    
func _on_collision_area_body_exited(body):
    collision = false

 
var move_vector = Vector2.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#KAKA
 var dir = to_local(nav.get_next_path_position()).normalized()
#end
 move_vector= move_vector.normalized()
 move_and_slide()
 if chase != true:
  move_vector = Vector2.ZERO
  
 velocity = dir* speed*30 
 
  #MOVE left
 if chase != false:
   if DOWN.is_colliding() == false and rightdown.is_colliding()==false and leftup.is_colliding()==false:
    distY = abs((position.y+speed)-player.position.y) 
    distanceY = distY
    
    if (abs(distY)<abs(distanceY)+1):
     move_vector.y =1
     distY = distanceY
   if RIGHT.is_colliding() == false and rightup.is_colliding()==false and rightdown.is_colliding()==false:
    distX = abs((position.x+speed)-player.position.x )
    distanceX = distX
    
    if (abs(distX)<abs(distanceX)+1):
        move_vector.x =1
        distX = distanceX
    #move right

    #move up
  
  
 
    #movedown
   if UP.is_colliding() == false and rightup.is_colliding()==false and leftup.is_colliding()==false:
    distY = abs((position.y-speed)-player.position.y) 
    
    if (abs(distY)<abs(distanceY)):
     move_vector.y =-1
     distY = distanceY
    
   if LEFT.is_colliding() == false and leftup.is_colliding()==false and leftdown.is_colliding()==false:
     distX = abs((position.x-speed)-player.position.x) 
    
     if (abs(distX)<abs(distanceX)):
      move_vector.x =-1
      distX = distanceX
    
 if (0.9<distanceX and distanceX<2):
    
    move_vector.x = 0
    
    
 
  
 if (0<distanceY and distanceY<3):
   move_vector.y = 0
 if leftup.is_colliding() == true:
    await get_tree().create_timer(0.5).timeout

    
    
func makepath():
    if player:
     nav.target_position = player.position
    


    
  
  
  


    



  



    















func _on_timer_timeout():
    makepath()
    pass # Replace with function body.
