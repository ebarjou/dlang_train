module game_engine.map.map;

import game_engine.map.board_data;

import std.container;
import std.conv : to;

private immutable static byte[][][] Moves = [
    [[1, 0], [-1, 0], [0, 1], [0, -1]],
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, -1], [1, 1], [-1, 1], [-1, -1]],
    [[-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 0], [0, -1]]
];

immutable static enum Connectivity {fourConn=0, eightConn, hexConn}

struct Map {
    public Connectivity connectivity = Connectivity.hexConn;
    public BoardData boardData;

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

}