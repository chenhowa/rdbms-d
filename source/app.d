import std.stdio;
import i_iterator;
import poodinis;
import i_tuple_layout;
import tuple_layout;

void main()
{
	auto dependencies = new shared DependencyContainer();
	dependencies.register!(ITupleLayout, TupleLayout).newInstance();
}
