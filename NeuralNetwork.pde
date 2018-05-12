import java.util.*;

public class NeuralNetwork extends Object
{
    int numIn;
    int numHid;
    int numOut;

    private ArrayList<InputNeuron> Inputs = new ArrayList<InputNeuron>();
    private ArrayList<Neuron> Hidden = new ArrayList<Neuron>();
    private ArrayList<Neuron> Outputs = new ArrayList<Neuron>();

    public NeuralNetwork (int input, int hidden, int output)
    {
        numIn = input;
        numHid = hidden;
        numOut = output;

        //Populate neurons
        for (int i = 0; i < numIn; i++) 
        {
            Inputs.add(new InputNeuron());
        }

        for (int i = 0; i < numHid; i++) 
        {
            Hidden.add(new Neuron());
        }

        for (int i = 0; i < numOut; i++) 
        {
            Hidden.add(new Neuron());
        }

        //Add in biases (use extreme values to optimize sigmoid)
        Inputs.add(new InputNeuron(10));
        Hidden.add(new InputNeuron(10));

        //Connect Input --> Hidden, don't connect bias
        for (int i = 0; i < Inputs.size(); i++) 
        {
            for (int j = 0; j < Hidden.size() - 1; j++) 
            {                
                NNConnection c = new NNConnection(Inputs.get(i), Hidden.get(j));
                Inputs.get(i).AddConnection(c);
                Hidden.get(j).AddConnection(c);
            }
        }

        //Connect Hidden --> Outputs      
        for (int i = 0; i < Hidden.size(); i++) 
        {
            for (int j = 0; j < Outputs.size(); j++) 
            { 
                NNConnection c = new NNConnection(Hidden.get(i), Outputs.get(j));
                Hidden.get(i).AddConnection(c);
                Outputs.get(j).AddConnection(c);
            }
        }
    }

    public float[] FeedForward(float[] inputs)
    {
        assert inputs.length == Inputs.size(); //Sanity check

        //Punch in inputs
        for (int i = 0; i < inputs.length; i++) 
        {
            Inputs.get(i).Feed(inputs[i]);  
        }
        
        //Fire the hidden layer neurons
        for (int i = 0; i < Hidden.size() - 1; i++) 
        {
            Hidden.get(i).Fire();
        }

        //Fire the Output layer neurons and capture output
        float[] output = new float[Outputs.size()];
        for (int i = 0; i < Outputs.size(); i++) 
        {
            output[i] = Outputs.get(i).Fire();
        }
        
        return output;
    }

}
