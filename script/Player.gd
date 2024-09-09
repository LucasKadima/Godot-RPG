extends CharacterBody2D
class_name Player

var accel = 25
const speed = 85.0
const friction = 23
const JUMP_VELOCITY = -400.0
var attack_ip = false
var dir = 'none'
var b = null
var dmg = false
var g_in_range = false
var inhand = false
var input_vector = Vector2.ZERO
var guy = null
var hp = 80
var maxhp = 80
var minhp = 0
var damage = 20
var hpup = false
var item = null


enum{
    MOVE,
    ATTACK,
    DAMAGED,
    DIED
    
    
}
var state = MOVE

@onready var anim = $AnimatedSprite2D
@onready var cooldown = $Timer
@onready var mark = $Marker2D
@onready var gun = $/root/Main/world/gun
@onready var camera = $Camera2D
@onready var hpbar = $CanvasLayer/AnimatedSprite2D3
@onready var m = $/root/Main


func _physics_process(delta):
 ##print(dir)
 print(hp)
 hpbar.position.x = camera.position.x+293


 hpbar.position.y = camera.position.y+10

 

 if hp <=0:
    
    
    state = DIED
 match state:
    MOVE:
        move_state(delta)
    ATTACK:
        attack_state(delta)
    DAMAGED:
        dmg_state(delta)
    DIED:
        die_state(delta)


   
     





func attack_state(delta):
    if attack_ip == false:
    
     attack_ip = true
     if b:
        
        dmg = true
     if dir =='right' :
      anim.play("atkSIDE")
      
     if dir == 'left':
        anim.play('atkSIDE')
        
     if dir =='back':
        anim.play("atkB")
        
     if dir == 'front':
        anim.play('atk')
        
    

     $Timer.start()
    
    

func move_state(delta):
 accel = 25
 input_vector = Vector2.ZERO
 input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
 input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
 input_vector = input_vector.normalized()
        
 if input_vector!= Vector2.ZERO:
   if input_vector.x >0:
    
    dir = 'right'
    
   elif input_vector.y>0:
    
    dir = 'front'
    
   elif input_vector.y<0:
    
    dir = 'back'
    
   elif input_vector.x<0:
    
    dir = 'left'
   if inhand ==false:
    if dir =='front':
     anim.play("move")
     mark.rotation_degrees = 90   
    if dir =='right':
     anim.flip_h= false
     anim.play("moveSIDE")
     mark.rotation_degrees = 0
    if dir =='left':
     mark.rotation_degrees =180
     anim.flip_h=true
     anim.play("moveSIDE")
    if dir =='back':
     anim.play("moveB")
     mark.rotation_degrees = 270

   
   velocity += input_vector* accel*delta
   velocity = velocity.limit_length(speed*delta)
   
 else:
  if inhand == false:
   if dir == 'none':
    anim.play('idle')
   if dir == 'front':
     anim.play("idle")
   if dir =='back':
     anim.play("idleB")
   if dir == 'left' :
     anim.play("idleSIDE")
   if dir ==  'right':
     anim.play("idleSIDE")
  velocity = velocity.move_toward(Vector2.ZERO,friction*delta)

 move_and_collide(velocity)
 if Input.is_action_just_pressed('attack') and inhand == false :
    state = ATTACK
    
    
 if Input.is_action_just_pressed("pickup") and g_in_range == true and inhand ==false :
    inhand = true
    m.inventory.append('gun')
    await get_tree().create_timer(1.0).timeout
    
    
 if Input.is_action_just_pressed("pickup") and inhand == true :
    gun.position.y = gun.position.y+10
    inhand = false
    m.inventory.erase('gun')
    
 if Input.is_action_just_pressed("pickup") and hpup==true:
    hp+=80
    if item:
        if item.Name == 'medkit':
            item.queue_free()
    
    
    
    
     
func dmg_state(delta):
    
    if guy:
        var pos = deg_to_rad(position.angle_to_point(guy.position))
        input_vector = -(position.direction_to(guy.position))
        input_vector = input_vector.normalized()
        
    accel = 40
    
    velocity += input_vector* accel*delta
    velocity = velocity.limit_length(speed*delta)
    velocity = velocity.move_toward(Vector2.ZERO,friction*delta)
    move_and_collide(velocity)
    
func die_state(delta):
    
    globals.dead = true
    anim.play('DIE')
func _on_timer_timeout():
    if attack_ip == true:
     attack_ip = false
     
     state = MOVE



##SWORD DEAL DAMAGE CHECK COLLIDER
func _on_sword_hitbox_area_entered(area):
    b = area
    


func _on_sword_hitbox_area_exited(area):
    b = null

##PICK UP THE WEAPON OFF THE FLOOR
func _on_hitbox_body_entered(body):
    
    if body.is_in_group('guns'):
        g_in_range = true
    if body.is_in_group('items'):
        
        if body.Name == 'medkit':
             item = body
             hpup = true
            


func _on_hitbox_body_exited(body):
    if body.is_in_group('guns'):
        g_in_range = false
    if body.is_in_group('items'):
        
        if body.Name == 'medkit':
         item = null
         hpup=false



func _on_hitbox_area_entered(area):
    guy = area.get_parent()
    if area.is_in_group('attack'):
      await get_tree().create_timer(0.05).timeout
      
      if area.get_parent().atk == true:
        await get_tree().create_timer(0.4).timeout
        
        if guy:
         hp-=guy.damage
         hpbar.frame +=1
         state = DAMAGED
         $Timer2.start()

func _on_hitbox_area_exited(area):
     guy = null


func _on_timer_2_timeout():
    if state == DAMAGED:
        state = MOVE
