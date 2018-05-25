public class RoundManager extends Object
{
    public int p1Score;
    public int p2Score;
    private int MaxScore = 5;

    public RoundManager ()
    {
        
    }

    //Add a score
    public boolean Score(boolean isp1)
    {
        if(p1Score >= MaxScore || p2Score >= MaxScore) return true; //Return true if game over
        
        if(isp1)
            p1Score += 1;
        else
            p2Score += 1;

        return false; 
    }

    //Reset the game score
    public void Reset()
    {
        p1Score = 0;
        p2Score = 0;
    }

    //Draw score
    public void Update()
    {
        //Score p1
        for(int i = 0; i < MaxScore; i++)
        {
            if(p1Score > i)
            {
                fill(255,0,0);
                ellipse(50 * (i + 1), 20, 20, 20);
            }
            else
            {
                fill(0,0,0);
                ellipse(50 * (i + 1), 20, 20, 20);
            }
        }

        //Score p2
        for(int i = 0; i < MaxScore; i++)
        {
            if(p2Score > i)
            {
                fill(0,255,0);
                ellipse(width - 50 * (i + 1), 20, 20, 20);
            }
            else
            {
                fill(0,0,0);
                ellipse(width - 50 * (i + 1), 20, 20, 20);
            }
        }
    }
}
