
import i_iterator;
import i_tuple;
import i_tuple_layout;




class SortItr : IIterator {
    private {
        ITuple tuple;
        ITupleLayout layout;
        IIterator[1] inputs;
    }

    this(IIterator itr) {
        
    }

    void init() {

    }

    ITuple next() {
        return tuple;
    }

    ITupleLayout getLayout() {
        return layout;
    }

    void close() {

    }
}