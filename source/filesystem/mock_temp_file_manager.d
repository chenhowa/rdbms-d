


import i_temp_file_manager;
import i_filesystem;
import i_out_byte_stream;
import i_in_byte_stream;
import std.conv;
import global_filesystem : g_filesystem;
import template_string;

import mock_byte_writer;
import mock_byte_reader;

class MockTempFileManager : ITempFileManager {
    private {
        IFileSystem fs;
        String!byte[ulong] tmpfiles;
    }

    this() {
        fs = g_filesystem;
    }

    this(IFileSystem filesystem) {
        fs = filesystem;
    }

    uint getNumTempFiles() {
        return to!uint(tmpfiles.length);
    }

    bool createTempFile(ulong index) {
        if(existsTempFile(index)) {
            return false;
        }

        string name = to!string(index);
        fs.createFile(name);
        tmpfiles[index] = fs.getFile(name);
        return true;
    }

    IOutByteStream getWriteStream(ulong index) {
        if(!existsTempFile(index)) {
            throw new Exception("No such temp file");
        }

        // returns a stream containing a reference to the fs string.
        MockByteWriter writer = new MockByteWriter(tmpfiles[index]);

        return writer;
    }

    IInByteStream getReadStream(ulong index) {
        if(!existsTempFile(index)) {
            throw new Exception("No such temp file");
        }

        // returns a stream containing a reference to the fs string
        MockByteReader reader = new MockByteReader(tmpfiles[index]);

        return reader;
    }

    bool existsTempFile(ulong index) {
        return ( (index in tmpfiles) !is null );
    }

    bool closeTempFile(ulong index) {
        if(!existsTempFile(index)) {
            return false;
        }

        fs.deleteFile(to!string(index));
        tmpfiles.remove(index);
        return true;
    }
}