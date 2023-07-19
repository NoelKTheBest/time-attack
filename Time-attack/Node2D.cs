using Godot;
using System;
using System.Collections;

public partial class Node2D : Godot.Node2D
{
    // What is the point of using the 'partial' keyword in Godot?

    // Godot.TextEdit textEdit = new Godot.TextEdit();

    Hashtable timeTable = new Hashtable();
    
    public void AddEntry()
    {
        // Add entry to hashtable

        //timeTable.Add(1, "game");
    }
}
