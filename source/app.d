import game_engine.game;
import game_engine.turn.action;

import std.stdio;
import std.concurrency;
import gui.cli_interface;
import gui.a_player_thread;
import core.thread;

void main() {
    writeln("Starting application...");

    //Initialize Engine
    Tid gameEngine = spawn(&Game.loop);

    //Start CLI
    APlayerThread playerThread = new CLInterface(gameEngine);
    playerThread.start();
}