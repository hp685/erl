-module(event).
-compile(export_all).
%Maintain state information
-record(state, {server,
		name="",
		to_go=0}).

loop(S = #state{server=Server, to_go=[T|Next]}) ->
    receive
	{Server, Ref, cancel} ->
	    Server ! {Ref, ok}
    after T*1000 ->
	    if Next =:= [] ->
		    Server ! {done, S#state.name};
	       Next =/= []  ->
		    loop(S#state{to_go=Next})
	    end
	    %% after S#state.to_go*1000 ->
	    %% 	    Server ! {done, S#state.name}
    end.

%Get around the 49 day limit problem
normalize(N) ->
    Limit = 49*24*60*60,
    [N rem Limit | lists:duplicate(N div Limit, Limit)].

%Interface to spawn a process
start(EventName, Delay) ->
    spawn(?MODULE, init, [self(), EventName, Delay]).
%Linking
start_link(EventName, Delay) ->
    spawn_link(?MODULE, init, [self(), EventName, Delay]).

init(Server, EventName, Delay) ->
    loop(#state{server=Server,
		name=EventName,
		to_go=normalize(Delay)}).


cancel(Pid) ->
    Ref = erlang:monitor(process, Pid),
    Pid ! {self(), Ref, cancel},
    receive
	{Ref, ok} ->
	    erlang:demonitor(Ref, [flush]),
	    ok;
	{'DOWN', Ref, process, Pid, _Reason} ->
	    ok
    end.

% Erlang's datetime {{Year, Month, Day}, {Hour, Minute, Second}}
time_to_go(Timeout={{_, _, _}, {_, _, _}}) ->
    Now = calendar:local_time(),
    ToGo = calendar:datetime_to_gregorian_seconds(TimeOut) -
	calendar:datetime_to_gregorian_seconds(Now),
    Secs = if ToGo > 0 ->
		   ToGo;
	      ToGo =< 0 -> 0
	   end,
    normalize(Secs).


