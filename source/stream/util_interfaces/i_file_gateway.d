




interface IFileGateway {
    void open(string filename, string mode);
    bool isOpen();
    string getFilename();
}