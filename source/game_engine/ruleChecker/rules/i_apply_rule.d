module game_engine.ruleChecker.rules.i_apply_rule;

import game_engine.turn.action;
import game_engine.game_state;

interface IApplyRule {
    void apply(immutable(Action) action, GameState gameState);
}
