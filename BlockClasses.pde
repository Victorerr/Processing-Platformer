class FGameObject extends FBox{
  final int L = -1;
  final int R = 1;
  FGameObject(){
    super(gridSize,gridSize);
  }
  FGameObject(float x, float y){
    super(x,y);
  }
  
  void act(){
    
  }
  
  boolean isTouching(String n){
    ArrayList<FContact> contacts = getContacts();
    for(int i = 0; i < contacts.size(); i++){
      FContact fc = contacts.get(i);
      if(fc.contains(n)){
        return true;
      }
    }
    return false;
  }
}

class FBridge extends FGameObject{
  FBridge(float x, float y, PImage image){
    super();
    setPosition(x,y);
    setStatic(true);
    setName("bridge");
    attachImage(image);
  }
  void act(){
    if(isTouching("player")){
      setStatic(false);
      setSensor(true);    
    }
  }  
}
class FCoin extends FGameObject{
  FCoin(float x, float y){
    super();
    setPosition(x,y);
    setSensor(true);
    setStatic(true);
    setName("coin");
    attachImage(loadImage("coin.png"));
  }
  void act(){
    if(isTouching("player")){
      coins++;
      world.remove(this);
    }
  }  
}
class FSign extends FGameObject{
  FSign(float x, float y, String message){
    super();
    setPosition(x,y);
    setStatic(true);
    setName("sign");
    attachImage(loadImage("Sign.png"));
  }
  void act(){
    if(abs(getX()-player.getX())<100){
      
    }
  }  
}
