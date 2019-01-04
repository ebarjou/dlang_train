module gui.IUserInterface;

import std.concurrency;

interface IUserInterface {
    public static void spawn(Tid gameEngine);
    public static void start(Tid gameEngine);
}