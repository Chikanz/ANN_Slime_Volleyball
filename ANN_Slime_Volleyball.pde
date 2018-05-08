Slime s;

void setup() 
{
  // Window size
  size(800, 500);

  // increase/decrease for testing
  frameRate(60);
  stroke(0, 0, 0, 20);

  s = new Slime(0);
}

void draw()
{
    clear();
    background(0, 204, 255);

    if(keyPressed)
        s.KeyBoardInput(key);

    s.Update();
}

void keyPressed()
{    
   
}

void keyReleased()
{
    s.Move(0);
    //println("stop");
}