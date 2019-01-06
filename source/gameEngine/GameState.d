module gameEngine.GameState;

class GameState {
    public enum TurnPhase {Move, Battle, Retreat}

    private TurnPhase currentPhase;
    private uint currentTurn;

    this(){
        currentTurn = 0;
        currentPhase = TurnPhase.Move;
    }
}