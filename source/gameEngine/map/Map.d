module gameEngine.map.Map;

import gameEngine.map.BoardData;
import std.stdio;
import std.container;
import std.file;
import std.json;
import std.conv : to;

struct Node {
    uint x;
    uint y;
    uint d;
    uint c;
    this(uint x, uint y, uint c, uint d){
        this.x = x;
        this.y = y;
        this.d = d;
        this.c = c;
    }
    this(uint x, uint y, uint c, uint xt, uint yt){
        this.x = x;
        this.y = y;
        this.c = c;
        this.d = (x-xt)*(x-xt) + (y-yt)*(y-yt);
    }
}

class Map {
    public immutable static enum Connectivity {fourConn=0, eightConn, hexConn}
    private immutable static byte[][][] moves = [
        [[1, 0], [-1, 0], [0, 1], [0, -1]],
        [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [1, 1], [-1, 1], [-1, -1]],
        [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 0], [0, -1]]
    ];
    public immutable string[] dataTypes = [
        "bBlocked", 
        "iOwner",
        "bBuildingSite",
        "iBuildingType",
        "bRessource",
        "iRessourceType",
    ];
    private immutable ushort _width, _height;
    private immutable Connectivity _connectivity;
    private BoardData!ubyte _boardData;

    this(ushort width, ushort height, Connectivity connectivity){
        _height = height;
        _width = width;
        _connectivity = connectivity;
        _boardData = new BoardData!ubyte(_width, _height);
        addAllDataType();
    }

    public void loadFromFile(string path){
        string content = readText(path);
        JSONValue json = parseJSON(content);
        JSONValue layers = json["layers"];
        foreach(ulong index, JSONValue layer; layers){
            string name = layer["name"].str;
            JSONValue dataArray = layer["data"];
            switch(name[0]){
                case 'i':
                    foreach(ulong subIndex, JSONValue data; dataArray){
                        ubyte value = to!ubyte(data.integer);
                        uint x = to!uint(subIndex)%_width;
                        uint y = to!uint(subIndex)/_width;
                        _boardData.setData!ubyte(name, x, y, value);
                    }
                    break;
                case 'b':
                    foreach(ulong subIndex, JSONValue data; dataArray){
                        bool value = data.integer != 0;
                        uint x = to!uint(subIndex)%_width;
                        uint y = to!uint(subIndex)/_width;
                        //writeln(subIndex, " -> ", x, ":", y, " = ", value);
                        _boardData.setData!bool(name, x, y, value);
                    }
                    break;
                default:
                    throw new Exception("Error in Map : DataType incorrect");
            }
            
            
        }
    }

    private void addAllDataType(){
        foreach(string type; dataTypes){
            if(type.length <= 0)
                throw new Exception("Error in Map : DataType incorrect");
            switch(type[0]){
                case 'i':
                    _boardData.addDataType(type);
                    break;
                case 'b':
                    _boardData.addDataType(type);
                    break;
                default:
                    throw new Exception("Error in Map : DataType incorrect");
            }
        }
    }

    public T getData(T)(string key, uint x, uint y){
        return _boardData.getData!T(key, x, y);
    }

    public bool containsKey(string key){
        return _boardData.containsKey(key);
    }

    public bool isBlocked(uint x, uint y){
        return _boardData.getData!bool("bBlocked", x, y);
    }

    public bool isInBoundaries(uint x, uint y){
        return !(x >= _width || x < 0 || y >= _height || y < 0);
    }

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

    unittest {
        Map map = new Map(25, 19, Map.Connectivity.eightConn);
        foreach(string type; map.dataTypes)
            assert(map.containsKey(type));
        
        import std.datetime;
        StopWatch sw;
        
        sw.start();
        int dist = map.getPath(0, 0, 23, 17, 50);
        writeln(dist, " (", sw.peek().nsecs/1e6, "ms)");

        map.loadFromFile("map.json");
        for(int y = 0; y < 19; ++y){
            for(int x = 0; x < 25; ++x){
                write(map.getData!ubyte("bBlocked", x, y));
            }
            writeln();
        }
        sw.reset();
        dist = map.getPath(0, 0, 23, 17, 100);
        writeln(dist, " (", sw.peek().nsecs/1e6, "ms)");
    }
}