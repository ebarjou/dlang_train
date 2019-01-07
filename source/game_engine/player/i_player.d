module game_engine.player.i_player;

import std.concurrency;

struct PlayerData {
    uint playerId;
    Tid threadId;
}

interface IPlayer {

}