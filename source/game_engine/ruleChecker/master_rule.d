module game_engine.ruleChecker.master_rule;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.rules.sub_rules.i_sub_rule;
import game_engine.ruleChecker.rules.i_apply_rule;
import game_engine.ruleChecker.rules.sub_rules.coord_in_board;

class Rule(T:IApplyRule, R...) {
    private static ISubRule[] subRules;
    private static IApplyRule applyRule;

    public static bool verify(immutable(Action) action, immutable(GameState) gameState){
        if(subRules.length == 0){
            instanciate_rules();
        }
        foreach(subRule; subRules){
            if(!subRule.verify(action, gameState)){
                return false;
            }
        }
        return true;
    }

    private static instanciate_rules(){
        foreach(rule; R){
            this.subRules ~= mixin("new " ~ rule ~ "()");
        }
        applyRule = new T();
    }

    public static void apply(immutable(Action) action, GameState gameState){
        applyRule.apply(action, gameState);
    }
}
