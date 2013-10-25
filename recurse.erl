-module(recurse).
-export([len/1, tail_fac/1, reverse/1, sublist/2, lenient_zip/2]).

len([]) ->
    0;
len([_|T]) -> 1 + len(T).


tail_fac(N) ->
    tail_fac(N,1).

tail_fac(0,Acc) ->
    Acc;
tail_fac(N,Acc)  when N > 0 ->
    tail_fac(N-1,N*Acc).

% n^2 : n elements
reverse([]) ->
    [];
reverse([H|T]) ->reverse(T) ++ [H].

%tail recurse -- linear 
%'cause of the structure of the 
tail_reverse(L) ->
    tail_reverse(L,[]).
tail_reverse([],Acc)->
    Acc;
tail_reverse([H|T],Acc) ->tail_reverse(T,[H|Acc]).

sublist(_,0) ->
    [];
sublist([],_) ->[];
sublist([H|T],N) when N > 0 -> [H|sublist(T,N-1)].


lenient_zip([], _) ->
    [];
lenient_zip(_,[]) -> [];
lenient_zip([X|Xs],[Y|Ys]) ->[{X,Y} | lenient_zip(Xs,Ys)]. 
