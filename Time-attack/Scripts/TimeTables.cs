using Godot;
using System;
using System.Collections;
using System.Collections.Generic;

public partial class TimeTables : Godot.Node2D
{
    Queue<int> timedQueue = new Queue<int>();

    Hashtable timeTable = new Hashtable();
    
    public void AddEntry(int time)
    {
        timedQueue.Enqueue(time);

        // timeTable.Add(time, "c");
    }

    // public void AddEntry(int time, Vector2 vector);

    // public void AddEntry(int time, string animationName);

    public void RemoveEntry(int windowBottom)
    {
        foreach (int time in timedQueue)
        {
            if (time < windowBottom)
            {
                timedQueue.Dequeue();
            }
        }
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
