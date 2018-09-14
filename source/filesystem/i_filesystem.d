

import std.array : RefAppender;
import template_string : String;

interface IFileSystem {
    void reset();
    ulong getNumFiles();
    bool existsFile(string name);
    bool createFile(string name);
    bool deleteFile(string name);
    bool renameFile(string name, string newName);
    bool setFile(string name, String!char contents);
    String!char getFile(string name);
    bool appendToFile(string name, String!char contents);
}