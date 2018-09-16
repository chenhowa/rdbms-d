


import i_filesystem;
import assert_utils;
import template_string : String;

class FileSystem : IFileSystem {
    private {
        String!byte[string] lookup;
    }

    this() {

    }

    unittest {
        FileSystem fs = new FileSystem();
        actualEqualsExpected(fs.getNumFiles(), 0);
    }

    override void reset() {
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

    override ulong getNumFiles() {
        return lookup.length;
    }

    override bool existsFile(string name) {
        String!byte* p = (name in lookup);
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

    override bool createFile(string name) {
        if( !(name in lookup) ) {
            auto val = new String!byte();
            lookup.require(name, val);
            return true;
        }

        return false;
    }

    override bool deleteFile(string name) {
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

    override bool renameFile(string name, string newName) {
        if(!existsFile(name) || existsFile(newName)) {
            return false;
        }
        
        lookup.require(newName, lookup[name]);
        lookup.remove(name);

        return true;
    }

    override bool setFile(string name, String!byte contents) {
        if(!existsFile(name) ) {
            return false;
        }

        lookup[name] = contents;

        return true;
    }

    unittest {
        FileSystem fs = new FileSystem();
        auto name = "name";
        auto val = new String!byte(cast(byte[])"val");
        fs.createFile(name);
        fs.setFile(name, val.dup);
        actualEqualsExpected(fs.getFile(name), val);
    }

    override String!byte getFile(string name) {
        if(!existsFile(name)) {
            throw new Exception("File does not exist");
        }

        return lookup[name];
    }

    override bool appendToFile(string name, String!byte contents) {
        if( !existsFile(name) ) {
            return false;
        }

        lookup[name] = lookup[name] ~ contents;

        return true;
    }

    unittest {
        FileSystem fs = new FileSystem();
        string name = "name";
        auto val = new String!byte(cast(byte[])"val");
        auto val2 = new String!byte(cast(byte[])"2");
        fs.createFile(name);
        fs.setFile(name, val.dup);
        fs.appendToFile(name, val2);
        actualEqualsExpected(fs.getFile(name), val ~ val2);
    }

    unittest {
        // Test that filesystem can be edited by other objects
        FileSystem fs = new FileSystem();
        string name = "name";
        auto val = new String!byte(cast(byte[])"test");
        auto val2 = new String!byte(cast(byte[])"2");
        fs.createFile(name);
        fs.setFile(name, val.dup);

        auto refToFile = fs.getFile(name);
        actualEqualsExpected(refToFile, val);

        refToFile.append(val2);
        actualEqualsExpected(refToFile, val ~ val2);
        assertEqual(refToFile, fs.getFile(name));

    }
}