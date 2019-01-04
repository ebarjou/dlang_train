module gameEngine.turn.Action;

import gameEngine.actor.Building;
import gameEngine.actor.Unit;
import gameEngine.turn.TurnAction;
import std.conv;

class Action {
    public enum Type {MOVE, QBUILD, QUNIT, SEND}

    public immutable Type type;
    public immutable uint playerId;
    public immutable Unit.Type unitType;
    public immutable Building.Type buildingType;
    public immutable uint xs, ys;
    public immutable uint xt, yt;
    public immutable TurnAction actionTurn;

    /**
    * Create a send action (validate the turn)
    */
    this(TurnAction actionTurn) immutable {
        this.type = Type.SEND;
        this.playerId = playerId;
        this.actionTurn = new immutable TurnAction(actionTurn);

        //Unused member for this action type
        this.xs = 0;
        this.ys = 0;
        this.xt = 0;
        this.yt = 0;
        unitType = Unit.Type.INFANTERY;
        buildingType = Building.Type.GENERATOR;
    }
    /**
    * Create a move action
    */
    this(uint playerId, uint xs, uint ys, uint xt, uint yt) immutable {
        this.type = Type.MOVE;
        this.playerId = playerId;
        this.xs = xs;
        this.ys = ys;
        this.xt = xt;
        this.yt = yt;

        //Unused member for this action type
        unitType = Unit.Type.INFANTERY;
        buildingType = Building.Type.GENERATOR;
        actionTurn = null;
    }

    /**
    * Create a qbuild action
    */
    this(uint playerId, Building.Type buildingType, uint x, uint y) immutable {
        this.type = Type.QBUILD;
        this.playerId = playerId;
        this.buildingType = buildingType;
        this.xs = x;
        this.ys = y;

        //Unused member for this action type
        this.xt = 0;
        this.yt = 0;
        unitType = Unit.Type.INFANTERY;
        actionTurn = null;
    }

    /**
    * Create a qunit action
    */
    this(uint playerId, Unit.Type unitType, uint x, uint y) immutable {
        this.type = Type.QUNIT;
        this.playerId = playerId;
        this.unitType = unitType;
        this.xs = x;
        this.ys = y;

        //Unused member for this action type
        this.xt = 0;
        this.yt = 0;
        buildingType = Building.Type.GENERATOR;
        actionTurn = null;
    }
}