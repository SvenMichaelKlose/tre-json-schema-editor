Development diary
=================

Sven Michael Klose <pixel@hugbox.org>

# 11 NOV 2023

React has renamed DOM attributes to 'properties', the items
in a JavaScript object.  Combined with the 'props' member
variable of a component confusion is guaranteed.  Accordingly
I'll rename LML-COMPONENT constructor argument to 'attrs'
while still keeping member variables unnamed.

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
