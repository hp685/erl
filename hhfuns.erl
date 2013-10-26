
-module(hhfuns).
-compile(export_all).


one() ->
    1.
two() ->
    2.
add(X,Y) ->
    X() + Y().

increment([]) ->
    [];
increment([H|T]) ->[H+1|increment(T)].

decrement([]) ->
    [];
decrement([H|T]) -> [H-1|decrement(T)].


map(_,[])->
    [];
map(F,[H|T]) ->[F(H)|map(F,T)].

incr(X) ->
    X + 1.
decr(X) ->
    X - 1.

%Keep a list of even numbers only
%Reverse the list first using the built-in "efficient" lists reverse
even(L) ->
    lists : reverse(even(L,[])).
even([],Acc) ->
    Acc;
even([H|T],Acc) when H rem 2 == 0 ->
    even(T,[H|Acc]);
even([_|T],Acc) -> even(T,Acc).

% Generic 
% Can be used with inline anonymous functions
filter(Pred, L )->
    lists:reverse(filter(Pred,L,[])).

filter(_,[],Acc) ->
    Acc;
filter(Pred,[H|T],Acc) ->
    case Pred(H) of
	true ->
	    filter(Pred, T, [H|Acc]);
	false ->
	    filter(Pred, T, Acc)
    end.
%Reducers or "Folds"
%Max
max([H|T]) ->
     max2(T,H).

max2([],Max) ->
    Max;
max2([H|T], Max) when H > Max -> max2(T,H);
max2(_, Max) -> max2(T,Max).

 
%sum

sum(L) ->
     sum(L,0).
sum([],Sum) ->
    Sum;
sum([H|T], Sum) -> sum(T,H+Sum).

%Generic fold
%Need a "start" for folds
fold(_, Start, []) ->
    Start;
fold(F,Start,[H|T]) -> 
    fold(F, F(H,Start),T).


