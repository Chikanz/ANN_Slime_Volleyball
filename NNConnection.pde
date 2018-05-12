public class NNConnection extends Object 
{
    Neuron from;
    Neuron to;
    private float weight;

    public NNConnection(Neuron _from, Neuron _to) 
    {
        from = _from;
        to = _to;
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
