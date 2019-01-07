module gui.i_user_interface;

import std.concurrency;

interface IUserInterface {
    public static void start(Tid gameEngine);
}