import game_engine.game;
import game_engine.turn.action;

import std.stdio;
import std.concurrency;
import gui.cli_interface;
import gui.a_player_thread;
import core.thread;

struct A {
    uint x;
    uint y;
    uint z;
}

struct B {
    char c;
    short s;
    double d;
}

struct C {
    B[10][10] array; 
}

struct AB {
    A a;
    B b;
}

struct AC {
    A a;
    C c;
}

union AC_byte {
    AC data;
    byte[AC.sizeof] array;
}

void main() {
    writeln("Starting application...");

    A a = A(1,2,3);
    B b = B('f', 4, 5.0);
    C c;
    c.array[1][1].c = 'n';

    AB ab = AB(a, b);

    a.z = 34;

    writeln(ab.a.z);

    AC ac = AC(a, c);

    ac.c.array[1][1] = B('g');

    writeln(ac.c.array[1][1].c);
    writeln(c.array[1][1].c);

    byte[AC.sizeof] byteArray = (cast(AC_byte)ac).array;
    
    AC_byte acb = cast(AC_byte)byteArray;

    AC ac_casted = acb.data;

    writeln(ac_casted.c.array[1][1].c);

    //Initialize Engine
    Tid gameEngine = spawn(&Game.loop);

    //Start CLI
    APlayerThread playerThread = new CLInterface(gameEngine);
    playerThread.start();
}