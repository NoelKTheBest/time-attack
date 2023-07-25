using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public partial class TimeTables : Godot.Node2D
{
    Queue<int> timedQueue = new Queue<int>();

    Hashtable vectorTimeTable = new Hashtable();
    Hashtable animTimeTable = new Hashtable();
    
    public void AddEntry(int time)
    {
        timedQueue.Enqueue(time);

        // timeTable.Add(time
    }

    public void AddEntry(int time, Vector2 vector)
	{
        vectorTimeTable.Add(time, vector);
	}

    public void AddEntry(int time, string animationName)
	{
        animTimeTable.Add(time, animationName);
	}

    public void RemoveFromQueue(int windowBottom)
    {
        foreach (int time in timedQueue)
        {
            if (time < windowBottom)
            {
                timedQueue.Dequeue();
				break;
            }
        }
    }
	
	public void RemoveEntry(int time)
	{
        // if we are removing a key value pair from one time tables, 
        //  it must be because we passed that time already and it's no longer needed

        vectorTimeTable.Remove(time);
        animTimeTable.Remove(time);
    }

    public string PrintQueue()
    {
        string s = "[";

        foreach(int time in timedQueue)
        {
            s = s + time + ", ";
        }

        s = s + "]";

        return s;
    }
}
