

import e_datatype;

interface ITupleLayout {
    uint getTupleLength();
    DataType getType(uint index);
    uint getEntryLength(uint index);
}