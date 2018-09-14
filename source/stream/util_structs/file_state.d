


import global_filesystem : g_filesystem;
import i_filesystem;
import stream_state : StreamState;
import std.string : indexOf;
import template_string : String;

version(unittest) {
    import filesystem;
    import stream_state;
}


enum FilePosition {
    START,
    END,
    CURRENT
}

enum Direction {
    FORWARD,
    BACKWARD
}

struct FileState {
    private {
        bool openbit;
        string name;
        IFileSystem fs;
        String!char file;
        string mode;
        ulong position;
    }

    this(int placeholder) {
        this(g_filesystem);
    }

    this(IFileSystem filesystem) {
        openbit = false;
        name = "";
        fs = filesystem;
        position = 0;
    }

    void open(string filename, string mode, ref StreamState s_state) {
        if(s_state.good() && !isOpen()) {
            mode = mode;
            openbit = true;
            position = 0;
        } else {
            s_state.setFail(true);
        }
    }

    unittest {

    }

    void setFile(String!char f) {
        file = f;
    }

    void setOpen(bool val) {
        openbit = val;
    }

    ulong getPosition() {
        return position;
    }
    
    ulong setPosition(FilePosition pos, ulong offset, Direction d) {
        switch(pos) {
            case FilePosition.START: {
                position = _calcNewPosition(0, offset, d);
            } break;
            case FilePosition.END: {
                position = _calcNewPosition(file.length - 1, offset, d);
            } break;
            case FilePosition.CURRENT: {
                position = _calcNewPosition(position, offset, d);
            } break;
            default: {
                throw new Exception("Unknown file position");
            }
        }
        return position;
    }

    unittest  {

    }

    private ulong _calcNewPosition(ulong position, ulong offset, Direction d) {
        if(d == Direction.FORWARD) {
            ulong newPos = position + offset;
            bool isValidPosition = newPos < file.length;
            return isValidPosition ? newPos : file.length - 1;
        } else if (d == Direction.BACKWARD) {
            return position < offset ? 0 : position - offset;
        } else {
            throw new Exception("Invalid Direction enum val");
        }
    }

    unittest {

    }

    ulong incPosition() {
        return setPosition(FilePosition.CURRENT, 1, Direction.FORWARD);
    }

    ulong decPosition() {
        return setPosition(FilePosition.CURRENT, 1, Direction.BACKWARD);
    }

    bool isOpen() {
        return openbit;
    }

    string getName() {
        return name;
    }

    void close(ref StreamState s_state) {
        if( !isOpen() ) {
            s_state.setFail(true);
        } else {
            openbit = false;
            name = "";
            file = new String!char();
        }
    }

    unittest {
        
    }
}