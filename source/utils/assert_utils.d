

import std.traits;
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

void assertThrow() {
    // TODO : WRITE A TEMPLATE THAT ACCEPTS ANY FUNCTION
    // CALLS IT, and FAILS ONLY IF THE FUNCTION doesn't THROW
}

void assertNoThrow() {
    // TODO : WRITE A TEMPLATE THAT ACCEPTS ANY FUNCTION
    // CALLS IT, and FAILS ONLY IF THE FUNCTION THROWS
}