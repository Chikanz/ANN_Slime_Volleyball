Slime s1;
Slime s2;
Scene scene;
//Ball ball;
Ball p1ball;
Ball p2ball;
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

int FrameyRate = 60;

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
  p1ball = new Ball();
  p2ball = new Ball();
  p2ball.trainingCounter = 1;
  CM = new CollisionManager();
  RM = new RoundManager();

  //Add physics objects collision
  CM.AddObject(s1);
  CM.AddObject(s2);
  CM.AddObject(p1ball);
  CM.AddObject(p2ball);

  //131
  //NN1 = new NeuralNetwork(12,8,3);
  //NN2 = new NeuralNetwork(12,8,3);

  //
  NN1 = new NeuralNetwork(8,7,3);
  NN2 = new NeuralNetwork(8,7,3);

  GT = new GeneticTrainer(NN1.GlobalConnectionCount);
  GT.Read(NN1.GlobalConnectionCount);
}

void draw()
{
    if(gameOn)
    {
        GameLoop();        
        if(gameFrames > 100000)
        {
            gameOn = false; //End round 
            println("holy fuck");
            GT.Write();
        }
    }
    else if(traning)
    {
        println("end game!");

        p1ball.Reset(true);
        //p2ball.Reset(true);        

        //Sum fitness if we just played a round
        if(NN1.GetBrain() != null)
        {            
            DNA d1 = NN1.GetBrain();
            DNA d2 = NN2.GetBrain();                        

            d1.AddFitness(s1.touches, s1.rallySecs, s1.movedelta, s1.score, RM.p2Score);
            d2.AddFitness(s2.touches, s2.rallySecs, s2.movedelta, s2.score, RM.p1Score);
            
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
        NN1.LoadBrain(p1);

        if(GT.HasNext())
        {
            DNA p2 = GT.GetNext();
            NN2.LoadBrain(p2);
        }
        else
        {
            NN2.LoadBrain(new DNA(NN1.GlobalConnectionCount));
        }

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
    //AIStep(s1,s2, p1ball, 0);
    AIStep(s2,s1, p1ball, 1);

    s1.Update(p1ball.GetPos());    
    s2.Update(p1ball.GetPos());  

    p1ball.Update();  
    //p2ball.Update();  

    CM.SendCollisionMessages();  
    RM.Update();

    //reset balls
    if(p1ball.HitFloor()) 
    {
        boolean p1Won = p1ball.PlayerWon();
        gameOn = !RM.Score(p1Won); //For competitive

        if(p1ball.GetPos().x > width/2) s2.score += 1;
        if(p1ball.GetPos().x < width/2) s1.score += 1;

        p1ball.Reset(true);
        Reset();
    }
    
    //if(p2ball.HitFloor())
    //{
    //    s2.score += 1;
    //    p2ball.Reset(true);
    //    s2.Reset();
    //}

    //Add score
    //if(p1ball.GetPos().x > width/2 + 10)
    //{
    //    s1.rallySecs++; //Add a rally point
    //    p1ball.Reset(true);
    //}
//
    //if(p2ball.GetPos().x < width/2 - 10)
    //{
    //    s2.rallySecs++; //Add a rally point
    //    p2ball.Reset(true);
    //}

    //Check round over
    //if(ball.HitFloor())
    //{
    //    //boolean p1Won = ball.PlayerWon();
    //    //gameOn = !RM.Score(p1Won); //For competitive
    //    //Reset(); //Competitive
    //    ball.Reset(true);
    //}
}

//Slime movement
void keyPressed()
{  
   if(key == 'v') 
   {
       GT.Write();
   }

   if(key == 'f') 
   {
       FrameyRate =  FrameyRate == 600 ? 60 : 600;
       frameRate(FrameyRate);
   }

   if(key == 'c')
   {
       if(GT.HasNext()) 
       {
            println("got next");
            NN2.LoadBrain(GT.GetNext());
        Reset();
       }
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
    //ball.Reset(true);
}

void AIStep(Slime player, Slime opponent, Ball b, int playerNO)
{
    //Feed inputs
    float[] in = {
        Math.abs(width/2 - player.GetPos().x), player.GetPos().y, player.Velocity.x, player.Velocity.y,
        //-Math.abs(width/2 - opponent.GetPos().x), opponent.GetPos().y, opponent.Velocity.x, opponent.Velocity.y, 
        width/2 - b.GetPos().x, b.GetPos().y, b.Velocity.x, b.Velocity.y
        };

    //Flip ball x value signs if we're on player2's side
    if(playerNO == 1) 
    {
        in[2] = -in[2]; //Player x velocity 
        //in[6] = -in[6]; //Opponent x velocity
        //in[8] = -in[8]; //Ball X 
        //in[10] = -in[10]; //Ball X velocity 

        in[4] = -in[4]; //Ball X 
        in[6] = -in[6]; //Ball X velocity 
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

    //Feed input into network
    float[] out = playerNO == 0 ? NN1.FeedForward(in) : NN2.FeedForward(in);      

    //for(int i = 0; i <  in.length; i++)
    //{        
    //    text(playerNO + " " + InHeaders[i] + " " + in[i], ((width - 200) * playerNO) + 100 , (10 * i) + 100);
    //}    

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