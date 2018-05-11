public abstract class PhysicsObject extends Object{

    protected PVector Position = new PVector();
    public PVector Velocity = new PVector();
    protected PVector Acceleration = new PVector();

    public String tag;

    float Gravity = 0.3f;
    static final float Ground = 450;

    public float radius = -1;

    protected boolean Kinematic = false;


    public PhysicsObject () 
    {

    }

    public void Update()
    {
        //gravity effects non kinematic objects
        if(Kinematic) return;
        
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

    protected void DrawVelocity()
    {
        //Draw dis arrow
        stroke(5);
        line(Position.x,Position.y,(Position.x + Velocity.x), (Position.y + Velocity.y));
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

    protected abstract void OnCollision(PhysicsObject other);

    public PVector GetPos()
    {
        return Position.copy();
    }

}
