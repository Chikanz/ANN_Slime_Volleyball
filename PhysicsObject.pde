public class PhysicsObject extends Object{

    protected PVector Position = new PVector();
    protected PVector Velocity = new PVector();
    protected PVector Acceleration = new PVector();

    static final float Gravity = 0.3f;
    static final float Ground = 450;


    public PhysicsObject () 
    {

    }

    public void Update()
    {
        //Everything is affected by gravity
        if(Position.y < Ground)
            AddForce(new PVector(0,Gravity));
        else
            Position.y = Ground;


        //Add acceleration to velocity
        Velocity.add(Acceleration);
        Acceleration = new PVector(0,0);

        //Add velocity to position
        Position.add(Velocity);
    }

    public void AddForce(PVector force)
    {
        Acceleration.add(force);        
    }

    public void Stop(int x, int y)
    {
        Acceleration.x *= x;
        Acceleration.y *= y;

        Velocity.x *= x;
        Velocity.y *= y;
    }

}
