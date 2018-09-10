



interface IFileSystem {
    void reset();
    ulong getNumFiles();
    bool existsFile(string name);
    bool createFile(string name);
    bool deleteFile(string name);
    bool renameFile(string name, string newName);
    bool setFile(string name, string contents);
    string getFile(string name);
    bool appendToFile(string name, string contents);
}