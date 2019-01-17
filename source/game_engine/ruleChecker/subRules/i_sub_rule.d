module game_engine.ruleChecker.subRules.i_sub_rule;

import game_engine.turn.action;
import game_engine.game_state;

interface ISubRule {
    bool verify(immutable(Action) action, immutable(GameState) gameState);
}