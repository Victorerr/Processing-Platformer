import fisica.*;
boolean overworld;
String message;
color black = #000000;
color white = #FFFFFF;
color grassColor = color(44,110,66);
color portalColor = #FF00FF;
color sideEnemy = color(1,1,1);
color smashEnemy = color(2,2,2);
color smashTrigger = color(5,5,5);
color dirtWall = color(33,33,33);
color lavaColor = color(107,107,107);
color bmon = color(15,15,15);
color coin = color(7,7,7);
float spinstamina;
int telemode;
int spinnerframe;
PImage threeheart, twoheart, oneheart;
FWorld world;
boolean flymode;
boolean canJump;
boolean touchedFloor;
boolean stupiddebug;
boolean upkey,downkey,rightkey,leftkey;
boolean openDoor;
boolean attacking;
int playermode;
int coins;
int lives;
int currmap;
FBox mapBox;
color background;
int currframe;
int gridSize = 60;
PImage map, stone, portal, spike, hellspike, lava;
Player player;
long time;
boolean finishedTransition;
float swingframe;
ArrayList<PImage> frames;
boolean menu;

ArrayList<FGameObject> terrain;
ArrayList<FGameObject> enemies;
color[] jumpable = {black, grassColor, dirtWall, smashEnemy, smashTrigger, white, color(100,0,0), sideEnemy};

int gamemode;
float hp;
PImage swordswingimage;

ArrayList<String> Inventory = new ArrayList<>();
int equiptedweapon;

boolean startscreen;
void setup(){
  size(960,960);
  message = "";
  coins = 0;
  menu = false;
  spinstamina = 100;
  Inventory.add("beginnersword");

  equiptedweapon = 0;
  swingframe = 1;
  attacking = false;
  flymode = false;
  threeheart = loadImage("3heart.png");
  twoheart = loadImage("2heart.png");
  oneheart = loadImage("1heart.png");
  time = 0;
  hp=100;
  finishedTransition = true;
  gamemode = 0;
  textAlign(CENTER,CENTER);
  rectMode(CENTER);
  startscreen = true;
  frames = new ArrayList<PImage>();
  overworld = false;
  openDoor = false;
  currframe = 0;
  telemode = 0;
  background = black;
  terrain = new ArrayList<FGameObject>();
  enemies = new ArrayList<FGameObject>();
  stupiddebug = false;
  currmap = 8;
  canJump = true;
  touchedFloor = true;
  rectMode(CENTER);
  lives = 0;
  Fisica.init(this);
  world = new FWorld(-2000,-2000,2000,2000);
  world.setGravity(0,980);
  map = loadImage("pixilart-drawing.png");
  stone = loadImage("stone.jpg");
  portal = loadImage("portal.jpg");
  spike = loadImage("spikes.png");
  hellspike = loadImage("hellspikes.png");
  lava = loadImage("lava.jpg");
  
}

void createWorld(){
  println(player.getX() + " " + player.getY());
  world.step();
  if(player.getX()<width/2&&player.getY()>930+height/2){
    translate(0,-930);
  }else if(player.getX()<width/2&&player.getY()<1290){
    translate(0,-player.getY()+height/2);
  }else if(player.getX()>1410&&player.getY()>930+height/2){
    translate(-1410 + width/2,-930);
  }else if(player.getX()>1410&&player.getY()<1290){
    translate(-1410 + width/2,-player.getY()+height/2);
  }else if(player.getX()<width/2){
    translate(0,-player.getY()+height/2);
  }else if(player.getY()>930+height/2){
    translate(-player.getX()+width/2,-930);
  }else if(player.getY()<1290){
    translate(-player.getX()+width/2,-player.getY()+height/2);
  }else if(player.getX()>1410){
    translate(-1410 + width/2,-player.getY()+height/2);
  }else{
    translate(-player.getX()+width/2,-player.getY()+height/2);
  }
  world.draw();
  
}  

void worldAct(){
  player.act();
}

void doPlayer(float x, float y){
  player = new Player(x,y);
  world.add(player);
}

void button(float x, float y, String text){
  textSize(30);
  strokeWeight(1);
  stroke(0);
  fill(150);
  if(mouseX<x+100&&mouseX>x-100&&mouseY<y+25&&mouseY>y-25){
    fill(0);
  }
  rect(x,y,200,50);
  fill(120);
  rect(x,y,175,25);
  fill(255);
  text(text,x,y);
}

void button(float x, float y, String text, String message){
  textSize(30);
  strokeWeight(1);
  stroke(0);
  fill(150);
  if(mouseX<x+100&&mouseX>x-100&&mouseY<y+25&&mouseY>y-25){
    fill(0);
  }
  rect(x,y,200,50);
  fill(120);
  rect(x,y,175,25);
  fill(255);
  text(text,x,y);
  if(mouseX<x+100&&mouseX>x-100&&mouseY<y+25&&mouseY>y-25){
  textSize(20);
  text(message,width/2,height/2+200);
  }
}

void draw(){
  background(0);
  if(currmap>12){
    canJump = false;
  }
  if(spinstamina<=0){
    attacking = false;
  }
  if(!attacking&&spinstamina<100){
    spinstamina+=0.5;
  }
  time++;
  if(hp<1){
    if(currmap==15){
      world = new FWorld();
      background(0);
      textSize(50);
      fill(255);
      text("THE END", width/2, height/2);
    }else{
      lives--;
      player.doPortal();
      hp = 100;
    }
  }
  if(lives==0){
    stroke(0);
    strokeWeight(1);
    //currmap = 0;
    world = new FWorld();
    
    startscreen = true;
  }
  if(menu){
    button(width/2,height/2-100,"roll? (5 gold)");
    button(width/2,height/2+200,"start screen");
    text(message,width/2,height/2+300);
  }
  else if(startscreen){
    world = new FWorld();
    textSize(50);
    text("SURVIVE", width/2, height/2);
    button(width/2,height/2+300,"Normal mode", "Average gameplay.");
    button(width/2-300,height/2+300,"Hard mode", "Only 3 lives. Can be challenging.");
    button(width/2+300,height/2+300,"Challenge", "One life, custom map.");
    
  }else{
    //if(currmap==7){
        //openDoor = false;
        //finishedTransition = true;
      //}
    if(openDoor){
    try{
      PImage tempimg;
      if(!overworld){
        if(currmap<6){
          if(currframe<10){
            tempimg = loadImage("frame_0" + (currmap-2) + "_delay-0.1s.gif");
          }else{
            tempimg = loadImage("frame_" + (currmap-2) + "_delay-0.1s.gif");
          }
        }else if(currmap==8){
          if(currframe<10){
            tempimg = loadImage("frame_00" + currframe + "_delay-0.06s.gif");
          }else if(currframe< 100){
            tempimg = loadImage("frame_0" + currframe + "_delay-0.06s.gif");
          }else{
            tempimg = loadImage("frame_" + currframe + "_delay-0.06s.gif");
          }
        }else if(currmap>8){
          tempimg = loadImage("lockedin.jpg");
          if(currframe==10){
            tempimg = loadImage("");
          }
        }else{
          tempimg = loadImage("frame_" + currframe + "_delay-0.06s.gif");
        }
        image(tempimg,0,0,width,height);
      }else{
        if(currmap==6){
          if(currframe<10){
            tempimg = loadImage("frame_0" + currframe + "_delay-0.1s.gif");
          }else{
            tempimg = loadImage("frame_" + currframe + "_delay-0.1s.gif");
          }  
        }else{
          tempimg = loadImage("");
        }
        image(tempimg,0,0,width,height);
      }
      
      currframe++;
      
    }catch(Exception e){
      openDoor = false;
      finishedTransition = true;
      player.doPortal();
      currframe = 0;
    }
  }else{
    background(background);
  for(int i = 0; i<terrain.size(); i++){
    terrain.get(i).act();
  }
  for(int i = 0; i<enemies.size(); i++){
    enemies.get(i).act();
  }
  worldAct();
  createWorld();
  
  if(hp>70){
    image(threeheart,player.getX(),player.getY()-100);
  }else if(hp>40){
    image(twoheart,player.getX(),player.getY()-100);
  }else if(hp>10){
    image(oneheart,player.getX(),player.getY()-100);
  }
  float xpo = 0;
  float ypo = 0;
  if(currmap>7&&currmap<13){
    if(time%100<50){
        fill(255,0,0);
        strokeWeight(5);
        stroke(255,0,0);
        ypo = random(0,500);
        xpo = random(0,map.width*gridSize);
        line(map.width*gridSize/2,ypo,xpo,map.height*gridSize);
      if(time%50>35){
        FBullet bult = new FBullet((float)map.width*gridSize/2,ypo,((map.width*gridSize/2)-xpo)*-10,(map.height*gridSize-ypo)*10);
        world.add(bult);
      }
    }
  }
  }
  
  if(attacking){
    try{
      if(Inventory.get(equiptedweapon).equals("beginnersword")){
        swordswingimage = loadImage("sword" + (int)swingframe + ".png");
      if(swingframe<5){
        image(swordswingimage,player.getX()+30,player.getY()-30);
      }else{
        attacking = false;
        swingframe = 1;
      }
      swingframe+=0.2;
    }else if(Inventory.get(equiptedweapon).equals("spinner")){
      if(swingframe > 12){
        swingframe = 1;
        }
        swordswingimage = loadImage("spinner" + (int)swingframe + ".png");
        image(swordswingimage,player.getX()-100,player.getY()-80);
        spinstamina-=0.3;
        swingframe ++;
      }else if(Inventory.get(equiptedweapon).equals("BIG")){
        if(swingframe > 6){
        swingframe = 0;
        }
        
          swordswingimage = loadImage("bigsword" + (int)swingframe + ".gif");
        
        image(swordswingimage,player.getX()-230,player.getY()-300);
        spinstamina--;
        swingframe +=0.5;
        
      }else if(Inventory.get(equiptedweapon).equals("Tele")){
        hp-=0.1;
      }
      
    }catch(Exception e){
      
    }
    
    
  }
  image(loadImage("INVENTORY.png"),player.getX(),player.getY()-140);
  textSize(20);
  for(int i = 0; i<Inventory.size(); i++){
    fill(255);
    if(i==equiptedweapon){
      fill(255,0,0);
    }
    if(Inventory.get(i).equals("beginnersword")){
      text("s",player.getX()+i*30+15,player.getY()-125);
    }else if(Inventory.get(i).equals("spinner")){
      text("scy",player.getX()+i*30+15,player.getY()-125);
    }else if(Inventory.get(i).equals("BIG")){
      text("S",player.getX()+i*30+15,player.getY()-125);
    }else if(Inventory.get(i).equals("Tele")){
      text("Tk",player.getX()+i*30+15,player.getY()-125);
    }
  }
  }
  if(Inventory.get(equiptedweapon).equals("spinner")){
    fill(255,255,0);
    strokeWeight(1);
    stroke(255);
    rect(player.getX(),player.getY()+60,map(spinstamina,0,100,0,80),20);
  }
  
  
}

void keyPressed(){
  if(keyCode == UP||key == ' '){
    if(!flymode){
      if(canJump){
      canJump = false;
      upkey = true;
    }
    }else{
      upkey = true;
    }

    
  }else{
    if(keyCode == LEFT){
    leftkey = true;
  }
  if(keyCode == DOWN){
    downkey = true;
  }
  if(keyCode == RIGHT){
    rightkey = true;
  }
  }
  if(key=='F'||key=='f'){
    flymode = true;
    world.setGravity(0,0);
  }
  if(key == 'z'){
    if(!attacking){
      if(Inventory.get(equiptedweapon).equals("spinner")){
        if(spinstamina>25){
          attacking = true;
        }
      }else{
        attacking = true;
      }
      
    }
  }
  
}

void keyReleased(){
  if(key=='F'||key=='f'){
    flymode = false;
    world.setGravity(0,980);
  }
  if(key == 't'){
    telemode++;
    if(telemode>2){
      telemode = 0;
    }
  }
  if(key == 'd'){
    if(equiptedweapon!=0)
    Inventory.remove(equiptedweapon);
    equiptedweapon = 0;
  }
  if(key=='m'){
    menu = !menu;
  }
  if(key == 'z'){
    attacking = false;
    swingframe = 1;
  }
  if(keyCode == UP||key == ' '){
      upkey = false;
  }
  if(keyCode == LEFT){
    leftkey = false;
  }
  if(keyCode == DOWN){
    downkey = false;
  }
  if(keyCode == RIGHT){
    rightkey = false;
  }
  
  if(key == '1'){
    equiptedweapon = 0;
  }
  if(key == '2'){
    equiptedweapon = 1;
  }
  if(key == '3'){
    equiptedweapon = 2;
  }
  if(key == '4'){
    equiptedweapon = 3;
  }
  if(key == '5'){
    equiptedweapon = 4;
  }
  if(key == '6'){
    equiptedweapon = 5;
  }
  
}

void mousePressed(){
  if(menu){
    textSize(30);
    fill(255);
    if(coins>4){
      coins-=5;
      if(mouseX<width/2+100&&mouseX>width/2-100&&mouseY<height/2-100+25&&mouseY>height/2-100-25){
      float random = random(0,30);
      boolean found = false;
      
      while(found!=true){
        if(Inventory.size()>3){
          found = true;
          message = "Inventory Slots full";
        }else{
          if(random<10){
          for(String weapontemp:Inventory){
            if(weapontemp.equals("Tele")){
              continue;
            }
          }
          found = true;
          message = "You got telekinesis! Congrats!";
          Inventory.add("Tele");
        }else if(random<20){
          for(String weapontemp:Inventory){
            if(weapontemp.equals("BIG")){
              continue;
            }
          }
          found = true;
          message = "You got BIG SWORD! Congrats!";
          Inventory.add("BIG");
        }else{
          for(String weapontemp:Inventory){
            if(weapontemp.equals("spinner")){
              continue;
            }
          }
          found = true;
          message = "You got Scythe! Congrats!";
          Inventory.add("spinner");
        }
        }
        random = random(0,30);
        
      }
      
    }
    }
    
    if(mouseX<width/2+100&&mouseX>width/2-100&&mouseY<height/2+200+25&&mouseY>height/2+200-25){
      startscreen = true;
      menu = false;
    }
    
  }
  if(startscreen){
    if(mouseX<width/2+100&&mouseX>width/2-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25){
      world = new FWorld();
      currmap = 1;
      map = loadImage("pixilart-drawing.png");
      doPlayer(450,1500);
      world.setGravity(0,980);
      lives = 1000;
      gamemode = 0;
    //normal
    }
    if(mouseX<width/2-300+100&&mouseX>width/2-300-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25){
    world = new FWorld();
    map = loadImage("pixilart-drawing.png");
    currmap = 1;
    lives = 3;
    doPlayer(450,1500);
    world.setGravity(0,980);
    gamemode = 1;
    //hard
    }
    if(mouseX<width/2+300+100&&mouseX>width/2+300-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25){
    world = new FWorld();
    map = loadImage("pixilart-drawing.png");
    currmap = 1;
    lives = 1;
    doPlayer(450,1500);
    world.setGravity(0,980);
    gamemode = 2;
    //challenge
    }
    if(mouseX<width/2+300+100&&mouseX>width/2+300-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25||mouseX<width/2-300+100&&mouseX>width/2-300-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25||mouseX<width/2+100&&mouseX>width/2-100&&mouseY<height/2+300+25&&mouseY>height/2+300-25){
      startscreen = false;
    for(int y = 0 ; y < map.height ; y++){
    for(int x = 0 ; x < map.width ; x++){
    color tempColor = map.get(x,y);
      
      if(tempColor == black){
        mapBox = new FBox(gridSize,gridSize);
        mapBox.setName("darkGround");
        mapBox.setFriction(1);
        mapBox.attachImage(stone);
        mapBox.setPosition(x*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      if(tempColor == portalColor){
        mapBox = new FBox(gridSize/6,gridSize);
        mapBox.setName("portal");
        mapBox.setFriction(0.1);
        mapBox.attachImage(portal);
        mapBox.setPosition((x)*gridSize,y*gridSize);
        mapBox.setStatic(true);
        mapBox.setGrabbable(false);
        world.add(mapBox);
      }
      
    }
  }
    }
  }
}
