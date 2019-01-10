module game_engine.game_receiver;

import game_engine.turn.action;
import game_engine.turn.turn_action;
import game_engine.game;
import game_engine.game_state;

import std.stdio;
import std.concurrency;

public struct Token {
    uint playerId;
    MessageType type;
}
public enum MessageType {   TurnOver, ActionValid, ActionInvalid,
                        TurnMove, TurnBattle, TurnRetreat,
                        GetState, ExitGame, Error, Action }

class GameReceiver {
    
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
            receive(
                (immutable Action action){
                    instance.handleAction(action);
                },
                (Tid tid){
                    instance.handleTid(tid);
                },
                (immutable Token token){
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
        else
            writeln("SERVER : Unknown player ", playerId);
    }

    private void respondAll(T)(T message){
        /*foreach(playerTid; playerTids.byValue()) {
            respond!T(playerTid, message);
        }*/
    }

    package void handleAction(immutable Action action){
        writeln("SERVER : received ", action.type ,", x : ", action.xs, ", y : ", action.ys);
        if(action.type == Action.Type.SEND){
            handleTurnAction(action.actionTurn);
        } else {
            respond!bool(action.playerId, game.isActionValid(action));
        }
    }

    package void handleTurnAction(immutable TurnAction turnAction){
        writeln("SERVER : received TurnAction composed of ", turnAction.getLength() , " actions.");
        respond!bool(turnAction.playerId, true);
    }

    package void handleMessage(Token token){
        writeln("SERVER : received ", token.type);
        switch (token.type) {
            case(MessageType.ExitGame):
                break;
            case(MessageType.GetState):
                immutable GameState gameState = game.getGameState();
                respond!(immutable GameState)(token.playerId, gameState);
                break;
            default:
                break;
        }
    }

    package void handleTid(Tid tid){
        writeln("SERVER : New player connected");
        respond!uint(tid, game.addPlayer(tid) );
    }

}