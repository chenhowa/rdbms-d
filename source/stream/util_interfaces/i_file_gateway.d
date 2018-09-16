


enum Mode {
    START,
    END
}

interface IFileGateway {
    void open(string filename, Mode mode);
    bool isOpen();
    string getFilename();
    void close();
}