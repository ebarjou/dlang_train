import game_engine.game;
import game_engine.turn.action;

import std.stdio;
import std.concurrency;
import gui.cli_interface;

void main() {
    writeln("Starting application...");

    //Initialize Engine
    Tid gameEngine = spawn(&Game.loop);
    send!Tid(gameEngine, thisTid());
    if(!receiveOnly!bool())
        return;

    //Start CLI
    CLInterface.start(gameEngine);
}