




import i_buffer;


class Buffer : IBuffer {

    private {
        byte[] buffer;
        uint readIndex;
        uint writeIndex;
        uint capacity;
    }

    this(uint blocksize) {
        readIndex = 0;
        writeIndex = 0;
        buffer = new byte[blocksize];
        capacity = blocksize;
    }

    uint readFrom(IBuffer other) {
        uint bytes_read = 0;
        while(!other.isEmpty() && !isFull()) {
            buffer[readIndex] = other.getFront();
            _incReadIndex();
            bytes_read += 1;
        }

        return bytes_read;
    }

    private void _incReadIndex() {
        readIndex = (readIndex + 1) % capacity;
    }

    uint writeTo(IBuffer other) {
        uint bytes_written = other.readFrom(this);
        return bytes_written;
    }

    uint readFrom(IInStream input) {

    }

    uint writeTo(IOutStream output) {

    }
    byte peekFront() {

    }

    byte getFront() {

    }

    void put(ref byte b) {

    }

    byte[] getBytes() {

    }

    uint getCapacity() {

    }

    bool isEmpty() {

    }

    bool isFull() {

    }
}