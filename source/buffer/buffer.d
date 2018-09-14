




import i_buffer;
import i_in_byte_stream;
import i_out_byte_stream;
import assert_utils;
import i_tuple;

import std.stdio : writeln;


class Buffer : IBuffer {


    private {
        byte[] buffer;
        uint readIndex;
        uint writeIndex;
        uint capacity;
        uint count;
    }

    invariant() {
        assert( (readIndex >= 0) && (readIndex < capacity) );
        assert( (count <= capacity) && (count >= 0) );
        assert( buffer.length == capacity );
        if(writeIndex < readIndex) {
            assert(count == (readIndex - writeIndex) );
        } else if(writeIndex == readIndex) {
            assert(count == 0 || count == capacity);
        }
        else {
            assert(count == (capacity + readIndex - writeIndex) );
        }
    }

    this(uint blocksize) {
        if(blocksize == 0) {
            throw new Exception("0 blocksize is invalid");
        }

        readIndex = 0;
        writeIndex = 0;
        count = 0;
        buffer = new byte[blocksize];
        capacity = blocksize;
    }

    unittest {
        Buffer buffer = new Buffer(10);
        actualEqualsExpected(buffer.isEmpty(), true);
        actualEqualsExpected(buffer.isFull(), false);
        actualEqualsExpected(buffer.isCount(0), true);
        actualEqualsExpected(buffer.getCapacity(), 10);
    }

    byte opIndex(size_t index) {
        // TODO : Throw exception if index > capacity
        // or buffer is empty.
        if( isEmpty() ) {
            throw new Exception("Accessed empty buffer");
        }

        if(index >= count || index < 0) {
            throw new Exception("Accessed out of bounds");
        }

        return buffer[ (writeIndex + index) % capacity ];
    }

    unittest {
        uint size = 10;
        byte test_val = 12;
        Buffer buffer = new Buffer(size);
        for(uint i = 0; i < size / 2; i++) {
            buffer.readFrom(test_val);
            actualEqualsExpected(buffer[i], test_val);
        }

        actualEqualsExpected(buffer.isCount(size / 2), true);
        actualEqualsExpected(buffer.isEmpty(), false);
        actualEqualsExpected(buffer.isFull(), false);
    }

    void opIndexAssign(byte val, size_t index) {
        if( isEmpty() ) {
            throw new Exception("Tried to write to empty buffer");
        }

        if(index >= count || index < 0) {
            throw new Exception("Tried to write out of bounds");
        }

        buffer[ (writeIndex + index) % capacity ] = val;
    }

    unittest {
        uint size = 10;
        byte test_val = 12;
        byte new_val = 15;
        Buffer buffer = new Buffer(size);
        for(uint i = 0; i < size / 2; i++) {
            buffer.readFrom(test_val);
            actualEqualsExpected(buffer[i], test_val);
            buffer[i] = new_val;
            actualEqualsExpected(buffer[i], new_val);
        }

        actualEqualsExpected(buffer.isCount(size / 2), true);
        actualEqualsExpected(buffer.isEmpty(), false);
        actualEqualsExpected(buffer.isFull(), false);
    }

    override bool opEquals(Object o) {
        if(auto b = cast( typeof(this) ) o ) {
            if(getCount() != b.getCount()) return false;

            for(uint i = 0; i < getCount(); i++) {
                if( this[i] != b[i]) {
                    return false;
                }
            }
            return true;
        }

        return false;
    }

    unittest {
        uint size = 10;
        Buffer a = new Buffer(size);
        Buffer b = new Buffer(size * 2);
        byte val = 12;
        byte extra_val = 15;
        for(uint i = 0; i < size; i++ ) {
            a.readFrom(val);
            b.readFrom(val);
        }
        actualEqualsExpected(a.getCount(), size);
        assertEqual(a.getCount(), b.getCount());
        actualEqualsExpected(a == b, true);

        b.readFrom(val);
        assertNotEqual(a.getCount(), b.getCount());
        actualEqualsExpected(a == b, false);

        a.readFrom(extra_val);
        actualEqualsExpected(a == b, false);

    }

    uint readFrom(IBuffer other) {
        uint bytes_read = 0;
        while(!other.isEmpty() && !isFull()) {
            buffer[readIndex] = other.getFront();
            _nextReadIndex();
            bytes_read += 1;
            _incCount();
        }

        return bytes_read;
    }

    unittest {
        uint size = 10;
        Buffer buffer = new Buffer(size);
        Buffer other = new Buffer(size * 2);
        byte val = 2;

        for(uint i = 0; i < size; i++) {
            buffer.readFrom(val);
        }
        actualEqualsExpected(buffer.getCount(), size);
        assertTrue(buffer.isFull());

        uint bytes_read = other.readFrom(buffer);
        actualEqualsExpected(other.getCount(), size);
        for(uint i = 0; i < size; i++) {
            actualEqualsExpected(other[i], val);
        }
        assertTrue(buffer.isEmpty());
        assertFalse(other.isFull());
        actualEqualsExpected(bytes_read, size);
    }

    private void _nextReadIndex() {
        readIndex = (readIndex + 1) % capacity;
    }

    private void _incCount() {
        count = count + 1;
    }

    uint writeTo(IBuffer other) {
        uint bytes_written = other.readFrom(this);
        return bytes_written;
    }

    unittest {
        uint size = 10;
        Buffer buffer = new Buffer(size);
        Buffer other = new Buffer(size * 2);
        byte val = 2;

        for(uint i = 0; i < size; i++) {
            buffer.readFrom(val);
        }
        actualEqualsExpected(buffer.getCount(), size);
        assertTrue(buffer.isFull());

        uint bytes_written = buffer.writeTo(other);
        actualEqualsExpected(other.getCount(), size);
        for(uint i = 0; i < size; i++) {
            actualEqualsExpected(other[i], val);
        }
        assertTrue(buffer.isEmpty());
        assertFalse(other.isFull());
        assertEqual(bytes_written, size);
    }

    uint readFrom(IInByteStream input) {
        uint bytes_read = 0;
        while( !isFull() && input.valid() ) {
            readFrom(input.get());
            bytes_read += 1;
        }

        return bytes_read;
    }

    uint writeTo(IOutByteStream output) {
        uint bytes_written = 0;
        while( !isEmpty() ) {
            output.put( getFront() );
            bytes_written += 1;
        }

        return bytes_written;
    }

    bool readFrom(byte b) {
        if(isFull()) {
            return false;
        }

        buffer[readIndex] = b;
        _nextReadIndex();
        _incCount();
        return true;
    }

    unittest {
        Buffer buffer = new Buffer(10);
        byte val = 3;
        buffer.readFrom(val);
        assertTrue(buffer.isCount(1));
        actualEqualsExpected(buffer[0], val);
    }

    uint readFrom(ITuple tuple) {
        uint bytes_read = 0;
        while(!isFull() && (bytes_read < tuple.getByteLength()) ) {
            buffer[readIndex] = tuple.getByte(bytes_read);
            _nextReadIndex();
            _incCount();
            bytes_read += 1;
        }

        return bytes_read;
    }


    byte peekFront() {
        return buffer[writeIndex];
    }

    unittest {
        Buffer buffer = new Buffer(10);
        buffer.readFrom(5);
        buffer.readFrom(6);
        actualEqualsExpected(buffer.peekFront(), 5);
        buffer.getFront();
        actualEqualsExpected(buffer.peekFront(), 6);
    }

    byte getFront() {
        byte res = buffer[writeIndex];
        _nextWriteIndex();
        _decCount();

        return res;
    }

    unittest {
        Buffer buffer = new Buffer(10);
        buffer.readFrom(10);
        buffer.readFrom(6);
        assertTrue(buffer.isCount(2));
        actualEqualsExpected(buffer.getFront(), 10);
        assertTrue(buffer.isCount(1));
        actualEqualsExpected(buffer.getFront(), 6);
        assertTrue(buffer.isEmpty());
    }

    private void _nextWriteIndex() {
        writeIndex = (writeIndex + 1) % capacity;
    }

    private void _decCount() {
        count -= 1;
    }

    bool put(ref byte b) {
        if(!isEmpty()) {
            b = getFront();
            return true;
        }

        return false;
    }

    unittest {
        Buffer buffer = new Buffer(10);
        byte val = 10;
        buffer.readFrom(val);

        byte b = val / 2;
        buffer.put(b);
        actualEqualsExpected(b, 10);
    }

    uint discard(uint num_bytes) {
        uint bytes_discarded = 0;
        while(!isEmpty()) {
            _nextWriteIndex();
            _decCount();
            bytes_discarded += 1;
        }

        return bytes_discarded;
    }

    uint getCapacity() {
        return capacity;
    }

    bool isEmpty() {
        return count == 0;
    }

    bool isFull() {
        return count == capacity;
    }

    bool isCount(uint count) {
        return this.count == count;
    }

    uint getCount() {
        return count;
    }
}