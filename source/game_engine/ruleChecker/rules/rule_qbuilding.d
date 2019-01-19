module game_engine.ruleChecker.rules.rule_qbuilding;

import game_engine.ruleChecker.master_rule;
import game_engine.ruleChecker.rules.i_apply_rule;
import game_engine.turn.action;
import game_engine.game_state;

import std.stdio;

alias QBuildingRule = Rule!(ApplyQBuilding,"CoordInBoard", 
                                "CoordInBoard"
                                );

class ApplyQBuilding : IApplyRule {
    public void apply(immutable(Action) action, GameState gameState){
        writeln("Apply move");
    }
}