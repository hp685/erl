-module(useless).
-export([add/2, hello/0, greet_and_add_two/1]).
-vsn(1).
add(A,B) ->
	 A + B.

%This is a comment
hello() ->
	io:format("Hellom world!~n").

greet_and_add_two(X) ->
    hello(),
    add(X,2).
