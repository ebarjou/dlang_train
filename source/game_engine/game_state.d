module game_engine.game_state;

class GameState {
    public enum TurnPhase {Move, Battle, Retreat}

    private TurnPhase currentPhase;
    private uint currentTurn;

    this(){
        currentTurn = 0;
        currentPhase = TurnPhase.Move;
    }
}