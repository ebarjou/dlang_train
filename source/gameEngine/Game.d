module gameEngine.Game;

import gameEngine.map.Map;
import gameEngine.player.IPlayer;
import gameEngine.turn.Action;
import gameEngine.turn.TurnAction;

import std.stdio;
import std.random;
import std.concurrency;

void gameMain(){
    write("Starting Engine... ");
    Tid mainTid = receiveOnly!Tid();
    //Load engine
    send!bool(mainTid, true);

    Tid[uint] playerTids;
    writeln("Ok !");
    string command = "";
    while(command != "exit") {
        receive(
            (immutable Action action){
                command = "received Action.";
                writeln("type : ", action.type ,", x : ", action.xs, ", y : ", action.ys);
                send!bool(playerTids[action.playerId],true);
            },
            (Tid playerThread){
                uint newPlayerId = 47;
                playerTids[newPlayerId] = playerThread;
                send!uint(playerThread, newPlayerId);
            },
            (Variant variant){
                command = "received incorrect object";
            }
        );
        writeln(command);
    }
    
    Map _map = new Map(5,10,Map.Connectivity.hexConn);
}

class Game {
    public enum TurnPhase {Move, Battle, Retreat}
    private Map _map;
    private TurnPhase currentPhase;
    private uint currentTurn;

    private this(){
        currentTurn = 0;
        currentPhase = TurnPhase.Move;
    }

    static void spawn(){

    }

    /**
    * Add a player to the game
    * Params:
    *       x = x
    * Returns:
    *       id of the added player
    */
    uint addPlayer(){
        return uniform(uint.min, uint.max);
    }

    void removePlayer(uint id){

    }

    bool isActionValid(int playerId, Action action){
        return true;
    }

    void submitTurnAction(int playerId, TurnAction turnAction){
        
    }

}