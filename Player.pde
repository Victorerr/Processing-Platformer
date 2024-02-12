class Player extends FGameObject{
  PImage design;
  PImage design2;
  Player(float x, float y){
    super();
    setRotatable(false);
    design = new PImage();
    design = loadImage("robomain.png");
    design2 = loadImage("robomain2.png");
    attachImage(design);
    setPosition(x,y);
    //setPosition(450,1500);
    setFillColor(#FF0000);
    setFriction(0.5);
    //attachImage(design);
    setName("player");
  }
  
  void checkCollisions(){
    ArrayList<FContact> contactList = getContacts();
    for(int i = 0;i<contactList.size();i++){
      FContact myContact = contactList.get(i);
      if(myContact.contains("portal")){
        openDoor = true;
        finishedTransition = false;
        currmap++;
        doPortal();
        
        break;
      }
      if(myContact.contains("spike")){
        hp-=20;
        setVelocity(getVelocityX(),-400);
        if(currmap>5){
          hp-=currmap;
        }
        if(hp<0){
          hp = 0;
        }
        
      }
      if(myContact.contains("lava")){
        hp-=0.1;
        setVelocity(getVelocityX()/1.05,getVelocityY()/1.05);
        if(currmap>5){
          hp-=0.1;
        }
        if(hp<0){
          hp = 0;
        }
        
      }
      if(myContact.contains("darkGround")){
        if(currmap>7&&currmap<13){
          hp-=0.01;
        }
        
      }
      
      for(int idx = 0;idx<jumpable.length;idx++){
        if(map.get((int)player.getX()/gridSize+1,(int)player.getY()/gridSize+1)==jumpable[idx]||map.get((int)player.getX()/gridSize,(int)player.getY()/gridSize+1)==jumpable[idx]){
        canJump = true;
      }
      
      }
    }
    if(currmap>5){
      if(player.getX()>(map.width-1)*gridSize){
        currmap++;
      }
    }
    
    
    if(canJump){
      setFriction(0);
    }else{
      setFriction(1);
    }
  }
  
  void act(){
    if(player.getY()>1900){
      hp = 0;
    }
    float savevx1 = getVelocityX();
    float savevy1 = getVelocityY();
    if(!flymode){
      if(playermode == 0){
        if(upkey){
          if(canJump){
             setVelocity(savevx1,-400); 
          }
        }
      savevx1 = getVelocityX();
      savevy1 = getVelocityY();
      
      if(downkey){
        if(savevy1>0){
          setVelocity(savevx1,savevy1*1.1);
        }else{
          setVelocity(savevx1,savevy1*-1.1);
        }
      }
      savevx1 = getVelocityX();
      savevy1 = getVelocityY();
      if(rightkey){
        player.setVelocity(400,savevy1);
      }else if(leftkey){
        setVelocity(-400,savevy1);
      }else{
        setVelocity(savevx1/1.03,savevy1);
      }
      savevx1 = player.getVelocityX();
      savevy1 = player.getVelocityY();
      }
      
      if(rightkey||leftkey){
        time++;
      }
      
      checkCollisions();
      
      if(rightkey){
        attachImage(design);
      }else if(leftkey){
        attachImage(design2);
      }
    }else{
      if(playermode == 0){
        if(upkey){
          setVelocity(savevx1,-400); 
        }
      savevx1 = getVelocityX();
      savevy1 = getVelocityY();
      
      if(downkey){
        setVelocity(savevx1,400);
      }
      savevx1 = getVelocityX();
      savevy1 = getVelocityY();
      if(rightkey){
        player.setVelocity(400,savevy1);
      }else if(leftkey){
        setVelocity(-400,savevy1);
      }else{
        setVelocity(0,savevy1);
      }
      savevx1 = player.getVelocityX();
      savevy1 = player.getVelocityY();
      }
      
      if(rightkey||leftkey){
        time++;
      }
      
      if(!rightkey&&!leftkey){
        setVelocity(0,savevy1);
      }
      if(upkey||downkey){
        time++;
      }else{
        setVelocity(savevx1,0);
      }
      
      checkCollisions();
      
      if(rightkey){
        attachImage(design);
      }else if(leftkey){
        attachImage(design2);
      }
  }
  }
  
  private void doPortal(){
    world = new FWorld();
    world.setGravity(0,980);
    terrain = new ArrayList<FGameObject>();
    enemies = new ArrayList<FGameObject>();
    map = loadImage("pixilart-drawing(" + (currmap-1) + ").png");
    
    
    if(finishedTransition){
      switch(currmap){
      case 1:
      doPlayer(450,1500);
      break;
      case 2:
      doPlayer(450,1500);
      break;
      case 3:
      doPlayer(450,1500);
      break;
      case 4:
      doPlayer(100,1500);
      break;
      case 5:
      doPlayer(100,1700);
      overworld = true;
      break;
      case 6:
      background = color(0,50,255);
      
      doPlayer(90,1800);
      break;
      case 7:
      doPlayer(90,1800);
      overworld = false;
      break;
      case 8:
      
      background = black;
      doPlayer(450,1500);
      break;
      case 9:
      doPlayer(90,1800);
      break;
      case 10:
      doPlayer(130,1700);
      break;
      case 11:
      doPlayer(90,1800);
      break;
      case 12:
      background = color(150,0,0);
      doPlayer(900,1800);
      break;
      case 13:
      background = color(100,0,0);
      doPlayer(500,300);
      break;
      case 14:
      background = color(50,0,0);
      doPlayer(90,1800);
      break;
      case 15:
      
      background = color(0,0,0);
      doPlayer(400,1800);
      break;
      
    }
    for(int y = 0 ; y < map.height ; y++){
    for(int x = 0 ; x < map.width ; x++){
    color tempColor = map.get(x,y);
      
      if(tempColor == black){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("darkGround");
        mapBox.setFriction(1);
        if(currmap<8){
            mapBox.attachImage(stone);
        }else if(currmap>7){
            mapBox.attachImage(loadImage("hellstone.jpg"));
        }
        mapBox.setPosition(x*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == portalColor){
        mapBox = new FBox(gridSize/6,gridSize);
        mapBox.setName("portal");
        mapBox.setFriction(0.1);
        mapBox.setSensor(true);
        mapBox.attachImage(portal);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }if(tempColor == #00FF00){
        mapBox = new FBox(gridSize,gridSize/6);
        mapBox.setName("trampoline");
        mapBox.setFriction(0.2);
        mapBox.attachImage(loadImage("tramp.png"));
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        mapBox.setRestitution(2);
        world.add(mapBox);
      }
      if(tempColor == color(0,200,0)){
        mapBox = new FBox(gridSize,gridSize/6);
        mapBox.setName("supertrampoline");
        mapBox.setFriction(0);
        if(map.get(x,y+1)==black){
          mapBox.attachImage(loadImage("tramp.png"));
        }else if(map.get(x+1,y)==black){
          mapBox.attachImage(loadImage("trampright.png"));
        }else if(map.get(x-1,y)==black){
          mapBox.attachImage(loadImage("trampleft.png"));
        }else if(map.get(x,y-1)==black){
          mapBox.attachImage(loadImage("trampup.png"));
        }
        
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        mapBox.setRestitution(4);
        world.add(mapBox);
      }
      if(tempColor == coin){
        FCoin coin = new FCoin(x*gridSize,y*gridSize);
        terrain.add(coin);
        world.add(coin);
      }
      if(tempColor == #FF0000){
        mapBox = new FBox(gridSize,gridSize/20);
        mapBox.setName("spike");
        mapBox.setFriction(0);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        if(currmap<8){
            if(map.get(x,y+1)==black){
          mapBox.attachImage(spike);
        }else if(map.get(x+1,y)==black){
          mapBox.attachImage(loadImage("spikesright.png"));
        }else if(map.get(x-1,y)==black){
          mapBox.attachImage(loadImage("spikesleft.png"));
        }else if(map.get(x,y-1)==black){
          mapBox.attachImage(loadImage("spikestop.png"));
        }else{
          mapBox.attachImage(spike);
        }
        }else if(currmap>7){
            if(map.get(x,y+1)==black){
          mapBox.attachImage(hellspike);
        }else if(map.get(x+1,y)==black){
          mapBox.attachImage(loadImage("hellspikesright.png"));
        }else if(map.get(x-1,y)==black){
          mapBox.attachImage(loadImage("hellspikesleft.png"));
        }else if(map.get(x,y-1)==black){
          mapBox.attachImage(loadImage("hellspikestop.png"));
        }else{
          mapBox.attachImage(hellspike);
        }
        }
        
        world.add(mapBox);
      }
      
      if(tempColor == white){
        FBridge bridge = new FBridge(x*gridSize,y*gridSize,loadImage("bridgecenter.png"));
        terrain.add(bridge);
        world.add(bridge);
        
      }
      if(tempColor == sideEnemy){
        FThing enemy = new FThing(x*gridSize,y*gridSize);
        enemies.add(enemy);
        world.add(enemy);
        
      }
      if(tempColor == bmon){
        FMonster enemy = new FMonster(x*gridSize,y*gridSize);
        enemies.add(enemy);
        world.add(enemy);
        
      }
      if(tempColor == grassColor){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("grass");
        mapBox.attachImage(loadImage("grass.png"));
        mapBox.setFriction(1);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == color(100,0,0)){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("dirt");
        mapBox.attachImage(loadImage("dirt.png"));
        mapBox.setFriction(1);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == smashTrigger){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("smashTrigger");
        mapBox.attachImage(loadImage("dirt.png"));
        mapBox.setFriction(1);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == smashEnemy){
        FSmash smashenemy = new FSmash(x*gridSize,y*gridSize);
        enemies.add(smashenemy);
        world.add(smashenemy);
      }
      if(tempColor == dirtWall){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("dirtWall");
        mapBox.attachImage(loadImage("dirt.png"));
        mapBox.setFriction(1);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == lavaColor){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("lava");
        mapBox.attachImage(lava);
        mapBox.setFriction(0);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setSensor(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      
    }
  }    
    }
    
    
    
  }
}
