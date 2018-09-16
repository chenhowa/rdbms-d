
import as = assert_utils;


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

    unittest {
        auto state = StreamState();
        as.assertTrue(state.valid());
        as.assertTrue(state.good());
        as.assertFalse(state.eof());

        state.setBad(true);
        as.assertFalse(state.good());
        as.assertFalse(state.valid());

        state.setBad(false);
        state.setEof(true);
        as.assertTrue(state.good());
        as.assertFalse(state.valid());
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