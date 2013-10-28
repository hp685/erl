-module(kitchen).
-compile(export_all).

%
fridge1() ->
    receive
	{From, {store, _Food}} ->
	    From ! {self(), ok},
	    fridge1();
	{From, {take, _Food}} ->
	    From ! {self(), not_found},
	    fridge1();
	terminate ->
	    ok
    end.

% Saving process state
fridge2(FoodList) ->
    receive
	%Format of message being received
	{From, {store, Food}} ->
	    From ! {self(), ok},
	    fridge2([Food|FoodList]);
	{From, {take, Food}} ->
	      case lists:member(Food, FoodList) of
		  true ->
		      From ! {self(), {ok, Food}},
		      fridge2(lists:delete(Food,FoodList));
		  false  ->
		      From ! {self(), not_found},
		      fridge2(FoodList)
	      end;
	terminate ->
	    ok
    end.

% doing away with process protocols

store(Pid, Food) ->
    % Has to have the same format as in fridge2
    Pid ! {self(), {store, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    end.

take(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    end.

start(FoodList) ->
    % ?MODULE is a macro that returns the current module's name
    spawn(?MODULE, fridge2, [FoodList]).

%Handling timeouts
store2(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    after 3000 ->
	    timeout
    end.

take2(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    after 3000 ->
	    timeout
    end.



