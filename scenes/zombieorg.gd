extends CharacterBody2D
class_name Zombie
var knockback = Vector2.ZERO
var player = null
var chase = false
@onready var anim = $AnimatedSprite2D
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
@onready var hpbar = $AnimatedSprite2D2
var zombie = self
var now = 0
var lili = false
var maxhp = 80
var minhp = 0
var hp = 80
var go = false
@onready var coli = $CollisionShape2D
var died = false
var blade = false
var atk = false
var checkifhurtplaying = 0
var dir = Vector2.ZERO
var colicount = null
var hpupdate=0
var damage = 20




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
   
   #print(b)
   if b:
    if b.is_in_group('bullets'):
     hp -=b.damage
     
     hpupdate+=1
     if hpupdate >=2:
        hpupdate=0
        hpbar.frame+=1
     
     
     go= true
     if chase !=false:
      if  b.position.x >position.x:
       knockback = Vector2.RIGHT*0.2
      if  b.position.x < position.x:
       knockback = Vector2.LEFT*0.2
       knockback = knockback.move_toward(Vector2.ZERO,0.1)   
     #b.coli.disabled= true
     #b.velocity = Vector2.ZERO
     #b.coli.disabled= true
     #await get_tree().create_timer(1.0).timeout
     #if b !=null:
      #b.call_deferred("queue_free")
    else:
     go = false
    
    
    
func _on_collision_area_body_exited(body):
    collision = false
    go = false
    b= null
 
var move_vector = Vector2.ZERO
func sum_navpath(arr:Array):
  var current_index := 0
  var result = 0
  for i in arr:
     if current_index < nav.get_current_navigation_path_index():
            current_index += 1
            continue
            result+=i.length()
     if arr.size() > 0:
          result-= arr[arr.size() - 1].length()
     return result
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    #HP
 if hp !=maxhp:
    hpbar.visible = true
    if hp ==minhp:
        hpbar.visible=false
 else:
    hpbar.visible=false
 
 colicount = get_slide_collision_count()
 if died == true:
    coli.disabled = true
    LEFT.enabled = false
    RIGHT.enabled = false
    UP.enabled = false
    DOWN.enabled = false
    rightup.enabled = false
    rightdown.enabled = false
    leftup.enabled = false
    leftdown.enabled = false
    $Hitbox/CollisionShape2D.disabled = true
  
 if died!= true:
        
        if atk!= true:
         var d =dir-position
         if chase!=false:
           wait(1.0)
        
         
         
         
         #if abs(d)- abs(dir-position)<=2:
            #velocity= Vector2.RIGHT 
            
    
 
         
 if died != true:
  if zombie !=null:
     if zombie.go == true:
      if (b.position.x <=zombie.position.x+10 and b.position.x>=zombie.position.x-10) and (b.position.y>=zombie.position.y-10 and b.position.y <=zombie.position.y+10):
            b.anim.play("boom")
            b.coli.disabled= true
            b.velocity = Vector2.ZERO
            await get_tree().create_timer(1.0).timeout
            if b!=null:
             b.queue_free()
 if hp <=0:
    if died != true:
     anim.play("die")
     $Hitbox/CollisionShape2D.disabled = true
     set_collision_layer_value(1,false)
     set_collision_mask_value(1,false)
    
     
     velocity = Vector2.ZERO
     await get_tree().create_timer(1.8).timeout
     died = true
     $Timer.stop()
     velocity = Vector2.ZERO
    if self != null and died == true:
     anim.play("died")
 if died != true:    
  move_and_collide(knockback)
  if player:
        
        if atk == true:
            
            velocity= Vector2.ZERO
            if abs(player.position.x - position.x)  <=20 and abs(player.position.y - position.y)  <=30 :
             
             anim.play('attack')
            
            
        if player.dmg == true and blade == true:
            
            anim.play("hurt")
            player.dmg = false
            checkifhurtplaying = 1
            
            if hp>20:
             if player.dir == 'right':
              knockback = Vector2.RIGHT*1
              velocity = Vector2.RIGHT*1000
             if player.dir == 'left':
              knockback = Vector2.LEFT*1
              velocity = Vector2.LEFT*1000
             if player.dir == 'back':
              knockback = Vector2.UP*1
              velocity = Vector2.UP*1000
             if player.dir == 'front':
              knockback = Vector2.DOWN*1
              velocity = Vector2.DOWN*1000
            checkifhurtplaying = 0
            hp-=player.damage
            hpbar.frame +=1
            
        if player.attack_ip != true:
            knockback = knockback.move_toward(Vector2.ZERO,1000)    
  
    
     
    
    #END
#KAKA
 
  dir = to_local(nav.get_next_path_position()).normalized()
 ##print(sum_navpath(nav.get_current_navigation_path()))

 
#end
  move_vector= move_vector.normalized()
  move_and_slide()
  
  if chase != true:
   move_vector = Vector2.ZERO
   if velocity == Vector2.ZERO:
    anim.play("idle")
   velocity = dir* speed*30
  var distx = position.x - nav.target_position.x
  var disty = position.y - nav.target_position.y
  if (-1<distx and distx<1) and (-1<disty and disty<1):
    velocity = Vector2.ZERO
 
 
  #MOVE left
  if chase != false :
   if blade != true and player != null:
    if knockback == Vector2.ZERO:
     if atk!=true:   
      if dir.x > 0:
       anim.flip_h = false
       anim.play("moveside")
      elif dir.x <= 0:
       anim.flip_h = true
       anim.play('moveside')
   if atk!= true:
    velocity = dir* speed*30 
   else:
    velocity = Vector2.ZERO
   
 else:
    velocity = Vector2.ZERO
   ##if DOWN.is_colliding() == false and rightdown.is_colliding()==false and leftup.is_colliding()==false:
    ##distY = abs((position.y+speed)-player.position.y) 
    ##distanceY = distY
    ##
    ##if (abs(distY)<abs(distanceY)+1):
     ##move_vector.y =1
     ##distY = distanceY
   ##if RIGHT.is_colliding() == false and rightup.is_colliding()==false and rightdown.is_colliding()==false:
    ##distX = abs((position.x+speed)-player.position.x )
    ##distanceX = distX
    ##
    ##if (abs(distX)<abs(distanceX)+1):
        ##move_vector.x =1
        ##distX = distanceX
    ###move right
##
    ###move up
  ##
  ##
 ##
    ###movedown
   ##if UP.is_colliding() == false and rightup.is_colliding()==false and leftup.is_colliding()==false:
    ##distY = abs((position.y-speed)-player.position.y) 
    ##
    ##if (abs(distY)<abs(distanceY)):
     ##move_vector.y =-1
     ##distY = distanceY
    ##
   ##if LEFT.is_colliding() == false and leftup.is_colliding()==false and leftdown.is_colliding()==false:
     ##distX = abs((position.x-speed)-player.position.x) 
    ##
     ##if (abs(distX)<abs(distanceX)):
      ##move_vector.x =-1
      ##distX = distanceX
    ##
 ##if (0.9<distanceX and distanceX<2):
    ##
    ##move_vector.x = 0
    ##
    ##
 ##
  ##
 ##if (0<distanceY and distanceY<3):
   ##move_vector.y = 0
 ##if leftup.is_colliding() == true:
    ##await get_tree().create_timer(0.5).timeout

    
    
func makepath():
    if player:
     
     nav.target_position.x = player.position.x
     nav.target_position.y = player.position.y
    


    
  
  
  


    



  



    















func _on_timer_timeout():
    makepath()
     # Replace with function body.
#raaaaaaaaaaaaaaaaaaa





func _on_hitbox_area_entered(area):
   
   
   
   
   if area.is_in_group('players'):
    blade = true
   if area.is_in_group('attackable'):
    if atk == false:
       atk = true
       
    
     
    
    
    
    
    
    $Timer2.start()
    


func _on_hitbox_area_exited(area):
    if blade == true:
        blade = false
    


func _on_timer_2_timeout():
    coli.disabled= false
    if atk == true:
        atk = false

func wait(seconds):
    var e = dir-position
    await get_tree().create_timer(seconds).timeout
    #print(e.x-(dir.x-position.x))
    #print(e.y-(dir.y-position.y))
    if player :
     if e.x-(dir.x-position.x)<1 and e.x-(dir.x-position.x)>-1 and e.y-(dir.y-position.y)<1 and e.y-(dir.y-position.y)>-1:
        if colicount>0:
            colicount=0
            if LEFT.is_colliding() == false and leftup.is_colliding()==false and leftdown.is_colliding()==false:
             velocity = Vector2.LEFT*100
             await get_tree().create_timer(0.5).timeout
             velocity = dir*speed*30
            if UP.is_colliding() == false and rightup.is_colliding()==false and leftup.is_colliding()==false: 
             velocity = Vector2.UP*100
             await get_tree().create_timer(0.5).timeout
             velocity = dir*speed*30
            if RIGHT.is_colliding() == false and rightup.is_colliding()==false and rightdown.is_colliding()==false:
             velocity = Vector2.RIGHT*100
             await get_tree().create_timer(0.5).timeout
             velocity = dir*speed*30
            if DOWN.is_colliding() == false and rightdown.is_colliding()==false and leftup.is_colliding()==false:
             velocity = Vector2.DOWN*100
             await get_tree().create_timer(0.5).timeout
             velocity = dir*speed*30
