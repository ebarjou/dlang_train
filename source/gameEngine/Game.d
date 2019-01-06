module gameEngine.Game;

import gameEngine.map.Map;
import gameEngine.player.IPlayer;
import gameEngine.turn.Action;
import gameEngine.turn.TurnAction;
import gameEngine.GameReceiver;
import gameEngine.actor.Unit;
import gameEngine.actor.Building;
import gameEngine.GameState;

import std.stdio;
import std.random;
import std.concurrency;

class Game {
    private GameReceiver receiver;
    private GameState gameState;
    private PlayerData[uint] playerDatas;

    private this(){
        
    }

    public static loop(){
        Game game = new Game();
        receiver.loop(game);
    }

    /**
    * Add a player to the game
    * Params:
    *       x = x
    * Returns:
    *       id of the added player
    */
    uint addPlayer(Tid playerTid){
        uint newId = uniform(uint.min, uint.max);
        playerDatas[newId] = PlayerData(newId, playerTid);
        return newId;
    }

    bool isPlayerPresent(uint playerId){
        return ((playerId in playerDatas) !is null);
    }

    void removePlayer(uint playerId){
        playerDatas.remove(playerId);
    }

    bool isActionValid(immutable Action action){
        return true;
    }

    void submitTurnAction(immutable TurnAction turnAction){
        
    }

    PlayerData getPlayerData(uint playerId){
        return playerDatas[playerId];
    }

    /**
    * Apply an action on the GameState
    */
    void submitAction(Action action){

    }

    void moveUnit(uint sx, uint sy, uint tx, uint ty){

    }

    void queueUnit(uint x, uint y, Unit.Type type){

    }

    void queueBuilding(uint x, uint y, Building.Type type){
        
    }
}