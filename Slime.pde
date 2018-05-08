import java.util.*;

public class Slime extends PhysicsObject
{
    private float speed = 10;
    private int playerNo;
    private float thiccness = 100;

    private int moveForce;
    private int jumpForce = 7;
    private Boolean canJump = true;

    ArrayList barriers = new ArrayList();

    public Slime (int player) 
    {
        playerNo = player;
        Position.y = Ground;
        Position.x = (width/2)/2 * (playerNo + 1);

        //add in barriers
        barriers.add(new Barrier(thiccness/2), true);
        barriers.add(new Barrier(width - thiccness/2), false);

        //Net
        if(player == 0)
            barriers.add(new Barrier(width/2 - thiccness/2),false);
        else
            barriers.add(new Barrier(width/2 + thiccness/2),true);
    }

    public void Update()
    {
        super.Update();

        //Check canJump
        if(!canJump && Position.y >= Ground)
            canJump = true;

        //Draw
        //ellipse(Position.x, Position.y, size, size);
        
        arc(Position.x, Position.y, thiccness, thiccness, PI, TWO_PI, PIE);

        //Draw dis arrow
        stroke(5);
        line(Position.x,Position.y,(Position.x + Velocity.x), (Position.y + Velocity.y));
        
    }

    public void KeyBoardInput(int key)
    {
        //Get input
        //println(key);
        if(key == 'a')
            s.Move(-1);
        if(key == 'd')
            s.Move(1);
        if(key == 'w')
            Jump();
    }

    public void Jump()
    {
        if(canJump)
        {
            canJump = false;
            AddForce(new PVector(0,-jumpForce));
        }
    }

    public void Move(int dir)
    {
        //Moving from still
        if(dir != 0 && moveForce == 0)
        {
            moveForce = dir;
            AddForce(new PVector(dir * speed, 0));
            //println("move");
        }
        else if(moveForce != 0 && dir == 0) //Key released
        {
            moveForce = dir;
            Stop(0,1);
            //println("stop");
        }
        else if(dir != moveForce) //Moving while moving
        {
            moveForce = dir;
            Stop(0,1);
            //println("stop");
            AddForce(new PVector(dir * speed, 0));
            //println("move");
        }

        //Barriers

        for(int i = 0; i < barriers.length; i++)
        {
            Barrier b = barriers.get(i);
            if(b.greaterThan)
            {
                
            }
            else
            {

            }
        }

        if(Position.x < thiccness/2)
        {
            Stop(0,1);
            Position.x = thiccness/2;
        }
    }

    
    public void Move2(int dir)
    {
        Position.x += dir * speed;
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
