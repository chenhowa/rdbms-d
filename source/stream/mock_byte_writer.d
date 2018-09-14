
import i_byte_writer;

import stream_state : StreamState;

import file_state : FileState;

import global_filesystem : g_filesystem;


class MockByteWriter : IByteWriter {
private {
    StreamState s_state;
    FileState f_state;
}

this() {
    s_state = StreamState(5);
    f_state = FileState(5);
}

this(ref string file) {
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

override {
    void open(string filename, string mode) {
        f_state.open(filename, mode, s_state);
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

override {
    bool put(byte b) {
        return false;
    }

    uint write() {
        return 5;
    }
}

}