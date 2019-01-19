module game_engine.ruleChecker.rules.rule_move;

import game_engine.ruleChecker.master_rule;
import game_engine.ruleChecker.rules.i_apply_rule;
import game_engine.turn.action;
import game_engine.game_state;

import std.stdio;

alias MoveRule = Rule!(ApplyMove,"CoordInBoard", 
                                "CoordInBoard"
                                );

class ApplyMove : IApplyRule {
    public void apply(immutable(Action) action, GameState gameState){
        writeln("Apply move");
    }
}