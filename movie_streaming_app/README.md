# movie_streaming_app

Zdeněk Vaníček - Entrance test


Time spent:

19.2. 4h - Exploring the project, connecting the phone to endpoint, retrieving containers sizes from tree

26.2 9-12h - Getting position and size from all widgets, getting color of most widgets.
Exploring the tree and its values deeply.
Checking serialization

27.2. 9-12h -  Making avg color of image.
Thinking about solution to get all colors from one common widget/class.
Finding out how to recognize only visible widgets (would love to spent more time on it if possible)

Total time about 3MD

Honestly this problem is complex and I think that in 3 days of work it is quite hard to make elegant solution for this task.
On analysis of solutions that are fast, elegant and primarily easy to maintain it is easy to spent week or more.
This result is just kind of MVP, and Im not happy with the result.
Hopefully you will at least like the way I looked into the problems.
I did not spend more time than 3 days because on week days I had full time job, and last weekend I had only one free day.
If you think that my problem solving is worth of considering but the work is not finished as much as you wanted,
I can try to look more into it throughout this week.

Sincerely Zdeněk Vaníček


The solution

I decided to treat every widget independently because its getters for color varies.
If this task was meant to be done as a package for logging purposes all the widgets would
have to be tested independently. I hope that I did not miss something these widgets have in common
for color so I could make it easier. The size and position was quite easy task because every element
has its size and position easily obtained. The only place I could not find out how to find
the position of element was RichText, there are multiple TextSpans share the RichText size and pos.

Native way might be also possibility to solve this but I did not try it due to time limitations.


Things I wish to do but did not make in time:

1. Check visibility of active widget (checking just if the offset is inside would not help, because of opacity, offstage and other screens)

2. Check null values and act accordingly, some text or icons has no color, probably checked wrong child

3. Try on iOS

4. Check speed and make optimizations.



Few things I would change in normal project:

1. Add null safety (did not do because some dependencies do not support it and bumping it up would change the logic of the testing views)

2. Add Built value for serialization - for this project it would be too massive tool

3. Mark the widgets as const - but the widgets are for testing purposes and it is supposed to mimic app of customer

4. Change the functions that return widget to stles widget - it is  not code effective for rebuilds,
   flutter has to rebuild every time parent rebuilds - flutter cant use keys to remember it is the same widget



