module game_engine.ruleChecker.rule_checker;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.rules.rule_move;
import game_engine.ruleChecker.rules.rule_qunit;
import game_engine.ruleChecker.rules.rule_qbuilding;

import std.stdio;
import std.conv;

class RuleChecker {

    public bool isActionValid(immutable(Action) action, GameState gameState){
        switch(action.type){
            case Action.Type.MOVE:
                writeln("Check action MOVE");
                return MoveRule.verify(action, gameState);
            case Action.Type.QUNIT:
                return QUnitRule.verify(action, gameState);
            case Action.Type.QBUILD:
                return QBuildingRule.verify(action, gameState);
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