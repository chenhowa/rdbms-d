

import filesystem;
import i_filesystem;


__gshared IFileSystem g_filesystem;

static this() {
    g_filesystem = new FileSystem();
    g_filesystem.reset();
}