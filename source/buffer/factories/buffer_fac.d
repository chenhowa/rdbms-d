


import i_buffer_fac : IBufferFac;
import i_buffer : IBuffer;
import buffer : Buffer;

class BufferFac : IBufferFac {
    IBuffer make(uint blocksize) {
        return new Buffer(blocksize);
    }
}