module game_engine.game;

import game_engine.turn.action;
import game_engine.turn.turn_action;
import game_engine.game_receiver;
import game_engine.actor.unit;
import game_engine.actor.building;
import game_engine.game_state;
import game_engine.player.i_player;
import game_engine.ruleChecker.rule_checker;

import std.random;
import std.concurrency;

class Game {
    private GameState gameState;
    private RuleChecker ruleChecker;
    private PlayerData[uint] playerDatas;

    private this(){
        this.gameState = new GameState();
        this.ruleChecker = new RuleChecker();
    }

    public static loop(){
        Game game = new Game();
        GameReceiver.loop(game);
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
        return ruleChecker.isActionValid(action, getGameState());
    }

    bool submitTurnAction(immutable TurnAction turnAction){
        return true;
    }

    immutable(GameState) getGameState(){
        return new immutable GameState(this.gameState);
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