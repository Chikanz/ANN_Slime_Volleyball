import java.util.*;

public class Neuron extends Object 
{
    ArrayList<NNConnection> connections = new ArrayList<NNConnection>();
    private float biasOutput = -50;
    protected float output;

    public Neuron() 
    {
        
    }

    public Neuron(int bias)
    {
        biasOutput = bias;
    }

    //Calculate the output of this neuron
    public float Fire()
    {
        //Skip processing if we're a bias neuron
        if(biasOutput != -50) return Sigmoid(biasOutput);

        //Sum up all connections
        float sum = 0;
        for(int i = 0; i < connections.size(); i++)
        {
            NNConnection c = connections.get(i);
            sum += c.from.GetCachedOutput() * c.GetWeight();
        }

        //Put through sigmoid
        output = Sigmoid(sum);
        return output;
    }
    
    //Get last value this neuron calculated
    public float GetCachedOutput()
    {
        return output;
    }

    //Activation function
    private float Sigmoid(float x)
    {
        //Quick optimization
        if( x < -5 ) return 0;
        else if( x > 5) return 1;
        
        return 1.0f / (1.0f + (float)Math.exp(-x));
    }

    //Add a connection to this neuron 
    void AddConnection(NNConnection c) 
    {
        connections.add(c);
    }

}
