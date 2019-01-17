module game_engine.ruleChecker.subRules.coord_in_board;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.subRules.i_sub_rule;

class CoordInBoard : ISubRule {
    bool verify(immutable(Action) action, immutable(GameState) gameState) {
        return action.xs >= 0 && action.xs < gameState.getMapWidth()
            && action.ys >= 0 && action.ys < gameState.getMapHeight()
            && action.xt >= 0 && action.xt < gameState.getMapWidth()
            && action.yt >= 0 && action.yt < gameState.getMapHeight();
    }
}