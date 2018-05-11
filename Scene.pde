public class Scene extends Object {

    public Scene () 
    {
        
    }

    public void DrawEnv()
    {
        //Net
        rect(width/2, PhysicsObject.Ground - 50, 10, 50);

        //Ground
        rect(0, PhysicsObject.Ground, width, 50);
        
    }

}
