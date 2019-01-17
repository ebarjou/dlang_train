module game_engine.ruleChecker.masterRules.rule_move;

import game_engine.ruleChecker.masterRules.a_master_rule;
import game_engine.turn.action;
import game_engine.game_state;

import std.stdio;

class RuleMove : IMasterRule {
    public void apply(immutable(Action) action, GameState gameState){
        writeln("Apply move");
    }
}