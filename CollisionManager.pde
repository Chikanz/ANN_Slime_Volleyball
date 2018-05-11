public class CollisionManager extends Object
{
    public ArrayList<PhysicsObject> objects = new ArrayList<PhysicsObject>();

    public CollisionManager ()
    {

    }

    void AddObject(PhysicsObject obj)
    {
        objects.add(obj);
    }

    void SendCollisionMessages()
    {
        for(int i = 0; i < objects.size(); i++)
        {
            for(int j = 0; j < objects.size(); j++)
            {
                PhysicsObject obj1 = objects.get(i);
                PhysicsObject obj2 = objects.get(j);
                PVector p1 = obj1.Position.copy();
                PVector p2 = obj2.Position.copy();

                if(obj1 == obj2) continue;

                //Collided, so send messages
                if(p1.sub(p2).mag() < obj1.radius + obj2.radius)
                {
                    obj1.OnCollision(obj2);
                    //obj2.OnCollision(obj1);
                }
            }
        }

    }

}
