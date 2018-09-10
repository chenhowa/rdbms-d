


import i_filesystem;
import assert_utils;


class FileSystem : IFileSystem {
    private {
        string[string] lookup;
    }

    this() {

    }

    unittest {
        FileSystem fs = new FileSystem();
        actualEqualsExpected(fs.getNumFiles(), 0);
    }

    void reset() {
        lookup.clear();
    }

    unittest {
        FileSystem fs = new FileSystem();
        fs.createFile("apple");
        fs.createFile("banana");
        actualEqualsExpected(fs.getNumFiles(), 2);
        fs.reset();
        actualEqualsExpected(fs.getNumFiles(), 0);
    }

    ulong getNumFiles() {
        return lookup.length;
    }

    bool existsFile(string name) {
        string* p = (name in lookup);
        return p !is null;
    }

    unittest {
        FileSystem fs = new FileSystem();
        string name = "name";
        assertFalse(fs.existsFile(name));
        fs.createFile(name);
        assertTrue(fs.existsFile(name));
        string newname = "newname";
        fs.renameFile(name, newname);
        assertFalse(fs.existsFile(name));
        assertTrue(fs.existsFile(newname));
    }

    bool createFile(string name) {
        if( !(name in lookup) ) {
            lookup.require(name, "");
            return true;
        }

        return false;
    }

    bool deleteFile(string name) {
        if( existsFile(name ) ) {
            lookup.remove(name);
            return true;
        }

        return false;
    }

    unittest {
        FileSystem fs = new FileSystem();
        string name = "name";
        fs.createFile(name);
        assertTrue(fs.existsFile(name));
        actualEqualsExpected(fs.getNumFiles(), 1);
        fs.deleteFile(name);
        assertFalse(fs.existsFile(name));
        actualEqualsExpected(fs.getNumFiles(), 0);
    }

    bool renameFile(string name, string newName) {
        if(!existsFile(name) || existsFile(newName)) {
            return false;
        }
        
        lookup.require(newName, lookup[name]);
        lookup.remove(name);

        return true;
    }

    bool setFile(string name, string contents) {
        if(!existsFile(name) ) {
            return false;
        }

        lookup[name] = contents;

        return true;
    }

    unittest {
        FileSystem fs = new FileSystem();
        string name = "name";
        string val = "val";
        fs.createFile(name);
        fs.setFile(name, val);
        actualEqualsExpected(fs.getFile(name), val);
    }

    string getFile(string name) {
        if(!existsFile(name)) {
            return "";
        }

        return lookup[name];
    }

    bool appendToFile(string name, string contents) {
        if( !existsFile(name) ) {
            return false;
        }

        lookup[name] = lookup[name] ~ contents;

        return true;
    }

    unittest {
        FileSystem fs = new FileSystem();
        string name = "name";
        string val = "val";
        string val2 = "2";
        fs.createFile(name);
        fs.setFile(name, val);
        fs.appendToFile(name, val2);
        actualEqualsExpected(fs.getFile(name), val ~ val2);
    }
}