import java.util.*;


public class GeneticTrainer extends Object
{
    int populationSize = 7;
    ArrayList<DNA> population = new ArrayList<DNA>();
    ArrayList<Integer> theWheel = new ArrayList<Integer>();  

    ArrayList<DNA> NextList = new ArrayList<DNA>();
    int nextCounter = 0;

    int generation = 0;  

    //boolean Eliteism = false;

    public GeneticTrainer()
    {
        InitalizePopulation();        
    }

    //Randomly initalize population
    void InitalizePopulation()
    {
        for(int i = 0; i < populationSize; i++)
        {
          DNA d = new DNA(131);
          d.Randomize();
          population.add(d);
        }

        GenerateNextList();
    }

    //Create a new generation
    void NextGeneration()
    {
        generation++;

        //Sum fitness
        float total = 0;
        for(int i = 0; i < populationSize; i++)
        {
            total += population.get(i).GetFitness();
        }

        //Sort list
        Collections.sort(population, new Comparator<DNA>() 
        {
            @Override
            public int compare(DNA a, DNA b) 
            {
                return a.GetFitness() < b.GetFitness() ? 1 : a.GetFitness() == b.GetFitness() ? 0 : -1;
            }
        });    

        println("fittest " +  population.get(0).fitness);
        println("unfittest " +  population.get(population.size() - 1).fitness);    

        //Kill off least fittest
        for(int i = 0; i < 2; i++)
            population.remove(population.size() - 1);

        //NormalizeFitness(total);
        InitalizeWheel();

        ArrayList<DNA> newPop = new ArrayList<DNA>();

        for(int i = 0; i < populationSize; i++)
        {
            int p1 = 0;
            int p2 = 0;

            p1 = SpinTheWheel();
            p2 = SpinTheWheel();
            
            DNA kiddo = SexyTime(p1,p2);
            kiddo.Mutate();
            newPop.add(kiddo);
        }        

        //Make new generation
        population.clear();
        for(int i = 0; i < newPop.size(); i++)
        {
            population.add(newPop.get(i));
        }

        //Make new next list
        GenerateNextList();
    }
    
    private void GenerateNextList()
    {
        NextList.clear();
        nextCounter = 0;
        for(int i = 0; i < populationSize; i++)
        {
            for(int j = 0; j < populationSize; j++)
            {
                //Congratulations, you played yourself
                if(population.get(i) == population.get(j)) continue;

                NextList.add(population.get(i));
                NextList.add(population.get(j));
            }
        }
        println(NextList.size());
    }

    public Boolean HasNext()
    {
        return nextCounter <  NextList.size();
    }
    
    public DNA GetNext()
    {
        DNA d = NextList.get(nextCounter);
        nextCounter++;
        return d;
    }

    void NormalizeFitness(float total)
    {
        for(int i= 0; i < population.size(); i++)
        {
            DNA d = population.get(i); 
            d.NormalizeFitness(total);
        }
    }

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
        DNA d = new DNA(131);
        for(int i = 0; i < p1.weights.length; i++)
        {
            d.weights[i] = random(1) > 0.5 ? p1.weights[i] : p2.weights[i];
        }
        return d;
    }

    void Write()
    {
        String[] s = new String[populationSize];
        for(int i = 0; i < populationSize; i++)
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
}