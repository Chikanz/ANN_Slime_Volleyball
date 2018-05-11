import java.util.*;

public class Slime extends PhysicsObject
{
    private float speed = 10;
    private int playerNo;
    private float thiccness = 100;

    private int moveForce;
    private int jumpForce = 7;
    private Boolean canJump = true;

    //movement
    Boolean right = false;
    Boolean left = false;
    Boolean jump = false;

    private float hitForce = 6;

    ArrayList barriers = new ArrayList();

    public Slime (int player) 
    {
        tag = "Slime";
        radius = thiccness/2;
        playerNo = player;
        Position.y = Ground;
        Position.x = (width/2)/2 * (playerNo + 1);

        //add in barriers
        barriers.add(new Barrier(thiccness/2, false));
        barriers.add(new Barrier(width - thiccness/2, true));

        //Net
        if(player == 0)
            barriers.add(new Barrier(width/2 - thiccness/2,true));
        else
            barriers.add(new Barrier(width/2 + thiccness/2, false));
    }

    public void Update()
    {
        //Make sure to stop velocity before it's added in parent's update
        CheckBarriers();

        Stop(0,1); //zero out x velocity

        ProcessInput(); //Act on keyboard input

        //Update parent
        super.Update();

        //Check canJump
        if(!canJump && Position.y >= Ground)
            canJump = true;

        //Draw slime
        arc(Position.x, Position.y, thiccness, thiccness, PI, TWO_PI, PIE);

        //Draw eye base
        if(playerNo == 0)
            ellipse(Position.x + 25, Position.y - 20, 20, 20);
        else
            ellipse(Position.x - 25, Position.y - 20, 20, 20);

        //DrawVelocity();        
    }

    //draw pupil
    public void LookAt(PVector target)
    {
        PVector eyePos = new PVector(Position.x + 25, Position.y - 20);
        if(playerNo == 1) eyePos.x = Position.x - 25; //Flip side for player 2
        PVector look = target.copy().sub(eyePos).normalize().mult(3);
        eyePos.add(look);
        ellipse(eyePos.x, eyePos.y, 10, 10);
    }

    public void KeyBoardInput(int key, boolean decision)
    {
        //Get input
        if(playerNo == 0)
        {
            if(key == 'A')
                left = decision;
            if(key == 'D')
                right = decision;
            if(key == 'W')
                jump = decision;
        }
        else if(playerNo == 1)
        {
             if(key == LEFT)
                left = decision;
            if(key == RIGHT)
                right = decision;
            if(key == UP)
                jump = decision;
        }
    }

    void ProcessInput()
    {
        if(left) Move(-1);
        if(right) Move(1);
        if(jump) Jump();
    }

    void Jump()
    {
        if(canJump)
        {
            canJump = false;
            AddForce(new PVector(0,-jumpForce));
        }
    }

    void Move(int dir)
    {        
        AddForce(new PVector(dir * speed, 0));
    }

    //Barriers
    void CheckBarriers()
    {
        //X barriers
        for(int i = 0; i < barriers.size(); i++)
        {
            Barrier b = (Barrier)barriers.get(i);
            if(b.greaterThan)
            {
                if(Position.x > b.extent)
                {
                    Stop(0,1);
                    Position.x = b.extent;
                }
            }
            else
            {
                if(Position.x < b.extent)
                {
                    Stop(0,1);
                    Position.x = b.extent;
                }
            }
        }

        //Y barriers
        if(Position.y >= Ground)
        {
            Stop(1,0);
            Position.y = Ground;
        }
    }

    void OnCollision(PhysicsObject other)
    {
        //Collision with ball
        if(other.tag == "Ball")
        {
            if(other.Velocity.mag() > 1)
                other.Stop(0,0);

            //other.Velocity.mult(0.8);
            PVector force = other.GetPos().sub(this.GetPos()).normalize();
            other.AddForce(new PVector(0,-force.mag())); //Add slight up
            other.AddForce(Velocity.copy().mult(0.5)); //Inherit velocity

            float hitVel = constrain(hitForce + other.Velocity.mag(), 0, 8);            

            force.mult(hitVel);
            other.AddForce(force);            
        }
    }

    void Reset()
    {
        Stop(0,0);
        Position.x = (width/2)/2 * ((playerNo + 1)) * 2;
        Position.y = Ground;
    }
}

public class Barrier extends Object {

    public float extent;
    public boolean greaterThan;

    public Barrier (float _x, boolean _greaterThan) 
    {
        extent = _x;
        greaterThan = _greaterThan;
    }

}
