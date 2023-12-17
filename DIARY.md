Development diary
=================

Sven Michael Klose <pixel@hugbox.org>

# 16 DEC 2023 14:02

Aside from Lisp symbols being upper cased by default there
is another thing messing up the mix: 'false'.  There is no
boolean FALSE in Common LISP.  And no other Lisp dialect
I know of yet.  So predicate NOT will return T for both
NIL and FALSE.   An (EQ X NIL) is in order to check for
NIL.

However: the autoform section will require an update to
JSON Schema, not that ancient proprietary one.

# 15 DEC 2023 21:07

Am thinking about turning the schema nodes into objects
that behave like database records and can update their
origins independently from the LML components.  That brings
the thing back to the already existing STORE objects.  The
latter should perhaps not be "connected" to the
LML-COMPONENTs that use them – there must have been some
confusion.  Accordingly I'll redo that from scratch.

It finally came to me what I really want: an editor with
the schema editor integrated alongside.

# 15 DEC 2023

TRE symbol case will remain for the duration and there will
be no literal JSON splicing syntax.  Would love to see
overloading REF for JSON objects.

# 11 NOV 2023

React has renamed DOM attributes to 'properties', the items
in a JavaScript object.  Combined with the 'props' member
variable of a component confusion is guaranteed.  Accordingly
I'll rename LML-COMPONENT constructor argument to 'attrs'
while still keeping member variables unnamed.

QUASIQUOTE-SPLICE (',@') now turns JSON objects into keyword/
value lists to splice them as function and LML arguments.

# 10 NOV 2023

There hasn't been done much for the tré programming language
during the last four years mainly because I chose to engage
in non-IT activities alongside a full-time job as a full-
stack software developer.  Now, with revived spirits, it's
time to continue to grow something beatiful.

And for now that tré's LML-COMPONENT which is inspired by
the React frameworks.  Starting off easy, the general JSON
Schema type views are about to get implemented.  For now we
have strings and objects to which properties can be added,
leaving us with missing numbers, arrays and booleans.
