
-module(records).
-compile(export_all).
-include("records.hrl").
included() ->
    #included{some_field="Some value"}.

-record(user, {id, name, group, age}).



%pattern matching to filter
admin_panel(#user{name=Name, group=admin}) ->
    Name ++ "is allowed!";
admin_panel(#user{name=Name}) ->
    Name ++ "is not allowed".

%can extend user without problems
adult_section(U = #user{}) when U#user.age >= 18 ->
    allowed;
adult_section(_) ->
    forbidden.
    



-record(robot, {name,
		type=industrial,
		hobbies,
		details=["foobar"]}).
first_robot() ->
    #robot{name="Mechatron",
	   type=handmade,
	   details=["Moved by a small man inside"]}.

car_factory(CorpName) ->
    #robot{name=CorpName, hobbies="building cars"}.

repairman(Rob) ->
    Details = Rob#robot.details,
    NewRob = Rob#robot{details=["Repaired by repairman" | Details]},
    {repaired, NewRob}.
