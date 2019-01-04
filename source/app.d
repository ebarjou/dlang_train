
import gameEngine.Game;
import gameEngine.turn.Action;

import std.stdio;
import std.concurrency;
import gui.CLInterface;

void main() {
    writeln("Starting application...");

    //Initialize Engine
    Tid gameEngine = spawn(&gameMain);
    send!Tid(gameEngine, thisTid());
    if(!receiveOnly!bool())
        return;

    //Start CLI
    CLInterface.start(gameEngine);
}