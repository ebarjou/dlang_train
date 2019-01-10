module game_engine.turn.turn_action;

import game_engine.turn.action;

import std.container : DList;

class TurnAction{
    private DList!(Action) _actionList;
    private uint length;
    public immutable uint playerId;

    this(uint playerId){
        _actionList = DList!(Action)();
        this.playerId = playerId;
    }

    this(TurnAction turnAction) immutable {
        this._actionList = turnAction.getDList();
        this.playerId = turnAction.playerId;
        this.length = turnAction.length;
    }

    public void insert(immutable Action action){
        //_actionList.insertBack(action);
        ++length;
    }

    public void revert(){
        //_actionList.removeBack();
        --length;
    }

    public auto getDList() {
        return cast(immutable) _actionList.dup();
    }

    public uint getLength() immutable {
        return length;
    }

    public immutable(Action) pop(){
        //immutable Action action = _actionList.front();
        //_actionList.removeFront();
        //return action;
        return null;
    }

    unittest {
        /*
        import gameEngine.turn.Action;

        Action a1 = new Action(0, null, 1, 2);
        Action a2 = new Action(1, null, 1, 2);
        Action a3 = new Action(2, null, 1, 2);

        TurnAction turnAction = new TurnAction();
        turnAction.insert(a1);
        turnAction.insert(a2);
        turnAction.insert(a3);

        auto actions = turnAction.getArray();
        */
    }
}