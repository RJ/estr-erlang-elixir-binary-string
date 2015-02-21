# Use Elixir.String in Erlang

````estr```` is a small erlang wrapper around ````Elixir.String````.

There are some ````Elixir.String*.beam```` files precompiled in ebin/.
These were taken from an Elixir 1.0.2 build. See
https://github.com/elixir-lang

NB: don't run "rebar clean" or you'll lose the Elixir beams.

These are from Elixir 1.0.2, via erlang 17.1 (homebrew).
Only tested on 17.4.

## Look

Read the ````estr.erl```` and the Elixir.String docs for more.

    1> estr:rjust(estr:new("hello"),10).
    <<"     hello">>
    2> estr:next_codepoint(estr:new("жen")).
    {<<208,182>>,<<"en">>}


    1> S = estr:new("Джубадзе").
    <<208,148,208,182,209,131,208,177,208,176,208,180,208,183,208,181>>
    2> estr:length(S).
    8
    3> size(S).
    16
    4> io:format(estr:to_char_list(estr:upcase(S))).
    ДЖУБАДЗЕ

