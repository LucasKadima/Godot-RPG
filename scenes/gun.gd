extends CharacterBody2D
class_name AK47
@onready var player = $/root/Main/world/Player
@onready var anim = $AnimatedSprite2D
var shooting = false
@onready var time = $Timer
@onready var holster = $holster
@onready var world =$/root/Main/world
var px = 0
var py =0
@onready var mark = $Marker
var can = 0
var outofammo = false
var doit = 0
@onready var m = $/root/Main
var holstering = false

signal holstertime


func _physics_process(delta):
   
    if outofammo == true:
        anim.play('pickup')
    px = mark.global_position.x
    py = mark.global_position.y
    
    var ypos = int(get_global_mouse_position().y-player.position.y)
    var xpos = int(get_global_mouse_position().x-player.position.x)
    var pos = rad_to_deg(player.position.angle_to_point(get_global_mouse_position()))
    anim.flip_h = true
    ##print(rad_to_deg(player.position.angle_to_point(get_global_mouse_position())))
    ##print(get_global_mouse_position().x-player.position.x)
    ##print(get_global_mouse_position().y-(player.position.y-12))
    #print(get_global_mouse_position().x)
    ##142-129
    
    if m.inv_search('gun')==true:
            if player.inhand == true:
                if Input.is_action_just_pressed('holster1'):
                    emit_signal("holstertime")
            elif player.inhand== false and holstering == false:
                if Input.is_action_just_pressed('holster1'):
                    player.inhand = true
                    visible = true
    if holstering == true:
          global_rotation_degrees-=7
          position.y = player.position.y-20
          position.x = player.position.x
          await get_tree().create_timer(0.1).timeout 
    if global_rotation_degrees<=-90 and holstering == true:
           holstering = false
           visible= false
           position.x = 1000000
           position.y = 1000000
           player.inhand = false
    
    if player.inhand != true:
        anim.play('pickup')
        rotation_degrees=0
       
        shooting = false
        world.current_recoil = 1.0
        
        anim.flip_v= false
        
        if can == 1:
            anim.flip_h = false
        else:
            anim.flip_h = true
            
    if player.inhand == true:
        ##movement
        
        
        anim.flip_h = true
        if holstering!= true:
         look_at(get_global_mouse_position())
         if get_global_mouse_position().x<player.position.x:
            anim.flip_v = true
         if get_global_mouse_position().x>player.position.x:
            anim.flip_v = false
        
         if (pos>0 and 142<pos) or (pos < 0 and -129> pos):
            position.x = player.position.x-10
            position.y = player.position.y
            
            
            anim.flip_v = true 
            player.anim.flip_h = true
            player.dir = 'left'
            can = 1
            if player.input_vector!= Vector2.ZERO:
             player.anim.play("moveSIDE")
            else:
             player.anim.play('idleSIDE')
         if (pos<0 and pos >-45) or (pos>0 and pos<40):
            position.x = player.position.x+10
            position.y = player.position.y
            can = 0
            player.anim.flip_h = false
            player.dir = 'right'
            if player.input_vector!= Vector2.ZERO:
             player.anim.play("moveSIDE")
            else:
             player.anim.play('idleSIDE')
            
            anim.flip_v = false
         if pos <0 and pos>-129 and pos <-45:
            position.x = player.position.x
            position.y = player.position.y-10
            
            player.dir = 'back'
            if player.input_vector!= Vector2.ZERO:
             player.anim.play("moveB")
            else:
             player.anim.play('idleB')
         if pos > 0 and pos <142 and pos >40:
            position.x = player.position.x
            position.y = player.position.y+10
            
            player.dir = 'front'
            if player.input_vector!= Vector2.ZERO:
             player.anim.play("move")
            else:
             player.anim.play('idle')
            
            
        ##end
       
        if Input.is_action_just_pressed('click') and outofammo == false and player.state == 0:
             
             
             shooting = true
             if world.count<=0:
                 outofammo = true
             shot()
             if outofammo == true:
                anim.play("pickup")
             else:       
                anim.play("shoot")
        
        
            
        if Input.is_action_just_released('click')or player.state != 0:
            
            shooting = false
            world.current_recoil = 1.0
            anim.play("pickup")
        
            
            
              
func shot():
    
    if shooting == true :
            
            $Timer.start()


func _on_timer_timeout():
    
    if shooting == false :
        $Timer.stop()
    if outofammo == false and player.state ==0:  
     
     world.inst(px,py)
    



func _on_holster_timeout():
   pass
    



func _on_holstertime():
   
   anim.flip_v= false
   holstering = true
   
   
    
            
   
            
