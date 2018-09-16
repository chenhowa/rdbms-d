


import i_tuple;
import i_tuple_layout;
import i_iterator;
import i_buffer;
import i_byte_writer;
import i_byte_reader;
import i_temp_file_manager : ITempFileManager;
import i_buffer_fac : IBufferFac;
import i_tuple_fac : ITupleFac;
import std.conv;



class HashItr : IIterator {
    private {
        ITuple tuple;
        ITupleLayout layout;
        IIterator[1] inputs;
        IBuffer[] buffers;

        IByteReader[] readers;
        IByteWriter[] writers;
        uint current_file;
        uint blocksize;

        ITuple[][ulong] hashTable;

        ITempFileManager manager;

        IBufferFac bufferFac;
        ITupleFac tupleFac;
    }

    this(IIterator itr) {
        inputs[0] = itr;
        current_file = 0;
    }

    // This function will actually do all the hashing.
    void init() {
        inputs[0].init();
        layout = inputs[0].getLayout();

        // AT START, THROW EXCEPTION IF A TUPLE CAN
        // BE LARGER THAN THE BLOCK SIZE.

        ITuple tuple = inputs[0].next();
        while(true) {
            if(tuple.end()) break;
            buffers[0].readFrom(tuple);

            if(buffers[0].isFull()) {
                while( !buffers[0].isEmpty() ) {
                    // Do the hashing.
                    // In this case, we will just hash the byte value
                    ulong hash = 1 + ( buffers[0].peekFront() % (buffers.length - 1) );
                    buffers[hash].readFrom(buffers[0].getFront());

                    if(buffers[hash].isFull()) {
                        // write to temp file.
                        buffers[hash].writeTo(writers[hash]);
                    }
                }
            }


            tuple = inputs[0].next();
        }

        // Once hashing is done, deallocate all memory
        // involved for the buffers.
    }

    unittest {
        
    }

    ITuple next() {
        // if the hash table is empty, read in the next
        // set of values to hash one by one from the file,
        // and then insert into the hash table.

        // reallocate memory to read as many blocks as possible for this
        // iterator.
        buffers[0] = bufferFac.make( to!uint(blocksize * buffers.length) );
        while(current_file < readers.length) {
            // read data in, hash each tuple, and put in the
            // correct part of the hash table.

            // This should have read in the entire file with plenty
            // of space to spare.
            uint bytes_read = buffers[0].readFrom(readers[current_file]);
            if (_isFull(buffers[0]) ) {
                throw new Exception("Read buffer should not be full");
            }

            // Read in next tuple from the hash file, hash it, and then send it to the
            // caller

            byte[] slice;
            ITuple tup = tupleFac.make(slice);
            return tup;

        }


        return tuple;
    }

    private bool _isFull(IBuffer buffer) {
        return true;
    }

    ITupleLayout getLayout() {
        return layout;
    }

    void close() {

    }
}