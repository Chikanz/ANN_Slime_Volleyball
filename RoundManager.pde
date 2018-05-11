public class RoundManager extends Object{

    private int p1Score;
    private int p2Score;
    private int MaxScore = 5;

    public RoundManager ()
    {
        
    }

    public void Score(boolean isp1)
    {
        if(isp1)
            p1Score += 1;
        else
            p2Score += 1;
    }

    public void Update()
    {
        //Score p1
        for(int i = 0; i < MaxScore; i++)
        {
            if(p1Score >= i)
            {
                ellipse(50 * (i + 1), 20, 20, 20);
            }
            else
            {
                ellipse(50 * (i + 1), 20, 20, 20);
            }
        }

        //score p2
        for(int i = 0; i < MaxScore; i++)
        {
            if(p1Score >= i)
            {
                ellipse(width - 50 * (i + 1), 20, 20, 20);
            }
            else
            {
                ellipse(width - 50 * (i + 1), 20, 20, 20);
            }
        }
    }
}
