


import i_out_byte_stream;
import i_in_byte_stream;




interface ITempFileManager {
    uint getNumTempFiles();
    bool createTempFile(ulong index);
    IOutByteStream getWriteStream(ulong index);
    IInByteStream getReadStream(ulong index);
    bool existsTempFile(ulong index);
    bool closeTempFile(ulong index);
}