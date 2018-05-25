//Simple class to draw the scene
public class Scene extends Object {

    public Scene () 
    {
        
    }

    public void DrawEnv()
    {
        //Net
        fill(255);
        rect(width/2, PhysicsObject.Ground - 50, 10, 50);

        //Ground
        fill(0,0,255);
        rect(0, PhysicsObject.Ground, width, 50);
        
    }

}
