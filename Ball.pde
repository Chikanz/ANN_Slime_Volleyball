public class Ball extends PhysicsObject
{    

    public int trainingCounter = 0;

    public Ball ()
    {
        tag = "Ball";
        radius = 20;
        Gravity = 0.2;

        Position.x = (width/2)/2;
        Reset(true);
    }

    void Update()
    {
        super.Update();

        //draw
        fill(255);
        ellipse(Position.x, Position.y, radius, radius);

        //Hit sides
        if(Position.x <= 0)
        {
            Position.x = 0;
            Velocity.x = -Velocity.x;
        }

        if(Position.x >= width)
        {
            Position.x = width;
            Velocity.x = -Velocity.x;
        }        

        //Net p2
        if(Position.x >= width/2 && Position.x <= width/2 + 10 &&  Position.y > Ground - 50 )
        {
            Position.x = width/2 + 10;
            Velocity.x = -Velocity.x;
        }

        //Net p1
        if(Position.x <= width/2 && Position.x >= width/2 - 10 &&  Position.y > Ground - 50 )
        {
            Position.x = width/2 - 10;
            Velocity.x = -Velocity.x;
        }
        
        //DrawVelocity();
    }

    //Hit floor
    public Boolean HitFloor()
    {
        return Position.y >= Ground;
    }

    //Find which player won 
    Boolean PlayerWon()
    {
        //if(Position.x > width/2) return true;   //p1
        //if(Position.x < width/2) return false;  //p2

        return Position.x > width/2;
    }

    //called at the start of a new round
    void Reset(boolean training)
    {
        Stop(0,0);
        Position.y = PhysicsObject.Ground - 150;

        if(training)
        {
            Position.x = width/2;
            trainingCounter++; //modulate sides
            float sideForce = trainingCounter % 2 == 0 ? -1 : 1;
                AddForce(new PVector(sideForce * random(1,5),-random(5,10))); 
        }
        else
        {
            int playerNo = PlayerWon() ? 0 : 1;
            //Position.y = PhysicsObject.Ground - 150;

            if(playerNo == 0)
                Position.x = (width/2)/2;
            else
                Position.x = (width/2/2) + width/2;
        }
    }


    void OnCollision(PhysicsObject other)
    {   

    }

}
