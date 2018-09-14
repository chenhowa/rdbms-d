

import i_byte_reader : IByteReader;
import stream_state : StreamState;
import file_state : FileState;
import f_utils = file_utils;
import template_string;


class MockByteReader : IByteReader {

private {
    StreamState s_state;
    FileState f_state;
}

this() {
    s_state = StreamState(5);
    f_state = FileState(5);
}

this(String!char file) {
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
    byte get() {
        return f_utils.get(s_state, f_state);
    }

    uint read() {
        return f_utils.read(s_state, f_state);
    }
}

}