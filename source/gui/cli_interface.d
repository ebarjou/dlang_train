module gui.cli_interface;

import gui.i_user_interface;
import game_engine.actor.unit;
import game_engine.actor.building;
import game_engine.turn.action;
import game_engine.turn.turn_action;

import std.stdio;
import std.concurrency;
import std.regex;
import std.conv;
import std.exception;

class CLInterface : IUserInterface {
    private Tid gameEngine;
    private Tid async_io;
    private immutable uint playerId;

    private this(Tid gameEngine){
        this.gameEngine = gameEngine;

        writeln("INTERFACE : Adding new player...");
        send!Tid(gameEngine, thisTid());
        playerId = receiveOnly!uint();
        
        this.async_io = spawn(&CLInterface.async_readln);
        send!Tid(async_io, thisTid());
    }

    public static void start(Tid gameEngine){
        writeln("INTERFACE : starting...");
        CLInterface cli = new CLInterface(gameEngine);
        cli.receiveLoop();
    }

    public static void async_readln(){
        Tid gui = receiveOnly!Tid();
        do{
            write(" > ");
            stdout.flush();
            immutable string line = stdin.readln();
            send!(immutable string)(gui, line);
            receiveOnly!bool();
        } while(true);
    }

    public void receiveLoop(){
        writeln("INTERFACE : Waiting for input...");
        do{
            receive(
                (string input){
                    try {
                        immutable Action action = parseCommand(input);
                        send!(immutable Action)(gameEngine, action);
                        if(receiveOnly!bool()){
                            writeln("INTERFACE : Server response received.");
                        }
                        send!bool(async_io, true);
                    } catch (Exception e){
                        writeln(e.msg);
                    }
                }
            );
        } while(true);  
    }

    private Captures!string matchRegex(string str, string rgx, uint nb_expected){
        auto regex_match = regex(rgx);
        Captures!string output = str.matchAll(regex_match).front;
        if(nb_expected > 0 && output.length != nb_expected+1)
            throw new Exception("Parsing error.");
        return output;
    }

    private immutable(Action) parseCommand(string cmd){
        if(cmd.length < 2)
            throw new Exception("Command too short.");
        //Send command
        Captures!string opt_arg = matchRegex(cmd, "([a-z]+)([ ]*)(.*)", 0);
        string opt = opt_arg[1];
        string arg = opt_arg[3];

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
                return action;
            case "qbuild":
                Captures!string args = matchRegex(arg, "([0-9]+) ([0-9]+) ([0-9]+)", 3);
                auto action = new immutable Action(
                    playerId, 
                    Building.Type.GENERATOR, 
                    to!uint(args[2]), 
                    to!uint(args[3])
                    );
                return action;
            case "qunit":
                Captures!string args = matchRegex(arg, "([0-9]+) ([0-9]+) ([0-9]+)", 3);
                auto action = new immutable Action(
                    playerId, 
                    Unit.Type.INFANTERY, 
                    to!uint(args[2]), 
                    to!uint(args[3])
                    );
                return action;
            case "sendturn":
                TurnAction turnAction = new TurnAction(playerId);
                auto action = new immutable Action(playerId, turnAction);
                return action;
            default:
                throw new Exception("Unknow command name.");
        }
        
    }
}