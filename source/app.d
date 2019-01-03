
import gameEngine.Game;
import gameEngine.turn.Action;

import std.stdio;
import std.concurrency;
import std.regex;
import std.conv;
import std.exception;
import gameEngine.actor.Unit;
import gameEngine.actor.Building;

Captures!string matchRegex(string str, string rgx, uint nb_expected){
    auto regex_match = regex(rgx);
    Captures!string output = str.matchAll(regex_match).front;
    if(output.length != nb_expected+1)
        throw new Exception("Parsing error.");
    return output;
}

void parseCommand(string cmd, Tid gameThread){
    if(cmd.length < 2)
        return;
    //Receive player & game info
    uint playerId = 0;
    //Send command
    Captures!string opt_arg = matchRegex(cmd, "([a-z]+) (.*)", 2);
    string opt = opt_arg[1];
    string arg = opt_arg[2];

    switch(opt) {
        case "move":
            Captures!string args = matchRegex(arg, "([0-9]+) ([0-9]+) ([0-9]+) ([0-9]+)", 4);
            auto action = new immutable Action(
                playerId, 
                to!uint(args[1]), 
                to!uint(args[2]), 
                to!uint(args[3]), 
                to!uint(args[4])
                );
            send!(immutable Action)(gameThread, action);
            break;
        case "qbuild":
            Captures!string args = matchRegex(arg, "([0-9]+) ([0-9]+) ([0-9]+)", 3);
            auto action = new immutable Action(
                playerId, 
                Building.Type.GENERATOR, 
                to!uint(args[2]), 
                to!uint(args[3])
                );
            send!(immutable Action)(gameThread, action);
            break;
        case "qunit":
            Captures!string args = matchRegex(arg, "([0-9]+) ([0-9]+) ([0-9]+)", 3);
            auto action = new immutable Action(
                playerId, 
                Unit.Type.INFANTERY, 
                to!uint(args[2]), 
                to!uint(args[3])
                );
            send!(immutable Action)(gameThread, action);
            break;
        case "sendturn":
            break;
        default:
            throw new Exception("Unknow command name.");
    }
    bool engineResponse = receiveOnly!bool();
    if(!engineResponse)
        throw new Exception("Command refused by the engine.");
}

void main() {
    writeln("Starting application...");
    Tid gameThread = spawn(&gameMain);
    send!Tid(gameThread, thisTid());
    string line;
    while((line = stdin.readln()) !is null){
        try {
            parseCommand(line, gameThread);
        } catch (Exception e){
            writeln(e.msg);
        }
        
    }
}