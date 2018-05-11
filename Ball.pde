public class Ball extends PhysicsObject
{    
    public Ball ()
    {
        tag = "Ball";
        radius = 20;
        Gravity = 0.2;

        Position.x = (width/2)/2;
        Reset();
    }

    void Update()
    {
        super.Update();

        //draw
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

        DrawVelocity();
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
    void Reset()
    {
        Stop(0,0);
        int playerNo = PlayerWon() ? 0 : 1;
        Position.y = PhysicsObject.Ground - 80;
        Position.x = (width/2)/2 * ((playerNo + 1)) * 2;
    }


    void OnCollision(PhysicsObject other)
    {   

    }

}
