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

  //Add physics objects
  CM.AddObject(s1);
  CM.AddObject(s2);
  CM.AddObject(ball);

  NN1 = new NeuralNetwork(12,8,3);
  NN2 = new NeuralNetwork(12,8,3);

  GT = new GeneticTrainer();
}

void draw()
{
    if(gameOn)
    {
        GameLoop();
        if(gameFrames > 1200) gameOn = false; //End game
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
    ball.Reset();
}

void AIStep(Slime player, Slime opponent, int playerNO)
{
    float[] in = {
        Math.abs(width/2 - player.GetPos().x), player.GetPos().y, player.Velocity.x, player.Velocity.y,
        -Math.abs(width/2 - opponent.GetPos().x), opponent.GetPos().y, opponent.Velocity.x, opponent.Velocity.y, 
        width/2 - ball.GetPos().x, ball.GetPos().y, ball.Velocity.x, ball.Velocity.x,
        };

    //Flip ball x sign if we're on player2's side
    if(playerNO == 1) in[8] = -in[8];

    String[] InHeaders =
    {
        "p1 x",
        "p1 y",
        "p1 xvel",
        "p1 yvel",
        "p2 x",
        "p2 y",
        "p2 xvel",
        "p2 yvel",
        "ball x",
        "ball y",
        "ball xvel",
        "ball yvel",
    };
    
    if(in[8] < 0) player.rallySecs += millis();

    //if(in[8] < 0 && lastBallX[playerNO] > 0 || in[8] > 0 && lastBallX[playerNO] < 0)
    //{
    //    s1.rallySecs += 1;
    //    println(in[8] + " " + lastBallX[playerNO]);
    //}

    //lastBall[playerNO] = in[8];

    player.otherMovedelta += Math.abs(opponent.Velocity.x);

    
    float[] out = playerNO == 0 ? NN1.FeedForward(in) : NN2.FeedForward(in);      

    //for(int i = 0; i <  in.length; i++)
    //{        
    //    text(playerNO + " " + InHeaders[i] + " " + in[i], ((width - 200) * playerNO) + 100 , (10 * i) + 100);
    //}
    //println("----");

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