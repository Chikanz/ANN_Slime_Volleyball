public class NNConnection extends Object 
{
    Neuron from;
    Neuron to;
    private float weight;

    public NNConnection(Neuron _from, Neuron _to) 
    {
        from = _from;
        to = _to;
        weight = random(1.0f); //initalize with a random weight
    }

    void SetWeight(float w)
    {
        weight = w;
    }

    float GetWeight() 
    {
        return weight;
    }

}
