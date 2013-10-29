-module(linkmon).
-compile(export_all).

myproc() ->
    timer:sleep(5000),
    exit(reason).

chain(0) ->
    receive
	_ ->
	     ok
    after 2000 ->
	    exit("Chain ends here")
    end;
chain(N) ->
    Pid = spawn(fun() ->
			chain(N-1) end),
    link(Pid),
    receive
	_ ->
	    ok
    end.

start_critic() ->
    spawn(?MODULE, critic, []).

%Neat interface for process communication
judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
	{Pid, Criticism} ->
	    Criticism
    after 2000 ->
	timeout
    end.

critic() ->
    receive
	{From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
	    From ! {self(), "They're great!"};
	{From, {"System of a Downtime", "Memoize"}} ->
	    From ! {self(), "They're not Johnny Cash but they're
    good."};
	{From, {"Johnny Crash", "The Token Ring of Fire"}} ->
	    From ! {self(), "Simply incredible."};
	{From, {_Band, _Album}} ->
	    From ! {self(), "They're just horrible!"}
    end,
    %Keep doing the above
    critic().

start_critic2() ->
    spawn(?MODULE, restarter, []).

% A supervisor to ensure that the process is up
restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic2, []),
    register(critic, Pid),
    receive
	{'EXIT', Pid, normal} ->
	    ok;
	%Manual Termination
	{'EXIT', Pid, shutdown} ->
	    ok;
	{'EXIT', Pid, _ } ->
	    restarter()
    end.


judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! { self(), Ref, {Band, Album}},
    receive
	{Ref, Criticism} ->
	    Criticism
    after 2000 ->
	    timeout
    end.

critic2() ->
    receive
	{From, Ref, {"Rage Against the Turing Machine", "Unit
    Testify"}} ->
	    From ! {Ref, "They're great!"};
	{From, Ref, {"System of a downtime", "Memoize"}} ->
	    From ! {Ref, "They're not Johnny Crash but they're
    good."};
	{From, Ref, {"Johnny Crash", "The token ring of fire"}} ->
	    From ! {Ref, "Simply incredible."};
	{From, Ref, {_Band, _Album}} ->
	    From ! {Ref, "They're just horrible"}
    end,
    critic2().





