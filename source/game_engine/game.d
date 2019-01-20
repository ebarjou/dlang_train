module game_engine.game;

import game_engine.turn.action;
import game_engine.turn.turn_action;
import game_engine.game_receiver;
import game_engine.actor.unit;
import game_engine.actor.building;
import game_engine.game_state;
import game_engine.actor.player;
import game_engine.ruleChecker.rule_checker;
import game_engine.map.map;

import std.random;
import std.concurrency;

class Game {
    private GameState gameState;
    private RuleChecker ruleChecker;
    private Tid[uint] playerTid;

    private this(){
        gameState.map.connectivity = Connectivity.hexConn;
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
    uint addPlayer(Tid tid){
        uint newId = uniform(uint.min, uint.max);
        playerTid[newId] = tid;
        return newId;
    }

    bool isPlayerPresent(uint playerId){
        return ((playerId in playerTid) !is null);
    }

    void removePlayer(uint playerId){
        playerTid.remove(playerId);
    }

    bool isActionValid(immutable Action action){
        return ruleChecker.isActionValid(action, getGameState());
    }

    bool submitTurnAction(immutable TurnAction turnAction){
        return true;
    }

    GameState getGameState(){
        return this.gameState;
    }

    Tid getPlayerTid(uint playerId){
        return playerTid[playerId];
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