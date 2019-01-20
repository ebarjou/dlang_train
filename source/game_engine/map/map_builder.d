module game_engine.map.map_builder;

import game_engine.map.map;

import std.file;
import std.json;
import std.conv;

class MapBuilder {
    private this(){}

    public static Map CreateFromJSON(string path){
        string content = readText(path);
        JSONValue json = parseJSON(content);

        //to!ushort(json["weight"].integer)
        //to!ushort(json["height"].integer)
        
        Map map = Map(Connectivity.hexConn);

        JSONValue layers = json["layers"];
        foreach(ulong index, JSONValue layer; layers){
            string name = layer["name"].str;
            JSONValue dataArray = layer["data"];
            foreach(ulong subIndex, JSONValue data; dataArray){
                uint x = to!uint(subIndex)%map.boardData.width;
                uint y = to!uint(subIndex)/map.boardData.width;
                map.boardData.set(name, x, y, to!uint(data.integer));
            }
        }

        return map;
    }

}