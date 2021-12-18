AOC2021
=======

These are my solutions for the AOC 2021 challenge.

* Advent of Code 2021: <https://adventofcode.com/2021>.
* Instructions to join the makigas leaderboard is here: <https://discord.com/channels/329487017916366850/908859179584847874/908863589459324978>. Join link: <https://discord.gg/Mq7TBAB>

Show must go on
---------------

This year I needed a vacation and thus I am not solving the problems every day. I'm solving problems every few days.

As usual I am streaming how I solve the problems, but this year I am not broadcasting the streams through <youtube.com/makigas>, but through <twitch.tv/danirod_>. VODs are available through Twitch VOD system and also reuploaded to my second YouTube channel here: <https://www.youtube.com/playlist?list=PLf7Nw_MU4SewgNViz_W53O-eqNtYHfQXd>.

Languages
---------

I am using Ruby. Not the fastest language but I like it a lot and thus it makes me happy. Things that I've learned about Ruby thanks to this decision:

* You can early return from a map block using `next n` to go to the next iteration. `next` accepts a parameter.

Some problems were solved in Golang, when it made sense - such as Ruby being slower than acceptable. First time this happened, I decidsed to translate the algorithm to a different language and the chat proposed to rewrite it in Golang. Then the next time it happened, I used Golang again to re-use the read file + cast to int logic.

* Problem 06 - it is faster in Go
* Problem 14 - because apparently solving a dijkstra with 250000 edges is too much for Ruby.

Problem 07 was solved in Microsoft Excel and thus the folder 07 contains an XLSX file.

I would want to solve them in Haskell but I could not care less about monads, so I am sorry.
