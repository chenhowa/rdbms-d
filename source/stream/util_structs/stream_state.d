



struct StreamState {
    private {
        bool eofbit;
        bool badbit;
        bool failbit;
    }

    this(int placeholder) {
        eofbit = false;
        badbit = false;
        failbit = false;
    }

    bool good() {
        return !badbit && !failbit;
    }

    bool eof() {
        return eofbit;
    }

    bool bad() {
        return badbit;
    }

    bool fail() {
        return failbit;
    }

    bool valid() {
        return !badbit && !failbit && !eofbit;
    }

    void setEof(bool val) {
        eofbit = val;
    }

    void setBad(bool val) {
        badbit = val;
    }

    void setFail(bool val) {
        failbit = val;
    }
}