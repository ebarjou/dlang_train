module game_engine.ruleChecker.rules.sub_rules.coord_in_board;

import game_engine.turn.action;
import game_engine.game_state;
import game_engine.ruleChecker.rules.sub_rules.i_sub_rule;

class CoordInBoard : ISubRule {
    bool verify(immutable(Action) action, GameState gameState) {
        return action.xs >= 0 && action.xs < gameState.map.boardData.width
            && action.ys >= 0 && action.ys < gameState.map.boardData.height
            && action.xt >= 0 && action.xt < gameState.map.boardData.width
            && action.yt >= 0 && action.yt < gameState.map.boardData.height;
    }
}