module game_engine.map.board_data;

import std.conv;

class BoardData(T) {
    public immutable uint width, height;
    private T[][] _data;

    public this(uint width, uint height){
        this.height = width;
        this.width = height;
        this._data = new T[][](width, height);
    }

    private this(uint width, uint height, T[][] data) immutable {
        this.height = width;
        this.width = height;

        T[][] duplicate;
        for(int i = 0; i < width; ++i){
            duplicate ~= data[i].dup();
        }    

        this._data = duplicate.to!(immutable(T[][]));
    }

    public auto get(string member)(uint x, uint y) immutable {
        return mixin("_data[x][y]." ~ member);
    }

    public auto get(string member)(uint x, uint y) {
        return mixin("_data[x][y]." ~ member);
    }

    public void set(string member, D)(uint x, uint y, D value){
        mixin("_data[x][y]." ~ member) = value;
    }

    public immutable(BoardData) idup(){
        return new immutable BoardData(this.height, this.width, this._data);
    }

}

unittest {
    import std.stdio;
    struct DataTest {
        uint x;
        char c;
        float y;
    }

    BoardData!(DataTest) bd = new BoardData!(DataTest)(10, 20);

    bd.set!"x"(0, 0, 2);
    uint x = bd.get!"x"(0,0);

    assert(x == 2);
}