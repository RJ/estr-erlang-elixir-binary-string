%% An erlang wrapper around 'Elixir.String'
%%
%% * Proxies most Elixir.String functions, with guards for Erlang types;
%% * Changes Elixir's 'nil' responses to 'undefined';
%% * Provides a constructor for lists or existing binaries;
%% * Adds a few extra sugary bits.
%%
%% NB: Omits functions expecting Elixir.Regex or Elixir.Range.
%%
-module(estr).
-compile(export_all).

%% CONSTRUCTORS

%% @doc make a string from an erlang list
new(B) when is_binary(B) ->
    case valid(B) of
        true  -> B;
        false -> throw({invalid_estr, B})
    end;
new(String) when is_list(String) ->
    from_list(String).

from_list(String) when is_list(String) ->
    unicode:characters_to_binary(String).

%% ADDITIONAL FUNCTIONS - homemade syntactic sugar

%% @doc Compares strings case insensitively
eqi(String, Other) when is_binary(String), is_binary(Other) ->
    downcase(String) =:= downcase(Other).


%% ELIXIR TIME - all just proxies to Elixir.String functions

nil(nil) -> undefined;
nil(V)   -> V.

%% @doc Returns the grapheme in the position of the given utf8 string. If position is greater than string length, then it returns undefined
at(String, Position) when is_binary(String) ->
    nil('Elixir.String':at(String, Position)).

%% @doc Converts the first character in the given string to uppercase and the remaining to lowercase
capitalize(String) when is_binary(String) ->
    'Elixir.String':capitalize(String).

%% @doc Splits the string into chunks of characters that share a common trait
chunk(String, Trait) when is_binary(String) ->
    'Elixir.String':chunk(String, Trait).

%% @doc Returns all codepoints in the string
codepoints(String) when is_binary(String) ->
    'Elixir.String':codepoints(String).

%% @doc Check if string contains any of the given contents
contains(String, Contents) when is_binary(String), is_binary(Contents) ->
    'Elixir.String':'contains?'(String, Contents).

%% @doc Convert all characters on the given string to lowercase
downcase(String) when is_binary(String) ->
    'Elixir.String':downcase(String).

%% @doc Returns a binary subject duplicated n times
duplicate(Subject, N) when is_binary(Subject), is_integer(N), N >= 0 ->
    'Elixir.String':duplicate(Subject, N).

%% @doc Returns true if string ends with any of the suffixes given, otherwise false. suffixes can be either a single suffix or a list of suffixes
ends_with(String, Suffixes) when is_binary(String), is_binary(Suffixes) ->
    'Elixir.String':'ends_with?'(String, Suffixes).

%% @doc Returns the first grapheme from an utf8 string, undefined if the string is empty
first(String) when is_binary(String) ->
    nil('Elixir.String':first(String)).

%% @doc Returns unicode graphemes in the string as per Extended Grapheme Cluster algorithm outlined in the Unicode Standard Annex #29, Unicode Text Segmentation
graphemes(String) when is_binary(String) ->
    'Elixir.String':graphemes(String).

%% @doc Returns the last grapheme from an utf8 string, undefined if the string is empty
last(String) when is_binary(String) ->
    nil('Elixir.String':last(String)).

%% @doc Returns the number of unicode graphemes in an utf8 string
length(String) when is_binary(String) ->
    'Elixir.String':length(String).

%% @doc Returns a new string of length len with subject left justified and padded with padding. If padding is not present, it defaults to whitespace. When len is less than the length of subject, subject is returned
ljust(Subject, Len) when is_binary(Subject), is_integer(Len) ->
    'Elixir.String':ljust(Subject, Len).

ljust(Subject, Len, Padding) when is_binary(Subject), is_integer(Len), is_integer(Padding) ->
    'Elixir.String':ljust(Subject, Len, Padding).

%% @doc Returns a string where leading Unicode whitespace has been removed
lstrip(String) when is_binary(String) ->
    'Elixir.String':lstrip(String).

%% @doc Returns a string where leading char have been removed
lstrip(Other, Char) when is_binary(Other), is_integer(Char) ->
    'Elixir.String':lstrip(Other, Char).

%% @doc Check if string matches the given regular expression
%% match(String, Regex) when is_binary(String) ->
%%    'Elixir.String':'match?'(String, Regex).

%% @doc Returns the next codepoint in a String
next_codepoint(String) when is_binary(String) ->
    'Elixir.String':next_codepoint(String).

%% @doc Returns the next grapheme in a String
next_grapheme(String) when is_binary(String) ->
    'Elixir.String':next_grapheme(String).

%% @doc Checks if a string is printable considering it is encoded as UTF-8. Returns true if so, false otherwise
printable(String) when is_binary(String) ->
    'Elixir.String':'printable?'(String).


%% @doc Returns a new binary based on subject by replacing the parts matching pattern by replacement.
replace(Subject, Pattern, Replacement) when is_binary(Subject), is_binary(Pattern), is_binary(Replacement) ->
    binary:replace(Subject, Pattern, Replacement, [global]).

%% @doc Reverses the given string. Works on graphemes
reverse(String) when is_binary(String) ->
    'Elixir.String':reverse(String).

%% @doc Returns a new string of length len with subject right justified and padded with padding. If padding is not present, it defaults to whitespace. When len is less than the length of subject, subject is returned
rjust(Subject, Len) when is_binary(Subject), is_integer(Len) ->
    'Elixir.String':rjust(Subject, Len).

rjust(Subject, Len, Padding) when is_binary(Subject), is_integer(Len), is_integer(Padding) ->
    'Elixir.String':rjust(Subject, Len, Padding).

%% @doc Returns a string where trailing Unicode whitespace has been removed
rstrip(String) when is_binary(String) ->
    'Elixir.String':rstrip(String).

%% @doc Returns a string where trailing char have been removed
rstrip(String, Char) when is_binary(String), is_integer(Char) ->
    'Elixir.String':rstrip(String, Char).

%% @doc Returns a substring from the offset given by the start of the range to the offset given by the end of the range
%%slice(String, Start, End) when is_binary(String), is_integer(Start), is_integer(End) ->
%%    ElixirRange = {todo, Start, End},
%%    'Elixir.String':slice(String, ElixirRange).

%% @doc Returns a substring starting at the offset given by the first, and a length given by the second
slice(String, Start, Len) when is_binary(String) ->
    'Elixir.String':slice(String, Start, Len).

%% @doc Divides a string into substrings at each Unicode whitespace occurrence with leading and trailing whitespace ignored
split(String) when is_binary(String) ->
    'Elixir.String':split(String).

%% @doc Divides a string into substrings based on a pattern
%%      Pattern can be an Elixir.Regex but we don't support that, so patterns are strings only.
split(String, Pattern) -> split(String, Pattern, []).
split(String, Pattern, Options) when is_binary(String), is_binary(Pattern), is_list(Options) ->
    'Elixir.String':split(String, Pattern, Options).

%% @doc Splits a string into two at the specified offset. When the offset given is negative, location is counted from the end of the string
split_at(String, Offset) when is_binary(String), is_integer(Offset) ->
    'Elixir.String':split_at(String, Offset).

%% @doc Returns true if string starts with any of the prefixes given, otherwise false. prefixes can be either a single prefix or a list of prefixes
starts_with(String, Prefixes) when is_binary(String) andalso (is_binary(Prefixes) orelse is_list(Prefixes)) ->
    'Elixir.String':'starts_with?'(String, Prefixes).

%% @doc Returns a string where leading/trailing Unicode whitespace has been removed
strip(String) when is_binary(String) ->
    'Elixir.String':strip(String).

%% @doc Returns a string where leading/trailing char have been removed
strip(String, Char) when is_binary(String), is_integer(Char) ->
    'Elixir.String':strip(String, Char).

%% @doc Converts a string to an atom
to_atom(String) when is_binary(String) ->
    'Elixir.String':to_atom(String).

%% @doc Converts a string into a char list
to_char_list(String) when is_binary(String) ->
    'Elixir.String':to_char_list(String).

%% @doc Converts a string to an existing atom
to_existing_atom(String) when is_binary(String) ->
    'Elixir.String':to_existing_atom(String).

%% @doc Returns a float whose text representation is string
to_float(String) when is_binary(String) ->
    'Elixir.String':to_float(String).

%% @doc Returns a integer whose text representation is string
to_integer(String) when is_binary(String) ->
    'Elixir.String':to_integer(String).

%% @doc Returns an integer whose text representation is string in base base
to_integer(String, Base) when is_binary(String), is_integer(Base) ->
    'Elixir.String':to_integer(String, Base).

%% @doc Convert all characters on the given string to uppercase
upcase(String) when is_binary(String) ->
    'Elixir.String':upcase(String).

%% @doc Checks whether str contains only valid characters
valid(String) when is_binary(String) ->
    'Elixir.String':'valid?'(String).

%% @doc Checks whether str is a valid character
valid_character(Codepoint) ->
    'Elixir.String':'valid_character?'(Codepoint).

