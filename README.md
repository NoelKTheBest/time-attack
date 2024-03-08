# time-attack

This project is a demonstration of a time manipulation for a game involving combat. The only thing that it currently demonstrates is reversing time in a game. This demo may receive updates in the future for mechanics such as slowing down time, stopping time for all entities except the player, and going back to a specific point in time.

## Concepts

Most of the concepts that I originally envisioned for the project are simple enough to do in most game engines, nonetheless I will still give an explanation of how I'd include them in this project in the future.

### Reversing Time

Implementing time reversal ultimately comes down to the following things:

 - recording relevant information: sprites used, movement, facing direction
 - syncing records
 - playing back that information in reverse
 
 If you have some way to know information such as the current sprite used, the direction a character is facing in, and the current position of an entity then you can record that information. 
> **Note:** When in comes to checking the current sprite that's being used, every game engine is different so an individualized solution will need to be worked out for your project and the engine/framework you're using.
> > Additionally, you'll want to make sure that you save your timestamps in an array. This  is crucial for playback to work well.

Next you have to make sure all your records are synchronized. As a datatype to store records, a dictionary seems the most intuitive since you can use timestamps as the key. Additionally, to keep things predictable, I've found it easier to record the time stamps in physics update. 

#### Playback
Playback is a bit tougher to implement, but basically it helps to have a consistent update method to iterate through an array of timestamps (especially if the info was recorded in fixed updates). Previously, I tried to use many complicated operations to let the CPU know when I needed it to update something during playback such as counting backwards.

#### Setting up a record window

Recording every bit of information since the game started seems a bit much, so we can use a recording window to manage things. In the current demonstration, I use a window activated by starting a basic timer. Once the timer ends, playback begins.

A better option would be to use a sliding window. The only thing needed is to make sure that once a timestamp is passed up by the window bottom, it needs to be removed from the dictionary and the timestamp array.

### Slowing Down Time
Slowing Down time can be really fun, and really easy. All you really need to do is slow down the amount that you move an entity each frame or update an animation by N%.

An engine like Unity, makes this and stopping time easy by exposing the *timeScale* variable, allowing you to change the rate at which time passes in the game.
> Once again, every engine is different and does things differently.

## Conclusion
This is about all I have to say. If you'd like to contribute to this repo or fork it, feel free to do so.

MIT License of course.
