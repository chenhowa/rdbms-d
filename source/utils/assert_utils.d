

import std.traits;
import i_stringable;
import std.conv;




void actualEqualsExpected(T)(T actual, T expected)
{
    if(actual != expected) {
        throw new Exception("Got " ~ to!string(actual) ~ ", but expected " ~ to!string(expected) );
    }
}

void assertEqual(T)(T a, T b) {
    if(a != b) {
        throw new Exception(to!string(a) ~ " did not equal " ~ to!string(b));
    }
}

void assertNotEqual(T)(T a, T b) {
    if( a == b) {
        throw new Exception(to!string(a) ~ " did equal " ~ to!string(b));
    }
}

void assertTrue(bool cond) {
    actualEqualsExpected(cond, true);
}

void assertFalse(bool cond) {
    actualEqualsExpected(cond, false);
}
