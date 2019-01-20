module game_engine.game_receiver;

import game_engine.turn.action;
import game_engine.turn.turn_action;
import game_engine.game;
import game_engine.game_state;

import std.stdio;
import std.concurrency;
import std.conv;

public struct Token {
    uint playerId;
    MessageType type;
}

public enum MessageType {   TurnOver, ActionValid, ActionInvalid,
                        TurnMove, TurnBattle, TurnRetreat,
                        GetState, ExitGame, Error, Action }

class GameReceiver {
    private static GameReceiver instance;
    private Game game;

    private this(Game game){
        this.game = game;
    }

    public static void loop(Game game){
        assert(instance is null, "A GameReceiver instance already exist");
        writeln("SERVER : Starting Engine... ");
        instance = new GameReceiver(game);

        writeln("SERVER : Started.");

        do {
            receive(
                (immutable Action action){
                    instance.handleAction(action);
                },
                (immutable Token token){
                    instance.handleMessage(token);
                },
                (Tid tid){
                    instance.handleTid(tid);
                },
                (Variant variant){
                    writeln("SERVER : Ignoring message : " ~ to!string(variant));
                }
            );
        } while(true);
    }

    private void respond(T)(Tid playerTid, T message){
        send!T(playerTid, message);
    }

    private void respond(T)(uint playerId, T message){
        if(game.isPlayerPresent(playerId))
            respond!T(game.getPlayerTid(playerId), message);
        else
            writeln("SERVER : Unknown player ", playerId);
    }

    private void respondAll(T)(T message){
        /*foreach(playerTid; playerTids.byValue()) {
            respond!T(playerTid, message);
        }*/
    }

    private void handleAction(immutable Action action){
        writeln("SERVER : received ", action.type ,", x : ", action.xs, ", y : ", action.ys);
        if(action.type == Action.Type.SEND){
            handleTurnAction(action.actionTurn);
        } else {
            respond!bool(action.playerId, game.isActionValid(action));
        }
    }

    private void handleTurnAction(immutable TurnAction turnAction){
        writeln("SERVER : received TurnAction composed of ", turnAction.getLength() , " actions.");
        respond!bool(turnAction.playerId, game.submitTurnAction(turnAction));
    }

    private void handleMessage(Token token){
        writeln("SERVER : received ", token.type);
        switch (token.type) {
            case(MessageType.ExitGame):
                break;
            case(MessageType.GetState):
                respond!(GameState)(token.playerId, game.getGameState());
                break;
            default:
                break;
        }
    }

    private void handleTid(Tid tid){
        writeln("SERVER : New player connected");
        respond!uint(tid, game.addPlayer(tid) );
    }

}