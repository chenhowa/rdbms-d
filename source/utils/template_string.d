// module template_strings;

import std.array;
import as = assert_utils;
import std.conv;

class String(T) {
private {
    T[] str;
}

this() {
    str = [];
}

this(T[] arr) {
    str = arr.dup;
}

this(immutable(T)[] arr) {
    str = arr.dup;
}

unittest {
    char[] chars = ['a', 'b', 'c'];
    int[] ints = [1, 2, 3, 4];

    String!char char_string = new String!char(chars);
    String!int int_string = new String!int(ints);

    as.actualEqualsExpected(char_string.length(), 3);
    as.actualEqualsExpected(char_string.getArrayCopy(), chars);
    as.actualEqualsExpected(int_string.length(), 4);
    as.actualEqualsExpected(int_string.getArrayCopy(), ints);
}


void append(T[] arr) {
    str = str ~ arr;
}

void append(String!T other) {
    append(other.str);
}

unittest {
    char[] chars = ['a'];
    char[] chars2 = ['b', 'c'];

    auto c_string = new String!char(chars);

    c_string.append(chars2);
    as.actualEqualsExpected(c_string.getArrayCopy(), chars ~ chars2);

    c_string = new String!char(chars);
    auto c_string_2 = new String!char(chars2);
    c_string.append(c_string_2);
    as.actualEqualsExpected(c_string.getArrayCopy(), chars ~ chars2);
}

void prepend(T[] arr) {
    str = arr ~ str;
}

void prepend(String!T other) {
    prepend(other.str);
}

unittest {
    char[] chars = ['z'];
    char[] chars2 = ['x', 'y'];

    auto c_string = new String!char(chars);
    c_string.prepend(chars2);
    as.actualEqualsExpected(c_string.getArrayCopy(), chars2 ~ chars);

    c_string = new String!char(chars);
    auto c_string_2 = new String!char(chars2);
    c_string.prepend(c_string_2);
    as.actualEqualsExpected(c_string.getArrayCopy(), chars2 ~ chars);
}

/*
void insert(size_t index, T element) {
    str.insertInPlace(index, element);
}
*/

void insert(size_t index, T[] elements ...) {
    str.insertInPlace(index, elements);
}

void insert(size_t index, String!T other) {
    str.insertInPlace(index, other.str);
}

unittest {
    char[] chars = ['a', 'c'];
    auto c_string = new String!char(chars);
    c_string.insert(1, 'b');

    as.actualEqualsExpected(c_string.getArrayCopy(), ['a', 'b', 'c']);

    c_string.insert(1, new String!char(['q']));
    as.actualEqualsExpected(c_string.getArrayCopy(), ['a', 'q', 'b', 'c']);
}

size_t length() {
    return str.length;
}

String!T opBinary(string op)(String!T rhs) {
    static if(op == "~") {
        return new String(str ~ rhs.str);
    } else static assert(0, "Operator " ~ op ~ " not implemented");
}

unittest {
    char[] chars = ['a', 'b', 'c'];
    auto c_string = new String!char(chars);
    auto c_string_2 = new String!char(chars);
    auto combined_string = c_string ~ c_string_2;

    as.actualEqualsExpected(combined_string.length(), 2 * chars.length);
    as.actualEqualsExpected(combined_string.getArrayCopy(), chars ~ chars);
}


override bool opEquals(Object o) {
    if(auto s = cast(typeof(this) ) o) {
        if(this.length() != s.length()) {
            return false;
        }

        if(str == s.str) {
            return true;
        }

        return false;
    }

    return false;
}

unittest {
    char [] chars = ['a'];
    char [] chars_2 = ['b', 'c'];

    auto c_string = new String!char(chars);
    auto c_string2 = new String!char(chars);

    as.assertTrue(c_string == c_string2);
    c_string.append(chars_2);
    as.assertFalse(c_string == c_string2);
    c_string2.append(chars_2);
    as.assertTrue(c_string == c_string2);
}

T[] getArrayCopy() {
    return str.dup;
}

@property
String!T dup() {
    return new String!T(str.dup);
}

override string toString() const pure @safe {
    auto app = appender!string();
    app ~= "[ ";
    foreach(T item; str) {
        app ~= to!string(item) ~ " ";
    }

    app ~="]";

    return app.data;
}

}



unittest {
    String!char test = new String!char();
}