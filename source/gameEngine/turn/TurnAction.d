module gameEngine.turn.TurnAction;

import gameEngine.turn.Action;

import std.container : DList;

class TurnAction{
    private DList!Action _actionList;
    private bool isValid;

    this(){
        _actionList = DList!Action();
        isValid = true;
    }

    public void insert(Action action){
        _actionList.insertBack(action);
    }

    public void revert(){
        _actionList.removeBack();
    }

    public auto getArray(){
        return _actionList[];
    }

    public Action pop(){
        Action action = _actionList.front();
        _actionList.removeFront();
        return action;
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