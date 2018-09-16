
import i_byte_writer;

import stream_state : StreamState;

import file_state : FileState, FilePosition, Direction;

import global_filesystem : g_filesystem;
import i_filesystem : IFileSystem;

import template_string : String;

import i_file_gateway : Mode;

import f_utils = file_utils;

version(unittest) {
    import as = assert_utils;
}


class MockByteWriter : IByteWriter {
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
    auto writer = new MockByteWriter();
    as.actualEqualsExpected(writer.good(), true);
    as.actualEqualsExpected(writer.valid(), true);
    as.actualEqualsExpected(writer.eof(), false);
}

override {
    void open(string filename, Mode mode = Mode.END) {
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

    auto writer = new MockByteWriter();
    as.assertFalse(writer.isOpen());
    writer.open(name);
    as.assertTrue(writer.isOpen());
    as.actualEqualsExpected(writer.getFilename(), name);
    writer.put(cast(byte)'!');
    as.actualEqualsExpected(
        g_filesystem.getFile(name).getArrayCopy(),
        cast(byte[])(contents ~ "!")
    );

    writer.close();
    as.assertFalse(writer.isOpen());
    as.actualEqualsExpected(writer.getFilename(), "");

    as.assertTrue(writer.good());
    writer.open("random name");
    as.assertFalse(writer.good());
    as.assertFalse(writer.valid());
}

override {
    bool put(byte b) {
        f_utils.put(b, s_state, f_state);
        return true;
    }

    uint write(byte[] stuff) {
        return f_utils.write(stuff, s_state, f_state);
    }
}

unittest {
    g_filesystem.reset();
    string name = "name";
    g_filesystem.createFile(name);
    string contents = "Hello";
    g_filesystem.setFile(name, new String!byte(cast(byte[])contents));
    as.actualEqualsExpected(
        g_filesystem.getFile(name).getArrayCopy(),
        cast(byte[])contents.dup
    );

    auto writer = new MockByteWriter();
    writer.open(name);
    as.assertTrue(writer.isOpen());
    as.actualEqualsExpected(writer.getFilename(), name);

    writer.put(cast(byte)('!'));
    as.actualEqualsExpected(
        g_filesystem.getFile(name).getArrayCopy(),
        cast(byte[])(contents ~ "!")
    );
}

unittest {
    g_filesystem.reset();
    string name = "name";
    g_filesystem.createFile(name);
    string contents = "Hello";
    g_filesystem.setFile(name, new String!byte(cast(byte[])contents));
    as.actualEqualsExpected(
        g_filesystem.getFile(name).getArrayCopy(),
        cast(byte[])contents.dup
    );

    auto writer = new MockByteWriter();
    writer.open(name);
    as.assertTrue(writer.isOpen());
    as.actualEqualsExpected(writer.getFilename, name);
    string extra = ", world!";
    writer.write(cast(byte[])extra);
    as.actualEqualsExpected(
        g_filesystem.getFile(name).getArrayCopy(),
        cast(byte[])(contents ~ extra)
    );
}

}