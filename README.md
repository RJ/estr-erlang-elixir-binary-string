# Use Elixir.String from Erlang

`estr` is an Erlang adaptor for Elixir.String, 

Elixir strings are UTF-8 encoded binaries.
Read the [docs for Elixir.String](https://hexdocs.pm/elixir/String.html) to know more.

`estr` bundles a few select `.beam` files from Elixir, and provides a more
Erlangy API.
These Elixir beam files were taken from an Elixir 1.4.0 build on 64-bit Ubuntu Linux,
circa Feb. 2017.

I have only tested this with Erlang 19.2. It probably works with earlier versions.

## Usage

You can include this as you would any dep, and have utf8 binary strings in your erlang.

The `estr` application has no processes or supervisors.

    $ rebar3 shell

    1> estr:new("Hello").
    <<"Hello">>
    2> estr:new(<<"Hello">>).
    <<"Hello">>
    3> estr:next_codepoint(estr:new("жen")).
    {<<208,182>>,<<"en">>}
    4> S = estr:new("Джубадзе").
    <<208,148,208,182,209,131,208,177,208,176,208,180,208,183,208,181>>
    5> estr:length(S).
    8
    6> size(S).
    16
    7> io:format(estr:to_char_list(estr:upcase(S))).
    ДЖУБАДЗЕ


## Smoke Test

To check `estr` can call Elixir.String without crashing:

    rebar3 eunit

