module game_engine.ruleChecker.masterRules.a_master_rule;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.subRules.i_sub_rule;
import game_engine.ruleChecker.subRules.coord_in_board;

class Rule(T:IMasterRule, R...) {
    private static ISubRule[] subRules;
    private static IMasterRule masterRule;

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
        masterRule = new T();
    }

    public static void apply(immutable(Action) action, GameState gameState){
        masterRule.apply(action, gameState);
    }
}

interface IMasterRule {
    void apply(immutable(Action) action, GameState gameState);
}
