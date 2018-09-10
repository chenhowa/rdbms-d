
import i_tuple;
import i_tuple_layout;

interface IIterator {

    void init();
    ITuple next();
    ITupleLayout getLayout();
    void close();
}