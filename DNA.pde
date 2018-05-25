public class DNA 
{
    public float[] weights;

    private float fitness = 1;    

    public float MutateChance = 0.2f;

    public int noWeights; //Number of weights in the network

    public DNA (int noWeights) 
    {
        this.noWeights = noWeights;
        weights = new float[noWeights];
    }

    //Copy constructor
    public DNA (DNA d) 
    {
        this(d.noWeights);
        for(int i = 0; i < d.weights.length; i++)
        {
            weights[i] = d.weights[i];
        }
    }

    void ClearFitness()
    {
        fitness = 1;
    }

    //Fitness function, with past functions commented 
    void AddFitness(int touches, float rallies, float movedelta, int playerScore, int opponentScore)
    {
        //Gates (won't count fitness unless condition is met)
        float myMoveMulti = movedelta > 50 ? 1 : 0;

        //float scoremulti = constrain(playerScore - opponentScore, 0,99);

        //fitness += (touches * 0.7f * myMoveMulti) + (ral * 1) + (movedelta * 0.001f) + (playerScore * 2);
        //fitness += (touches * 0.1f * myMoveMulti) + (rallies * 3 * myMoveMulti) + (10 - playerScore);
        fitness += (5 - playerScore);

        if(fitness < 0) fitness = 0; //just in case

        //Debug
        //println("touch: " +(touches * 1 * myMoveMulti) + " rallies: " + (rallies * 3 * myMoveMulti) + " drops: " + (playerScore * 1));
        //println("drops: " + (playerScore));
    }

    void NormalizeFitness(float total)
    {
        fitness /= total;
    }

    float GetFitness()
    {
        return fitness;
    }

    void Randomize()
    {
        for(int i = 0; i < weights.length; i++)
        {
            weights[i] = random(-1.0, 1.0);            
        }
    }

    void Mutate()
    {
        for(int i = 0; i < weights.length; i++)
        {   
            //Add noise to weight
            if(random(1) < MutateChance)
            {                
                weights[i] += random(-0.1, 0.1);
                weights[i] = constrain(weights[i], -1.0f, 1.0f);
            }

            //just fuck my shit up fam
            if(random(1) < MutateChance/4)
            {                
                weights[i] = random(-1.0, 1.0);
            }
        }
    }    
}