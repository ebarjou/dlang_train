module game_engine.ruleChecker.rule_checker;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.masterRules.a_master_rule;
import game_engine.ruleChecker.masterRules.rule_move;

import std.stdio;
import std.conv;

alias MoveRule = Rule!(RuleMove, "CoordInBoard", "CoordInBoard");

class RuleChecker {

    public bool isActionValid(immutable(Action) action, immutable(GameState) gameState){
        switch(action.type){
            case Action.Type.MOVE:
                writeln("Check action MOVE");
                return MoveRule.verify(action, gameState);
            default:
                throw new Exception("This action type is not handled by the RuleChecker : " ~ to!string(action.type));
        }
    }

    public void applyAction(immutable(Action) action, GameState gameState){
        switch(action.type){
            case Action.Type.MOVE:
                MoveRule.apply(action, gameState);
                break;
            default:
                throw new Exception("This action type is not handled by the RuleChecker : " ~ to!string(action.type));
        }
    }

    public void iterateBattle(){
        
    }
}