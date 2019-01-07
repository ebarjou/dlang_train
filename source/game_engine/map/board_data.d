module game_engine.map.board_data;

class BoardData(D) {
    private uint _width, _height;
    private D[][][string] dataArray;

    package this(uint width, uint height){
        BoardData._height = height;
        BoardData._width = width;
    }

    package void addDataType(string key){
        dataArray[key] = new D[][](_width, _height);
    }

    package void setData(T)(string key, uint x, uint y, T value){
        dataArray[key][x][y] = cast(D)value;
    }

    package bool containsKey(string key){
        return (key in dataArray) != null;
    }

    public T getData(T)(string key, uint x, uint y){
        return cast(T)dataArray[key][x][y];
    }

    unittest {
        import core.exception;
        BoardData!uint boardData = new BoardData!uint(37, 12);
        {
            boardData.addDataType("u1");
            boardData.setData!ubyte("u1", 3, 3, 7);
            assert(boardData.getData!ubyte("u1", 3, 3) == 7);

            boardData.addDataType("b1");
            boardData.setData!bool("b1", 3, 3, true);
            assert(boardData.getData!bool("b1", 3, 3) == true);
        }
        {
            boardData.addDataType("d1");
            boardData.addDataType("d2");
            boardData.addDataType("d3");
            assert(boardData.getData!ubyte("d1", 0, 0) == 0);
            assert(boardData.getData!bool("d2", 36, 11) == false);
            
            boardData.setData!ubyte("d1", 1, 4, 45);
            boardData.setData!char("d3", 1, 4, 'a');

            assert(boardData.getData!ubyte("d1", 1, 4) == 45);
            assert(boardData.getData!bool("d2", 1, 4) == false);
            assert(boardData.getData!char("d3", 1, 4) == 'a');
            
            try{
                uint err1 = boardData.getData!ubyte("d1", 37, 0);
                assert(false);
            } catch(RangeError err){
                assert(true);
            }
            try{
                uint err1 = boardData.getData!ubyte("d4", 1, 4);
                assert(false);
            } catch(RangeError err){
                assert(true);
            }
        }
    }
}