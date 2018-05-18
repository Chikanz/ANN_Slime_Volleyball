public class DNA 
{
    public float[] weights;

    private float fitness = 1;    

    public float MutateChance = 0.4f;

    public int noWeights;

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

    void AddFitness(int touches, float rallies, float movedelta, int playerScore, int opponentScore)
    {
        //fitness += constrain(playerScore - opponentScore, 0,99);
        //Gates          
        float myMoveMulti = movedelta > 50 ? 1 : 0;
        //float scoremulti = constrain(playerScore - opponentScore, 0,99);

        fitness += (touches * 0.1f * myMoveMulti) + (rallies * 3 * myMoveMulti) - (playerScore * 2f);// + (ral * 1) + (movedelta * 0.001f) + (playerScore * 2);

        if(fitness < 0) fitness = 0; //just in case

        //fitness += (touches * 0.7f * myMoveMulti) + (ral * 1) + (movedelta * 0.001f) + (playerScore * 2);
        
        println("touch: " +(touches * 1 * myMoveMulti) + " rallies: " + (rallies * 3 * myMoveMulti) + " drops: " + (playerScore * 1));
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

    //Score as a fitness values isn't ideal because it's relative - it's valued by how well you do against an opponent
    //You could have a nerual net that 

}