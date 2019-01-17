module game_engine.game_state;

import game_engine.map.map;

class GameState {
    public enum TurnPhase {Move, Battle, Retreat}
    private TurnPhase currentPhase;
    private uint currentTurn;
    private Map map;

    this(){
        currentTurn = 0;
        currentPhase = TurnPhase.Move;
        this.map = new Map(20, 20, Connectivity.eightConn);
    }

    this(GameState gameState) immutable {
        currentTurn = gameState.currentTurn;
        currentPhase = gameState.currentPhase;
        this.map = gameState.getMap();
    }

    immutable(Map) getMap(){
        return new immutable Map(map);
    }

    uint getMapWidth() immutable{
        return map._width;
    }

    uint getMapHeight() immutable {
        return map._height;
    }
}