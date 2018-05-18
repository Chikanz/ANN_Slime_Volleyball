Slime s1;
Slime s2;
Scene scene;
Ball ball;
CollisionManager CM;
RoundManager RM;
NeuralNetwork NN1;
NeuralNetwork NN2;
GeneticTrainer GT;

boolean traning = true;

float gameFrames = 0;

boolean gameOn = false;
//float lastBallX[] = 0;
boolean firstRally = false;

int FrameyRate = 600;

final PVector[] normalizeVals =
{
    new PVector(43, 357),   //p1 X
    new PVector(350, 450),  //p1 Y
    new PVector(-7, 7),     //p1 X delta
    new PVector(-7, 7),     //p1 Y delta

    //new PVector(-43, -357),   //p2 X
    //new PVector(350, 450),  //p2 Y
    //new PVector(-7, 7),     //p2 X delta
    //new PVector(-7, 7),     //p2 Y delta

    new PVector(-450,450),   //Ball X
    new PVector(450,50),   //Ball Y

    new PVector(-10, 10),    //ball X delta
    new PVector(-10, 10),    //ball Y delta
};

void setup() 
{
  // Window size
  size(800, 500);

  frameRate(FrameyRate);
  stroke(0, 0, 0, 20);

  s1 = new Slime(0);
  s2 = new Slime(1);
  scene = new Scene();
  ball = new Ball();
  CM = new CollisionManager();
  RM = new RoundManager();

  //Add physics objects collision
  CM.AddObject(s1);
  CM.AddObject(s2);
  CM.AddObject(ball);

  NN1 = new NeuralNetwork(12,8,3);
  NN2 = new NeuralNetwork(12,8,3);

  GT = new GeneticTrainer();
  //GT.Read(131);
  //frameRate(10);
}

void draw()
{
    if(gameOn)
    {
        GameLoop();
        //This creates matches that are dependent on the opponent's skill
        if(gameFrames > 5000) gameOn = false; //End game 
    }
    else if(traning)
    {
        println("end game!");

        //Sum fitness if we just played a round
        if(NN1.GetBrain() != null)
        {            
            DNA d1 = NN1.GetBrain();
            DNA d2 = NN2.GetBrain();                        

            d1.AddFitness(s1.touches, s1.rallySecs, s1.movedelta, s1.otherMovedelta, RM.p1Score, RM.p2Score);
            d2.AddFitness(s2.touches, s2.rallySecs, s2.movedelta, s1.otherMovedelta, RM.p2Score, RM.p1Score);
            
            s1.ResetStats();
            s2.ResetStats();
        }

        //Next generation if we've played all rounds in this gen
        if(!GT.HasNext())
        {
            println("next gen!");
            GT.NextGeneration();
        }
        
        DNA p1 = GT.GetNext();
        DNA p2 = GT.GetNext();
        
        NN1.LoadBrain(p1);
        NN2.LoadBrain(p2);

        gameFrames = 0;

        //lastBallX = ball.GetPos().x;

        RM.Reset();
        Reset();
        gameOn = true;
    }
}

void GameLoop()
{
    gameFrames++;

    background(0, 204, 255);

    scene.DrawEnv();

    //AI 
    AIStep(s1,s2, 0);
    AIStep(s2,s1, 1);

    s1.Update(ball.GetPos());    
    s2.Update(ball.GetPos());  

    ball.Update();  

    CM.SendCollisionMessages();  
    RM.Update();

    //Check round over
    if(ball.HitFloor())
    {
        boolean p1Won = ball.PlayerWon();
        gameOn = !RM.Score(p1Won);
        Reset();
    }
}

//Slime movement
void keyPressed()
{  
   if(key == 'w') 
   {
       GT.Write();
   }

   if(key == 'f') 
   {
       FrameyRate =  FrameyRate == 600 ? 60 : 600;
       frameRate(FrameyRate);
   }

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
    ball.Reset(true);
}

void AIStep(Slime player, Slime opponent, int playerNO)
{
    //Feed inputs
    float[] in = {
        Math.abs(width/2 - player.GetPos().x), player.GetPos().y, player.Velocity.x, player.Velocity.y,
        //-Math.abs(width/2 - opponent.GetPos().x), opponent.GetPos().y, opponent.Velocity.x, opponent.Velocity.y, 
        width/2 - ball.GetPos().x, ball.GetPos().y, ball.Velocity.x, ball.Velocity.y
        };

    //Flip ball x value signs if we're on player2's side
    if(playerNO == 1) 
    {
        in[2] = -in[2]; //Player x velocity 
        //in[6] = -in[6]; //Opponent x velocity
        //in[8] = -in[8]; //Ball X 
        //in[10] = -in[10]; //Ball X velocity 

        in[4] = -in[4]; //Ball X 
        in[8] = -in[8]; //Ball X velocity 
    }

    //Normalize
    for(int i = 0; i < in.length; i++)
    {
        in[i] = map(in[i], normalizeVals[i].x, normalizeVals[i].y, -1, 1);
    }

    String[] InHeaders =
    {
        "p1 x",
        "p1 y",
        "p1 xvel",
        "p1 yvel",
        //"p2 x",
        //"p2 y",
        //"p2 xvel",
        //"p2 yvel",
        "ball x",
        "ball y",
        "ball xvel",
        "ball yvel",
    };
    
    //player.otherMovedelta += Math.abs(opponent.Velocity.x);

    
    float[] out = playerNO == 0 ? NN1.FeedForward(in) : NN2.FeedForward(in);      

    for(int i = 0; i <  in.length; i++)
    {        
        text(playerNO + " " + InHeaders[i] + " " + in[i], ((width - 200) * playerNO) + 100 , (10 * i) + 100);
    }    

    //Swap sides
    if(playerNO == 0)
    {
        player.KeyBoardInput('A', out[0] > 0.5);
        player.KeyBoardInput('D', out[1] > 0.5);
        player.KeyBoardInput('W', out[2] > 0.5);
    }
    else
    {
        player.KeyBoardInput(RIGHT, out[0] > 0.5);
        player.KeyBoardInput(LEFT, out[1] >  0.5);
        player.KeyBoardInput(UP, out[2] >    0.5);
    }
}