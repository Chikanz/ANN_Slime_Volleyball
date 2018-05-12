public class InputNeuron extends Neuron
{    

    public InputNeuron () 
    {
        super();    
    }

    public InputNeuron (int bias) 
    {
        super(bias);    
    }

    //Send this neuron input
    public void Feed(float input)
    {    
        output = input;
    }

    //Don't call super and just pass through input
    public float Fire()
    {
        return output;
    }    
}
