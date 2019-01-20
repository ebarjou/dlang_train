module game_engine.game_state;

import game_engine.map.map;
import game_engine.actor.player;

public enum TurnPhase {Move, Battle, Retreat}

struct GameState {
    public TurnPhase currentPhase = TurnPhase.Move;
    public uint currentTurn = 0;
    public Map map;
}