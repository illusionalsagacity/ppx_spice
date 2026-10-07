// Options outside records, which upstream 0.2.2's option encoding broke (fixed in 0.4.0)
@spice
type topLevel = option<int>

@spice
type inArray = array<option<int>>

@spice
type inTuple = (option<int>, string)

@spice
type inVariant = Wrap(option<int>)
