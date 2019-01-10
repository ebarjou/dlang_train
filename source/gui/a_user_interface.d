module gui.a_user_interface;

import std.concurrency;
import game_engine.turn.turn_action;
import game_engine.turn.action;
import game_engine.game_receiver;
import game_engine.game_state;

import std.stdio;
import std.concurrency;
import std.regex;
import std.conv;
import std.exception;
import core.time;

abstract class AUserInterface {
    protected immutable uint playerId;
    private immutable Duration timeout;
    private Tid gameEngine;
    protected Tid async_io;
    protected TurnAction turnAction;

    protected this(Tid gameEngine){
        this.gameEngine = gameEngine;
        this.timeout = 3000.msecs;

        writeln("INTERFACE : Adding new player...");
        send!Tid(gameEngine, thisTid());
        playerId = receiveOnly!uint();

        this.turnAction = new TurnAction(playerId);
    }

    public static void start(Tid gameEngine);

    abstract protected void loop();

    abstract protected void onConnectionLost();

    protected void sendAction(immutable Action action){
        send!(immutable Action)(gameEngine, action);
        bool responded = receiveTimeout(timeout,
            (bool valid){
                if(valid){
                    writeln("INTERFACE : Action valid.");
                    turnAction.insert(action);
                } else {
                    writeln("INTERFACE : Action invalid.");
                }
            },
            (Variant variant){
                onConnectionLost();
            }
        );
        if(!responded) {
            onConnectionLost();
        }
    }

    protected void sendToken(MessageType type){
        immutable Token token = to!(immutable Token)(Token(playerId, type));
        send!(immutable Token)(gameEngine, token);
        bool responded = receiveTimeout(timeout,
            (immutable GameState gameState){
                writeln("INTERFACE : GameState received.");
            },
            (Variant variant){
                onConnectionLost();
            }
        );
        if(!responded) {
            onConnectionLost();
        }
    }

}