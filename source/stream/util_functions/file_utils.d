
import file_state : FileState;
import stream_state : StreamState;
import template_string : String;

void checkOpen(ref FileState f_state) {
    if(!f_state.isOpen()) {
        throw new Exception("File is not open");
    }
}

byte get(ref StreamState s_state, ref FileState f_state) {
    checkOpen(f_state);

    auto file = f_state.getFile();
    auto position = f_state.getPosition();

    if(position < 0 || position > file.length - 1) {
        throw new Exception("Out of bounds");
    }

    byte val = file[position];
    f_state.incPosition();
    if(position == file.length - 1) {
        s_state.setEof(true);
    }


    return val;
}



uint read(byte[] container, ref StreamState s_state, ref FileState f_state) {
    checkOpen(f_state);

    uint bytes_read = 0;
    for(uint i = 0; i < container.length; i++) {
        if(s_state.eof()) {
            break;
        }
        container[i] = get(s_state, f_state);
    }

    return bytes_read;
}


void put(byte b, ref StreamState s_state, ref FileState f_state) {
    checkOpen(f_state);

    auto file = f_state.getFile();
    auto position = f_state.getPosition();

    if(position == file.length) {
        file.append(b);
    } else {
        file[position] = b;
    }
    f_state.incPosition();
}


uint write(byte[] stuff, ref StreamState s_state, ref FileState f_state) {
    checkOpen(f_state);

    auto file = f_state.getFile();
    auto position = f_state.getPosition();
    for(uint i = 0; i < stuff.length; i++) {
        put(stuff[i], s_state, f_state);
    }

    return cast(uint)stuff.length;
}
