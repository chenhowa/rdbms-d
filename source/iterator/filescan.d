

import i_iterator;
import i_tuple;
import i_tuple_layout;

import std.stdio;

class FileScan : IIterator {
    private {
        string file;
        ITupleLayout layout;
        File handle;
    }

    this(string filename) {
        file = filename;
    }

    void init() {
        // When init is called, open the file and get
        // the file layout. Treat the file layout as a byte layout
        // alone if a file layout cannot be found.
        handle = File();
        handle.open(file, "rb");
    }

    private void obtainTupleLayout(File handle) {
        handle.seek(0, SEEK_END);
        

        // Return to beginning of file
        handle.seek(0, SEEK_SET);
    }

    ITuple next() {
        // Should inject a factory to produce the correct.
        // ITuples from the file?
    }

    ITupleLayout getLayout() {
        return layout;
    }

    void close() {
        handle.close();
    }
}