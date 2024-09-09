extends CharacterBody2D
class_name LIGHTAMMO
var speed = 1000
@onready var anim = $AnimatedSprite2D
@onready var player = $/root/Main/world/Player
@onready var coli = $CollisionShape2D
@onready var zombie = $/root/Main/world/zombie
var gogo = 0
var damage = 10

func _ready():
    
    
         
    anim.play("default")

func _physics_process(delta):
    move_and_slide()
    if self != null:
     if get_slide_collision_count() ==0:
        await get_tree().create_timer(1.0).timeout
        self.queue_free()
    
    
    if abs(position.x - player.position.x) > 1000 or   abs(position.y - player.position.y) > 1000:
        anim.play("boom")
        velocity = Vector2.ZERO
        coli.disabled= true
        await get_tree().create_timer(1.0).timeout
        self.queue_free()
        
    if get_slide_collision_count() !=0:
        
        anim.play("boom")
        
        velocity = Vector2.ZERO
        coli.disabled= true
        await get_tree().create_timer(1.0).timeout
        self.queue_free()
    ##print(velocity)
    #if zombie !=null:
     #if zombie.go == true:
      #if (position.x <=zombie.position.x+10 and position.x>=zombie.position.x-10) and (position.y>=zombie.position.y-10 and position.y <=zombie.position.y+10):
            #anim.play("boom")
            #coli.disabled= true
            #velocity = Vector2.ZERO
            #await get_tree().create_timer(1.0).timeout
            #self.queue_free()
        

    
        
