module game_engine.game_receiver;

import game_engine.turn.Action;
import game_engine.Game;

import std.stdio;
import std.concurrency;
import core.time;

class GameReceiver {
    public struct Token {
        GameReceiver.MessageType type;
        Tid playerId;
    }
    public enum MessageType {   TurnOver, ActionValid, ActionInvalid,
                            TurnMove, TurnBattle, TurnRetreat,
                            GetState, ExitGame, Error }
    private Game game;
    package static GameReceiver instance;

    private this(Game game){
        this.game = game;
    }

    static void loop(Game game){
        writeln("SERVER : Starting Engine... ");
        instance = new GameReceiver(game);

        writeln("SERVER : Waiting main thread... ");
        Tid mainTid = receiveOnly!Tid();
        send!bool(mainTid, true);

        writeln("SERVER : Started.");

        do {
            receiveTimeout(1000.msecs,
                (immutable Action action){
                    instance.handleAction(action);
                },
                (Tid tid){
                    instance.handleTid(tid);
                },
                (Token token){
                    instance.handleMessage(token);
                },
                (Variant variant){
                    writeln("SERVER : Incorrect message received.");
                }
            );
        } while(true);
    }

    private void respond(T)(Tid playerTid, T message){
        send!T(playerTid, message);
    }

    private void respond(T)(uint playerId, T message){
        if(game.isPlayerPresent(playerId))
            respond!T(game.getPlayerData(playerId).threadId, message);
    }

    private void respondAll(T)(T message){
        /*foreach(playerTid; playerTids.byValue()) {
            respond!T(playerTid, message);
        }*/
    }

    package void handleAction(immutable Action action){
        writeln("SERVER : received ", action.type ,", x : ", action.xs, ", y : ", action.ys);
        respond!bool(action.playerId, game.isActionValid(action));
    }

    package void handleMessage(Token token){
        writeln("SERVER : received ", token.type);
        //respond!bool(action.playerId, true);
    }

    package void handleTid(Tid tid){
        writeln("SERVER : New player connected");
        respond!uint(tid, game.addPlayer(tid) );
    }

}