module game_engine.map.board_data;

import std.conv;

alias BoardData = BoardDataGeneric!(CaseData, 25, 19);

struct CaseData {
    bool blocked;
    uint owner;
    bool buildingSite;
    uint buildingType;
    bool ressource;
    uint ressourceType;
}

struct BoardDataGeneric(T, uint W, uint H) {
    public uint width = W, height = H;
    public T[W][H] data;

    void set(T[][] data) {
        T[][] duplicate;
        for(int i = 0; i < height; ++i){
            for(int j = 0; j < width; ++j){
                this.data[i][j] = data[i][j];
            }
        }    
    }

    void set(string name, uint x, uint y, uint value){
        switch(name){
            case "bBlocked":
                data[x][y].blocked = to!bool(value);
                break;
            case "iOwner":
                data[x][y].owner = value;
                break;
            case "bBuildingSite":
                data[x][y].buildingSite = to!bool(value);
                break;
            case "iBuildingType":
                data[x][y].buildingType = value;
                break;
            case "iRessourceType":
                data[x][y].ressourceType = value;
                break;
            default:
                throw new Exception("Incorrect BoardData member : " ~ name);
        }
    }
}

unittest {
    import std.stdio;
    struct DataTest {
        uint x;
        char c;
        float y;
    }

    auto bd = new BoardDataGeneric!(DataTest,10, 20);

    bd.data[0][0].x = 2;
    uint x = bd.data[0][0].x;

    immutable ibd = cast(immutable)bd;

    assert(x == 2);
    assert(ibd.data[0][0].x == 2);
}