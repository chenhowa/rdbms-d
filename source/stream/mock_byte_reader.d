

import i_byte_reader : IByteReader;
import stream_state : StreamState;
import file_state : FileState, FilePosition, Direction;
import f_utils = file_utils;
import template_string;

import i_file_gateway : Mode;


version(unittest) {
    import as = assert_utils;
    import std.conv;

}

version(unittest) {
    import global_filesystem : g_filesystem;
}

class MockByteReader : IByteReader {

private {
    StreamState s_state;
    FileState f_state;
}

this() {
    s_state = StreamState(5);
    f_state = FileState(5);
}

this(String!byte file) {
    s_state = StreamState(5);
    f_state = FileState(5);
    f_state.setFile(file);
    f_state.setOpen(true);
}

override {
    bool good() {
        return s_state.good();
    }

    bool valid() {
        return s_state.valid();
    }

    bool eof() {
        return s_state.eof();
    }
}

unittest {
    auto reader = new MockByteReader();
    as.actualEqualsExpected(reader.good(), true);
    as.actualEqualsExpected(reader.valid(), true);
    as.actualEqualsExpected(reader.eof(), false);
}

override {
    void open(string filename, Mode mode = Mode.START) {
        f_state.open(filename, s_state);
        if(!s_state.good()) {
            return;
        }

        switch(mode) {
            case Mode.START : {
                f_state.setPosition(FilePosition.START, 0, Direction.FORWARD);
            } break;
            case Mode.END : {
                f_state.setPosition(FilePosition.END, 0, Direction.FORWARD);
            } break;
            default: {
                throw new Exception("Unhandled mode");
            }
        }
    }

    bool isOpen() {
        return f_state.isOpen();
    }

    string getFilename() {
        return f_state.getName();
    }

    void close() {
        f_state.close(s_state);
    }
}

unittest {
    g_filesystem.reset();
    as.actualEqualsExpected(g_filesystem.getNumFiles(), 0);
    string name = "name";
    g_filesystem.createFile(name);
    string contents = "Hello!";
    g_filesystem.setFile(name, new String!byte(cast(byte[])contents));
    as.actualEqualsExpected(
            g_filesystem.getFile(name).getArrayCopy(),
            cast(byte[])contents.dup
    );

    auto reader = new MockByteReader();
    as.assertFalse(reader.isOpen());
    reader.open(name);
    as.assertTrue(reader.isOpen());
    as.actualEqualsExpected(reader.getFilename(), name);
    as.actualEqualsExpected(reader.get(), to!byte(contents[0]) );

    reader.close();
    as.assertFalse(reader.isOpen());
    as.actualEqualsExpected(reader.getFilename(), "");
}

override {
    byte get() {
        return f_utils.get(s_state, f_state);
    }


    uint read(byte[] container) {
        return f_utils.read(container, s_state, f_state);
    }


}

unittest {
    auto reader = new MockByteReader();
    g_filesystem.reset();
    string name = "name";
    g_filesystem.createFile(name);
    string contents = "hello";
    g_filesystem.setFile(name, new String!byte(cast(byte[])contents));
    
    as.assertFalse(reader.isOpen());
    reader.open(name, Mode.START);
    as.assertTrue(reader.isOpen());

    as.actualEqualsExpected(reader.get(), to!byte(contents[0]) );
}

unittest {
    auto reader = new MockByteReader();
    g_filesystem.reset();
    string name = "name";
    g_filesystem.createFile(name);
    string contents = "hello";
    g_filesystem.setFile(name, new String!byte(cast(byte[])contents));
    
    as.assertFalse(reader.isOpen());
    reader.open(name, Mode.START);
    as.assertTrue(reader.isOpen());

    auto container = new byte[contents.length];
    reader.read(container);
    as.actualEqualsExpected(container, cast(byte[])(contents)) ;
}


}


unittest {
    // General unit test across multiple calls
    // to the FileReader API.
}