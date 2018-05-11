Slime s1;
Slime s2;
Scene scene;
Ball ball;
CollisionManager CM;
RoundManager RM;

void setup() 
{
  // Window size
  size(800, 500);

  frameRate(60);
  stroke(0, 0, 0, 20);

  s1 = new Slime(0);
  s2 = new Slime(1);
  scene = new Scene();
  ball = new Ball();
  CM = new CollisionManager();
  RM = new RoundManager();

  //Add physics objects
  CM.AddObject(s1);
  CM.AddObject(s2);
  CM.AddObject(ball);

}

void draw()
{
    background(0, 204, 255);

    scene.DrawEnv();

    s1.Update();    
    s2.Update();  
    s1.LookAt(ball.GetPos());
    s2.LookAt(ball.GetPos());

    ball.Update();  

    CM.SendCollisionMessages();  
    RM.Update();

    //Check round over
    if(ball.HitFloor())
    {
        boolean p1Won = ball.PlayerWon();
        RM.Score(p1Won);
        delay(1000);
        Reset();
    }
}

//Slime movement
void keyPressed()
{    
   s1.KeyBoardInput(keyCode, true);
   s2.KeyBoardInput(keyCode, true);
}

void keyReleased()
{
    s1.KeyBoardInput(keyCode, false);
    s2.KeyBoardInput(keyCode, false);
}

void Reset()
{
    s1.Reset();
    s2.Reset();
    ball.Reset();
}