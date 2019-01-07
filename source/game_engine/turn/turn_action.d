module game_engine.turn.turn_action;

import game_engine.turn.action;

import std.container : DList;

class TurnAction{
    private DList!Action _actionList;
    private bool valid;
    public immutable uint playerId;

    this(uint playerId){
        _actionList = DList!Action();
        valid = true;
        this.playerId = playerId;
    }

    this(TurnAction turnAction) immutable {
        _actionList = turnAction.getDList();
        valid = turnAction.isValid();
        this.playerId = turnAction.playerId;
    }

    public void insert(Action action){
        _actionList.insertBack(action);
    }

    public void revert(){
        _actionList.removeBack();
    }

    public auto getDList() {
        return cast(immutable) _actionList.dup();
    }

    public Action pop(){
        Action action = _actionList.front();
        _actionList.removeFront();
        return action;
    }

    public bool isValid(){
        return valid;
    }

    unittest {
        import gameEngine.turn.Action;

        Action a1 = new Action(0, null, 1, 2);
        Action a2 = new Action(1, null, 1, 2);
        Action a3 = new Action(2, null, 1, 2);

        TurnAction turnAction = new TurnAction();
        turnAction.insert(a1);
        turnAction.insert(a2);
        turnAction.insert(a3);

        auto actions = turnAction.getArray();

    }
}