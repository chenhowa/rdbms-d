
import i_tuple_layout;
import e_datatype;
import i_layout;
import std.array;
import std.conv;
import i_layout_builder;

class TupleLayout : ITupleLayout, ILayoutBuilder {
    private {
        ILayout[] layouts;
    }

    this() {
        layouts = new ILayout[10];
    }

    // ITupleLayout
    uint getTupleLength() {
        return castFrom!ulong.to!uint(layouts.length);
    }

    DataType getType(uint index) {
        return layouts[index].getType();
    }

    uint getEntryLength(uint index) {
        return layouts[index].getEntryLength();
    }

    // ILayoutBuilder
    void addLayout(ILayout layout) {
        layouts ~= layout;
    }

}