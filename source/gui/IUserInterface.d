module gui.IUserInterface;

import std.concurrency;

interface IUserInterface {
    public static void start(Tid gameEngine);
}