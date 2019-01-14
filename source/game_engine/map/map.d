module game_engine.map.map;

import game_engine.map.board_data;

import std.container;
import std.file;
import std.json;
import std.conv : to;

immutable static enum Connectivity {fourConn=0, eightConn, hexConn}

struct Data {
    bool blocked;
    uint owner;
    bool buildingSite;
    uint buildingType;
    bool ressource;
    uint ressourceType;
}

class Map {
    private immutable static byte[][][] moves = [
        [[1, 0], [-1, 0], [0, 1], [0, -1]],
        [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [1, 1], [-1, 1], [-1, -1]],
        [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 0], [0, -1]]
    ];
    private immutable ushort _width, _height;
    private immutable Connectivity _connectivity;
    private BoardData!Data _boardData;

    this(ushort width, ushort height, Connectivity connectivity){
        _height = height;
        _width = width;
        _connectivity = connectivity;
        _boardData = new BoardData!(Data)(_width, _height);
    }

    public void loadFromFile(string path){
        string content = readText(path);
        JSONValue json = parseJSON(content);
        JSONValue layers = json["layers"];
        foreach(ulong index, JSONValue layer; layers){
            string name = layer["name"].str;
            JSONValue dataArray = layer["data"];
            foreach(ulong subIndex, JSONValue data; dataArray){
                uint x = to!uint(subIndex)%_width;
                uint y = to!uint(subIndex)/_width;
                setData(name, x, y, to!uint(data.integer));
            }
        }
    }

    override public string toString(){
        string output = "";
        for(int j = 0; j < _height; ++j){
            for(int i = 0; i < _width; ++i){
                output ~= to!string(to!uint(_boardData.get!"blocked"(i, j)));
            }
            output ~= "\n";
        }
        return output;
    }

    public auto getData(string member)(uint x, uint y){
        return _boardData.get!member(x, y);
    }

    public auto setData(string member, T)(uint x, uint y, T value){
        return _boardData.set!member(x, y, value);
    }

    private void setData(string name, uint x, uint y, uint value){
        switch(name){
            case "bBlocked":
                _boardData.set!"blocked"(x, y, to!bool(value));
                break;
            case "iOwner":
                _boardData.set!"owner"(x, y, value);
                break;
            case "bBuildingSite":
                _boardData.set!"buildingSite"(x, y, to!bool(value));
                break;
            case "iBuildingType":
                _boardData.set!"buildingType"(x, y, value);
                break;
            case "iRessourceType":
                _boardData.set!"ressourceType"(x, y, value);
                break;
            default:
                throw new Exception("Incorrect BoardData member : " ~ name);
        }
    }

    public bool isBlocked(uint x, uint y){
        return _boardData.get!"blocked"(x, y);
    }

    public bool isInBoundaries(uint x, uint y){
        return !(x >= _width || x < 0 || y >= _height || y < 0);
    }

    /*
    public uint getPath(uint xs, uint ys, uint xt, uint yt, uint max_mov = 100){
        auto nodeList = new BinaryHeap!(Node[], "a.d > b.d")(null, _width*_height/2);
        bool[][] visited = new bool[][](_width, _height);
        if(xs == xt && ys == yt)
            return 0;
        nodeList.insert(Node(xs, ys, 0, xt, yt));
        visited[xs][ys] = true;
        Node head = nodeList.front();
        nodeList.popFront();
        do {
            foreach(immutable byte[] m; moves[_connectivity]){
                uint nx = head.x+m[0], ny = head.y+m[1];
                if(nx == xt && ny == yt){
                    return head.c + 1;
                }
                if(isInBoundaries(nx, ny) && head.c < max_mov){
                    if( !isBlocked(nx, ny) && !visited[nx][ny]){
                        visited[nx][ny] = true;
                        nodeList.insert(Node(nx, ny, head.c+1, xt, yt));
                    }
                }
            }
            if(nodeList.length <= 0)
                break;
            head = nodeList.front();
            nodeList.popFront();
        }while(true);
        return -1;
    }
    */
}

unittest {
    import std.stdio;
    Map map = new Map(25, 19, Connectivity.fourConn);
    map.loadFromFile("map.json");
    writeln(map.toString());

    map.setData!"blocked"(2, 2, true);

    writeln(map.toString());
}