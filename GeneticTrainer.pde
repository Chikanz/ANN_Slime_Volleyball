import java.util.*;

//Class used for training
public class GeneticTrainer extends Object
{
    int populationSize = 5;
    ArrayList<DNA> population = new ArrayList<DNA>();
    ArrayList<Integer> theWheel = new ArrayList<Integer>();  

    ArrayList<Float> TopFitness = new ArrayList<Float>();  

    ArrayList<DNA> NextList = new ArrayList<DNA>();
    int nextCounter = 0;

    int generation = 0;  

    int connectionCount;

    int randomCount = 2;

    //boolean Eliteism = false;

    public GeneticTrainer(int connections)
    {
        connectionCount = connections;
        InitalizePopulation();        
        //NextGeneration();
    }

    //Randomly initalize population
    void InitalizePopulation()
    {
        for(int i = 0; i < populationSize; i++)
        {
          DNA d = new DNA(connectionCount);
          d.Randomize();
          population.add(d);
        }

        GenerateNextList();
    }

    //Create a new generation
    void NextGeneration()
    {
        generation++;

        //Sort list
        Collections.sort(population, new Comparator<DNA>() 
        {
            @Override
            public int compare(DNA a, DNA b) 
            {
                return Math.round(b.GetFitness() - a.GetFitness());
            }
        });    

        //println("fittest " +  population.get(0).fitness);
        //println("unfittest " +  population.get(population.size() - 1).fitness);    

        //Print off fitness:
        TopFitness.add(population.get(0).fitness);
        String s = "";
        for(int i = 0 ; i < TopFitness.size(); i++)
        {
            s += Math.round(TopFitness.get(i)) + "-";
        }
        println("Graph: " + s);

        //Kill off least fittest
        for(int i = 0; i < (population.size() - populationSize); i++)
            population.remove(population.size() - 1);
        
        ArrayList<DNA> newPop = new ArrayList<DNA>();

        //Add in randoms just for good luck (commented out for later training rounds when it's not nessicary)
        //for(int i = 0; i < randomCount; i++)
        //{
        //    DNA d = new DNA(connectionCount);
        //    d.Randomize();
        //    newPop.add(d);        
        //}
        //NormalizeFitness(total);

        InitalizeWheel();        

        for(int i = 0; i < populationSize; i++)
        {
            int p1 = 0;
            int p2 = 0;

            p1 = SpinTheWheel();
            p2 = SpinTheWheel();
            
            DNA kiddo = SexyTime(p1,p2);
            //DNA d = population.get(p1);
            //DNA kiddo = new DNA(d);
            kiddo.Mutate();
            newPop.add(kiddo);
        }        

        //Add kids into population
        for(int i = 0; i < newPop.size(); i++)
        {
            population.add(newPop.get(i));
        }

        //Make new next list
        GenerateNextList();

        println("Generation size: " + population.size());
    }
    
    //Make a list of which DNA we want to train, ie round robin or a population list
    private void GenerateNextList()
    {
        NextList.clear();
        nextCounter = 0;

        //For competitive
        for(int i = 0; i < populationSize; i++)
        {
            population.get(i).ClearFitness(); //Clear fitness while we're here
            for(int j = 0; j < populationSize; j++)
            {
                //Congratulations, you played yourself
                if(population.get(i) == population.get(j)) continue;
        
                NextList.add(population.get(i));
                NextList.add(population.get(j));
            }
        }

        //Just add population for ball training
        //Also clear fitness while we're here
        //for(int i = 0; i < population.size(); i++)
        //{
        //    DNA d = population.get(i);
        //    d.ClearFitness();
        //    NextList.add(d);
        //}        

        assert NextList.size() > 0;
    }

    //Check if we have another slime to give
    public Boolean HasNext()
    {
        return nextCounter <  NextList.size();
    }
    
    //Get the next slime from the next list
    public DNA GetNext()
    {        
        assert NextList.size() > 0;     
        DNA d = NextList.get(nextCounter);
        nextCounter++;
        return d;
        
    }

    //No longer used due to how wheel is implemented
    //void NormalizeFitness(float total)
    //{
    //    for(int i= 0; i < population.size(); i++)
    //    {
    //        DNA d = population.get(i); 
    //        d.NormalizeFitness(total);
    //    }
    //}

    //Initalize fitness based chance wheel
    void InitalizeWheel()
    {
        theWheel.clear();
        for(int i = 0; i < population.size(); i++)
        {
            DNA d = (DNA)population.get(i);
            for(int j = 0; j < d.GetFitness(); j++)
            {
                theWheel.add(i);
            } 
        }
    }

    //Get random population member based on wheel
    int SpinTheWheel()
    {
        assert theWheel.size() > 0;
        int r = (int)random(theWheel.size());
        return (int)theWheel.get(r);
    }

    DNA SexyTime(int n1, int n2)
    {   
       DNA p1 = population.get(n1);
       DNA p2 = population.get(n2);

       //Random crossover
        DNA d = new DNA(connectionCount);
        for(int i = 0; i < p1.weights.length; i++)
        {
            //d.weights[i] = random(1) > 0.5 ? p1.weights[i] : p2.weights[i];
            d.weights[i] = p1.weights[i] + p2.weights[i]/2; //Minecraft horse breeding alogrithm
        }
        return d;
    }

    //Write weights out to file
    void Write()
    {
        String[] s = new String[population.size()];
        for(int i = 0; i < population.size(); i++)
        {   
            String add = "";
            for(int j = 0; j < population.get(i).weights.length; j++)
            {
                add += population.get(i).weights[j] + ",";
            }
            s[i] = add;
        }
        saveStrings("weights.txt", s);
    }

    //Read weights from file
    void Read(int geneCount)
    {        
        population.clear();
        String[] lines = loadStrings("weights.txt");
        
        for(int i = 0; i < lines.length; i++)
        {               
            if(lines.length < 5) continue; //empty line

            DNA d = new DNA(geneCount);
            float[] vals = float(split(lines[i],','));

            //println(geneCount + " " + vals.length);
            assert geneCount == vals.length - 1; //make sure we're reading in the right DNA

            for(int j = 0; j < vals.length - 1; j++)            
            {
                d.weights[j] = vals[j];
            }

            population.add(d);
        }        

        GenerateNextList();
    }
}