


import global_filesystem : g_filesystem;
import i_filesystem;
import stream_state : StreamState;
import std.string : indexOf;
import template_string : String;

version(unittest) {
    import filesystem : FileSystem;
    import as = assert_utils;
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
    String!byte file;
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
    file = new String!byte();
}

void open(string filename, ref StreamState s_state) {
    if(s_state.good() && !isOpen() && fs.existsFile(filename)) {
        openbit = true;
        position = 0;
        file = fs.getFile(filename);
        name = filename;

        if( (file.length() == 0) || (position == file.length() - 1) ) {
            s_state.setEof(true);
        }
    } else {
        // If open operation fails, set the fail bit.
        s_state.setFail(true);
    }
}

unittest {
    FileSystem fs = new FileSystem();
    fs.reset();
    StreamState s_state = StreamState(5);
    FileState f_state = FileState(fs);
    string name = "name";
    fs.createFile(name);
    f_state.open(name, s_state);

    as.assertTrue(f_state.isOpen());
    as.assertTrue(s_state.good());
    as.assertTrue(s_state.eof());
    as.assertFalse(s_state.valid());
    as.actualEqualsExpected(f_state.getName(), name);
}

void setFile(String!byte f) {
    file = f;
}

void setFile(byte[] f) {
    file = new String!byte(f);
}

void setFile(immutable(byte)[] f) {
    file.set(f);
}

String!byte getFile() {
    return file;
}

unittest {
    FileSystem fs = new FileSystem();
    fs.reset();
    StreamState s_state = StreamState(5);
    FileState f_state = FileState(fs);
    
    f_state.getFile().empty();
    as.actualEqualsExpected(f_state.getFile().empty(), true);
    
    f_state.setFile(cast(byte[])"hello");
    as.actualEqualsExpected(f_state.getFile().getArrayCopy(),
                            cast(byte[])"hello".dup);
}


void setOpen(bool val) {
    openbit = val;
}

ulong getPosition() {
    return position;
}

ulong setPosition(FilePosition pos, ulong offset, Direction d) {
    if(file.length == 0) {
        position = 0;
        return position;
    }

    switch(pos) {
        case FilePosition.START: {
            position = _calcNewPosition(0, offset, d);
        } break;
        case FilePosition.END: {
            position = _calcNewPosition(file.length, offset, d);
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
    auto fs = new FileSystem();
    fs.reset();
    auto s_state = StreamState(5);
    auto f_state = FileState(fs);
    as.assertTrue(f_state.getPosition() == 0);

    auto pos = f_state.setPosition(FilePosition.START, 5, Direction.FORWARD);
    as.actualEqualsExpected(pos, 0);

    f_state.setFile(cast(byte[])"test file lolz");
    pos = f_state.setPosition(FilePosition.START, 5, Direction.FORWARD);
    as.actualEqualsExpected(pos, 5);
}

private ulong _calcNewPosition(ulong position, ulong offset, Direction d) {
    if(d == Direction.FORWARD) {
        ulong newPos = position + offset;
        bool isValidPosition = newPos < file.length + 1;
        return isValidPosition ? newPos : file.length;
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
        file = new String!byte();
    }
}

unittest {
    auto fs = new FileSystem();
    fs.reset();
    auto s_state = StreamState(5);
    auto f_state = FileState(fs);

    f_state.close(s_state);
    as.assertFalse(s_state.valid());
    as.assertFalse(s_state.good());
    as.assertFalse(s_state.eof());
}

}