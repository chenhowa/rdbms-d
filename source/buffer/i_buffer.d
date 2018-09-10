



// Interface for managing the reading and writing of a 
// buffer of bytes. The buffer is *not* encapsulated.
// For performance purposes other objects should be able
// to get access to the buffer

interface IBuffer {
    uint readFrom(IBuffer buffer);
    uint writeTo(IBuffer buffer);
    uint readFrom(IInStream input);
    uint writeTo(IOutStream output);
    byte peekFront();
    byte getFront();
    void put(ref byte b);

    byte[] getBytes();

    uint getCapacity();

    bool isEmpty();

    bool isFull();


}