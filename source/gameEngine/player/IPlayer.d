module gameEngine.player.IPlayer;

import std.concurrency;

struct PlayerData {
    uint playerId;
    Tid threadId;
}

interface IPlayer {

}