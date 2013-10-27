-module(tree).
-export([empty/0, insert/3, lookup/2]).

empty() ->
    {node, 'nil'}.
%Nil node
insert(Key, Val, {node, 'nil'}) ->
    {node, {Key, Val, {node, 'nil'}, {node, 'nil'}}};
%Recurse into the smaller branch
insert(NewKey, NewVal, {node, {Key, Val, Smaller, Larger}}) when NewKey < Key -> 
    {node, {Key, Val, insert(NewKey, NewVal, Smaller), Larger}};
%Recurse into larger
insert(NewKey, NewVal, {node, {Key, Val, Smaller, Larger}}) when NewKey > Key -> 
    {node, {Key, Val, Smaller, insert(NewKey, NewVal, Larger)}};
%Equality
insert(Key, Val, {node, {Key, _ , Smaller, Larger}}) -> 
			 {node, {Key, Val, Smaller, Larger}}.
	 
lookup(_,{node,'nil'})->	
    undefined;
lookup(Key, {node, {Key, Val,_,_}}) ->	
    {ok,Val};
lookup(Key, {node, {NodeKey, _, Smaller, _}}) when Key < NodeKey -> 
    lookup(Key, Smaller);
lookup(Key, {node,{_,_,_,Larger}}) ->
    lookup(Key, Larger).

%% has_value(_. {node,'nil'}) -> false;
%% has_value(Val, {node, {_, Val, _, _}}) ->
%%     true;
%% has_value(Val, node, {_,_, Left, Right}}) ->
%% case has_value(Val, Left) of
%%     true -> true;
%%     false -> has_value(Val, Right)
%% end.


has_value(Val, Tree) ->
    try has_value1(Val,Tree) of
	false ->
	    false
    catch 
    true ->
	    true
    end.

has_value1(_, {node, 'nil'}) ->
    false;
has_value1(Val, {node, {_, Val, _, _}}) ->
    throw(true);
has_value1(Val, {node, {_, _, Left, Right}}) ->
    has_value1(Val, Left),
    has_value1(Val, Right).

		   
		   
