import i_in_byte_stream;
import i_out_byte_stream;



// Interface for managing the reading and writing of a 
// buffer of bytes. The buffer is *not* encapsulated.
// For performance purposes other objects should be able
// to get access to the buffer

interface IBuffer {
    uint readFrom(IBuffer buffer);
    uint writeTo(IBuffer buffer);
    uint readFrom(IInByteStream input);
    uint writeTo(IOutByteStream output);
    bool readFrom(byte b);
    byte peekFront();
    byte getFront();
    bool put(ref byte b);

    uint getCapacity();
    uint getCount();

    bool isEmpty();

    bool isFull();


}