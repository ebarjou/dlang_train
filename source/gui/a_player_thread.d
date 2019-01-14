module gui.a_player_thread;

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
import core.thread;

abstract class APlayerThread : Thread {
    private immutable Duration timeout;
    private Tid gameEngine;

    protected uint playerId;
    protected TurnAction turnAction;

    protected this(Tid gameEngine){
        super(&run);
        writeln("INTERFACE : creating...");
        this.gameEngine = gameEngine;
        this.timeout = 3000.msecs;
    }

    private void run(){
        thread_init();
        init();
        loop();
    }

    abstract protected void init();
    abstract protected void loop();
    abstract protected void onConnectionLost();

    private void thread_init(){
        writeln("INTERFACE : Adding new player...");
        send!Tid(gameEngine, thisTid());
        playerId = receiveOnly!uint();
        writeln("INTERFACE : Received player ID.");

        this.turnAction = new TurnAction(playerId);
    }

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