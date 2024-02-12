class FEnemy extends FGameObject{
  int dir;
  int spd;
  int frame;
  
  public FEnemy(float x, float y){
    super();
    setPosition(x,y);
    setRotatable(false);
  }
  public FEnemy(float x, float y, float xsize, float ysize){
    super(xsize,ysize);
    setPosition(x,y);
    setRotatable(false);
  }
  void act(){
    animate();
    collide();
    move();
  }
  
  void animate(){}
  void collide(){}
  void move(){}
}

class FSmash extends FEnemy{
  boolean descending;
  boolean ascending;
  public FSmash(float x, float y){
    super(x,y);
    descending = false;
    ascending = false;
    dir = 1;
    spd = 400;
    setStatic(true);
    attachImage(loadImage("SMASHER.png"));
  }
  void collide(){
    if(isTouching("player")&&player.getY()>getY()+gridSize/2){
      hp = 0;
    }
  }
  void move(){
    ArrayList<FContact> contacts = getContacts();
    if(getX()-player.getX()<100&&getX()-player.getX()>-100){
      setStatic(false);
      if(!ascending){
        descending = true;
      }
    }
    if(descending == true){
      setVelocity(0,500);
    }
    if(getVelocityY()>0){
      ascending = false;
    }
    if(contacts.size()>0&&getVelocityY()>0){
      descending = false;
      ascending = true;
    }else if(contacts.size()>0&&getVelocityY()<0){
      ascending = false;
    }
    
    if(ascending||!descending){
      setVelocity(0,-1000);
    }
  }
}

class FThing extends FEnemy{
  public FThing(float x, float y){
    super(x,y);
    dir = -1;
    spd = 200;
    frame = 0;
    attachImage(loadImage("monster1.png"));
  }
  void animate(){
      if(time%50==0){
          attachImage(loadImage("monster2.png"));
      }
      if(time%75==0){
        attachImage(loadImage("monster1.png"));
      }
  }
  void collide(){
    if(isTouching("dirtWall")){
      dir*=-1;
      setPosition(getX()+dir,getY());
    }
    if(attacking&&Inventory.get(equiptedweapon).equals("spinner")){
        if(getX()-player.getX()<120&&getX()-player.getX()>-120&&getY()-player.getY()<120&&getY()-player.getY()>-120){
          world.remove(this);
        }
      }else if(attacking&&Inventory.get(equiptedweapon).equals("beginnersword")){
      if(getX()-player.getX()<100&&getX()-player.getX()>0&&getY()-player.getY()<80&&getY()-player.getY()>-80){
        world.remove(this);
      }
    }else if(attacking&&Inventory.get(equiptedweapon).equals("BIG")){
      if(getX()-player.getX()<swingframe*30&&getX()-player.getX()>swingframe*-30&&getY()-player.getY()<swingframe*30&&getY()-player.getY()>-swingframe*30){
        world.remove(this);
      }
    }else if(attacking&&Inventory.get(equiptedweapon).equals("Tele")){
        if(getX()-player.getX()<200&&getX()-player.getX()>-200&&getY()-player.getY()<200&&getY()-player.getY()>-swingframe-200){
        setStatic(true);
        }else{
          setStatic(false);
        }
        if(isTouching("player")){
          world.remove(this);
        }
      }
    if(isTouching("player")){
        hp-=5;
        player.setVelocity(player.getVelocityX()*-1,player.getVelocityY()*-1);
        dir*=1;
      
    }
    if(isTouching("dirt")){
        print("ahsdkjahdkjasd");
      setVelocity(getVelocityX(),-300);
    }
    
    
    
  }
  void move(){
    float vy = getVelocityY();
    setVelocity(spd*dir,vy);
  }
}
class FMonster extends FEnemy{
  public FMonster(float x, float y){
    super(x,y,200,200);
    dir = 1;
    spd = 400;
    if(currmap==15){
      spd = 150;
    }
    frame = 0;
    attachImage(loadImage("bmonster0.png"));
  }
  void animate(){
      
      if(time%20==0){
          attachImage(loadImage("bmonster0.png"));
      }
      if(time%40==0){
        attachImage(loadImage("bmonster1.png"));
      }
  }
  void collide(){
    if(isTouching("dirtWall")){
      dir*=-1;
      setPosition(getX()+dir,getY());
    }
    if(attacking&&Inventory.get(equiptedweapon).equals("spinner")){
        if(getX()-player.getX()<120&&getX()-player.getX()>-120&&getY()-player.getY()<120&&getY()-player.getY()>-120){
          hp--;
        }
      }else if(attacking&&Inventory.get(equiptedweapon).equals("beginnersword")){
      if(getX()-player.getX()<100&&getX()-player.getX()>0&&getY()-player.getY()<80&&getY()-player.getY()>-80){
        hp--;
      }
    }else if(attacking&&Inventory.get(equiptedweapon).equals("BIG")){
      if(getX()-player.getX()<swingframe*30&&getX()-player.getX()>swingframe*-30&&getY()-player.getY()<swingframe*30&&getY()-player.getY()>-swingframe*30){
        hp--;
      }
    }
    if(isTouching("player")){
        hp-=10;
        player.setVelocity(player.getVelocityX()*-1,player.getVelocityY()*-1);
      
    }
    if(isTouching("dirt")){
        print("ahsdkjahdkjasd");
      setVelocity(getVelocityX(),-300);
    }
    
    
    
  }
  void move(){
    float vy = getVelocityY();
    setVelocity(spd*dir,vy);
  }
}

class FBullet extends FGameObject{
  float x;
  float y;
  
  float vx;
  float vy;
  
  FBullet(float x, float y, float vx, float vy){
    super();
    this.x = x;
    this.y = y;
    this.vx = vx;
    this.vy = vy;
    setPosition(x,y);
    setVelocity(vx,vy);
    setSensor(true);
    setGrabbable(false);
    setStatic(false);
    setFillColor(color(255,0,0));
    setRotatable(true);
    enemies.add(this);
    attachImage(loadImage("projectile.png"));
  }
  
  void act(){
    collide();
    move();
  }
  
  void collide(){
    setSensor(true);
    if(attacking&&Inventory.get(equiptedweapon).equals("spinner")){
        if(getX()-player.getX()<120&&getX()-player.getX()>-120&&getY()-player.getY()<120&&getY()-player.getY()>-120){
          world.remove(this);
        }
      }else if(attacking&&Inventory.get(equiptedweapon).equals("BIG")){
        if(getX()-player.getX()<swingframe*30&&getX()-player.getX()>swingframe*-30&&getY()-player.getY()<swingframe*30&&getY()-player.getY()>-swingframe*30){
        world.remove(this);
        }
      }else if(attacking&&Inventory.get(equiptedweapon).equals("Tele")){
        if(telemode==2){
          if(getX()-player.getX()<600&&getX()-player.getX()>-600&&getY()-player.getY()<600&&getY()-player.getY()>-swingframe-600)
            setVelocity((player.getX()-getX())*20,(player.getY()-getY())*20);
          }
        if(getX()-player.getX()<200&&getX()-player.getX()>-200&&getY()-player.getY()<200&&getY()-player.getY()>-swingframe-200){
          if(telemode==0){
            setSensor(false);
            setVelocity(0,0);
          }else if(telemode==1){
            setVelocity(random(-10000,10000),random(-10000,10000));
          }
        
        }
        
        if(isTouching("player")&&getY()>player.getY())canJump=true;
        
      }else if(isTouching("player")){
      
        hp-=2;
        player.setVelocity(player.getVelocityX()*(-1/2),player.getVelocityY()*(-1/2));
        world.remove(this);
      
      
    }
    if(getY()>map.height*gridSize){
      print("dLDLJDLJLJLJDLJDJLDJDLJDLD");
      world.remove(this);
    }
  }
  void move(){
    
  }
  
  
}
