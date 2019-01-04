module gui.CLInterface;

import gui.IUserInterface;
import std.stdio;
import std.concurrency;
import std.regex;
import std.conv;
import std.exception;
import gameEngine.actor.Unit;
import gameEngine.actor.Building;
import gameEngine.turn.Action;
import gameEngine.turn.TurnAction;

class CLInterface : IUserInterface {
    private Tid gameEngine;
    private immutable uint playerId;

    private this(Tid gameEngine){
        this.gameEngine = gameEngine;
        send!Tid(gameEngine, thisTid());
        playerId = receiveOnly!uint();
    }

    public static void spawn(Tid gameEngine){
        
    }

    public static void start(Tid gameEngine){
        CLInterface cli = new CLInterface(gameEngine);
        cli.loop();
    }

    public void loop(){
        string line;

        do{
            write(" > ");
            stdout.flush();
            line = stdin.readln();
            try {
                immutable Action action = parseCommand(line);
                send!(immutable Action)(gameEngine, action);
                if(receiveOnly!bool()){
                    writeln("Ok !");
                }
            } catch (Exception e){
                writeln(e.msg);
            }
        } while(line !is null);
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
                auto action = new immutable Action(turnAction);
                return action;
            default:
                throw new Exception("Unknow command name.");
        }
        
    }
}