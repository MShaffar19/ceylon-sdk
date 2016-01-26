"Produces the [[stream|ceylon.language::Iterable]] that results from repeated
 calls to the given [[function|next]]. The stream is infinite.

 This function produces a result similar to:

     { next() }.cycled
 "
shared deprecated("experimental; use [[Iterable.cycled]] instead.")
suppressWarnings("deprecation")
InfiniteStream<Element> stream<Element>(
        "The function that produces the next element of the stream."
        Element next()) {

    value paramNext = next;
    object it satisfies InfiniteStream<Element> & InfiniteIterator<Element> {
        shared actual
        InfiniteIterator<Element> iterator() => this;

        shared actual
        Element next() => paramNext();

        shared actual
        Element first => paramNext();

        shared actual
        InfiniteStream<Element> rest => this;
    }
    return it;
}

shared deprecated("experimental")
suppressWarnings("deprecation")
interface InfiniteStream<Element>
        satisfies {Element+} {

    shared actual formal
    InfiniteStream<Element> rest;

    shared actual formal
    InfiniteIterator<Element> iterator();
}

shared deprecated("experimental")
interface InfiniteIterator<Element>
        satisfies Iterator<Element> {

    shared actual formal
    Element next();
}