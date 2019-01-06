module gameEngine.GameReceiver;

import gameEngine.map.Map;
import gameEngine.player.IPlayer;
import gameEngine.turn.Action;
import gameEngine.turn.TurnAction;
import gameEngine.Game;

import std.stdio;
import std.random;
import std.concurrency;

class GameReceiver {
    public enum Message {   TurnOver, ActionValid, ActionInvalid,
                            TurnMove, TurnBattle, TurnRetreat,
                            GetState, ExitGame }
    private Game game;

    private this(Game game){
        this.game = game;
    }

    static void loop(Game game){
        write("Starting Engine... ");
        GameReceiver receiver = new GameReceiver(game);

        Tid mainTid = receiveOnly!Tid();
        send!bool(mainTid, true);

        writeln("Ok !");

        do {
            receive(
                (immutable Action action){
                    receiver.handleAction(action);
                },
                (Tid tid){
                    receiver.handleTid(tid);
                },
                (GameReceiver.Message message){
                    receiver.handleMessage(message);
                },
                (Variant variant){
                    writeln("received incorrect object");
                }
            );
        } while(true);
    }

    void respond(T)(Tid playerTid, T message){
        send!T(playerTid, message);
    }

    void respond(T)(uint playerId, T message){
        if(game.isPlayerPresent(playerId))
            respond!T(game.getPlayerData(playerId).threadId, message);
    }

    void respondAll(T)(T message){
        /*foreach(playerTid; playerTids.byValue()) {
            respond!T(playerTid, message);
        }*/
    }

    void handleAction(immutable Action action){
        writeln("type : ", action.type ,", x : ", action.xs, ", y : ", action.ys);
        respond!bool(action.playerId, game.isActionValid(action));
    }

    void handleMessage(GameReceiver.Message message){
        writeln("Message : ", message);
        //respond!bool(action.playerId, true);
    }

    void handleTid(Tid tid){
        respond!uint(tid, game.addPlayer(tid) );
    }

    void removePlayer(uint id){

    }

}