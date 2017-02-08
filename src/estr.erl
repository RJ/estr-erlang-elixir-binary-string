-module(estr).
-ifdef(EUNIT).
-include_lib("eunit/include/eunit.hrl").
-endif.
-export([
        new/1
    ,   at/2
    ,   capitalize/1
    ,   chunk/2
    ,   codepoints/1
    ,   contains/2
    ,   downcase/1
    ,   duplicate/2
    ,   ends_with/2
    ,   ends_with_any/2
    ,   eqi/2
    ,   first/1
    ,   graphemes/1
    ,   is_printable/1
    ,   is_valid/1
    ,   last/1
    ,   length/1
    ,   lstrip/1
    ,   lstrip/2
    ,   next_codepoint/1
    ,   next_grapheme/1
    ,   normalize/2
    ,   pad_leading/2
    ,   pad_leading/3
    ,   pad_trailing/2
    ,   pad_trailing/3
    ,   replace/3
    ,   replace_leading/3
    ,   replace_prefix/3
    ,   replace_suffix/3
    ,   replace_trailing/3
    ,   reverse/1
    ,   rstrip/1
    ,   rstrip/2
    ,   slice/3
    ,   split/1
    ,   split/2
    ,   split/3
    ,   split_at/2
    ,   split_by_any/2
    ,   split_by_any/3
    ,   split_by_re/2
    ,   split_by_re/3
    ,   starts_with/2
    ,   starts_with_any/2
    ,   strip/1
    ,   strip/2
    ,   to_char_list/1
    ,   upcase/1
]).

-type estr()        :: binary().
-type grapheme()    :: binary().
-type codepoint()   :: binary().
-type trait()       :: printable | valid.

%% CONSTRUCTOR

%% @doc make a string from an erlang list or binary
-spec new(binary() | estr() | list()) -> estr().
new(B) when is_binary(B) ->
    B;
new([]) ->
    <<>>;
new(String = [C1|_]) when is_list(String), is_integer(C1) ->
    unicode:characters_to_binary(String).

%% ADDITIONAL FUNCTIONS - homemade syntactic sugar

%% @doc Compares strings case insensitively
eqi(String, Other) when is_binary(String), is_binary(Other) ->
    downcase(String) =:= downcase(Other).

%% PRIVATE HELPER FUNS

nil(nil) -> undefined;
nil(V)   -> V.

%% MAIN API, copied from Elixir.String, with a few erlangifications.

%% @doc Returns the grapheme in the position of the given utf8 string. If position is greater than string length, then it returns undefined
%%      Negative offsets count back from the end of the string.
-spec at(estr(), integer()) -> grapheme() | undefined.
at(String, Position) when is_binary(String) ->
    nil('Elixir.String':at(String, Position)).

%% @doc Converts the first character in the given string to uppercase and the remaining to lowercase
-spec capitalize(estr()) -> estr().
capitalize(String) when is_binary(String) ->
    'Elixir.String':capitalize(String).

%% @doc Converts all characters in String to Unicode normalization form identified by Form.
%% The supported forms are:
%%   nfd - Normalization Form Canonical Decomposition.
%%         Characters are decomposed by canonical equivalence, and multiple
%%         combining characters are arranged in a specific order.
%%   nfc - Normalization Form Canonical Composition.
%%         Characters are decomposed and then recomposed by canonical equivalence.
-spec normalize(estr(), nfd | nfc) -> estr().
normalize(String, Form) when is_binary(String) andalso (Form =:= nfd orelse Form =:= nfc) ->
    'Elixir.String':normalize(String, Form).

%% @doc Splits the string into chunks of characters that share a common trait
-spec chunk(estr(), trait()) -> [estr()].
chunk(String, Trait) when is_binary(String) ->
    'Elixir.String':chunk(String, Trait).

%% @doc Returns all codepoints in the string
-spec codepoints(estr()) -> [codepoint()].
codepoints(String) when is_binary(String) ->
    'Elixir.String':codepoints(String).

%% @doc Check if string contains any of the given contents
-spec contains(estr(), estr()) -> boolean().
contains(String, Contents) when is_binary(String), is_binary(Contents) ->
    'Elixir.String':'contains?'(String, Contents).

%% @doc Convert all characters on the given string to lowercase
-spec downcase(estr()) -> estr().
downcase(String) when is_binary(String) ->
    'Elixir.String':downcase(String).

%% @doc Returns a binary subject duplicated n times
-spec duplicate(estr(), non_neg_integer()) -> estr().
duplicate(Subject, N) when is_binary(Subject), is_integer(N), N >= 0 ->
    'Elixir.String':duplicate(Subject, N).

%% @doc Returns true if string ends with any of the suffixes given, otherwise false. suffixes can be either a single suffix or a list of suffixes
-spec ends_with(estr(), estr()) -> boolean().
ends_with(String, Suffix) when is_binary(String), is_binary(Suffix) ->
    'Elixir.String':'ends_with?'(String, Suffix).

%% @doc Returns true if string ends with any of the suffixes given, otherwise false. suffixes can be either a single suffix or a list of suffixes
-spec ends_with_any(estr(), [estr()]) -> boolean().
ends_with_any(String, Suffixes = [S1|_]) when is_binary(String), is_binary(S1) ->
    'Elixir.String':'ends_with?'(String, Suffixes).

%% @doc Returns the first grapheme from an utf8 string, undefined if the string is empty
-spec first(estr()) -> grapheme() | undefined.
first(String) when is_binary(String) ->
    nil('Elixir.String':first(String)).

%% @doc Returns unicode graphemes in the string as per Extended Grapheme Cluster algorithm outlined in the Unicode Standard Annex #29, Unicode Text Segmentation
-spec graphemes(estr()) -> [grapheme()].
graphemes(String) when is_binary(String) ->
    'Elixir.String':graphemes(String).

%% @doc Returns the last grapheme from an utf8 string, undefined if the string is empty
-spec last(estr()) -> grapheme() | undefined.
last(String) when is_binary(String) ->
    nil('Elixir.String':last(String)).

%% @doc Returns the number of unicode graphemes in an utf8 string
-spec length(estr()) -> non_neg_integer().
length(String) when is_binary(String) ->
    'Elixir.String':length(String).

%% @doc Returns a new string of length len with subject left justified and padded with padding. If padding is not present, it defaults to whitespace. When len is less than the length of subject, subject is returned
-spec pad_leading(estr(), non_neg_integer()) -> estr().
pad_leading(Subject, Len) when is_binary(Subject), is_integer(Len), Len >= 0 ->
    'Elixir.String':pad_leading(Subject, Len).

-spec pad_leading(estr(), non_neg_integer(), binary()) -> estr().
pad_leading(Subject, Len, Padding) when is_binary(Subject), is_integer(Len), is_binary(Padding), Len >= 0 ->
    'Elixir.String':pad_leading(Subject, Len, Padding).

%% @doc Returns a string where leading Unicode whitespace has been removed
-spec lstrip(estr()) -> estr().
lstrip(String) when is_binary(String) ->
    'Elixir.String':lstrip(String).

%% @doc Returns a string where leading char have been removed
-spec lstrip(estr(), non_neg_integer()) -> estr().
lstrip(Other, Char) when is_binary(Other), is_integer(Char), Char >= 0 ->
    'Elixir.String':lstrip(Other, Char).

%% @doc Check if string matches the given regular expression
%% match(String, Regex) when is_binary(String) ->
%%    'Elixir.String':'match?'(String, Regex).

%% @doc Returns the next codepoint in a String
-spec next_codepoint(estr()) -> {codepoint(), estr()}.
next_codepoint(String) when is_binary(String) ->
    'Elixir.String':next_codepoint(String).

%% @doc Returns the next grapheme in a String
-spec next_grapheme(estr()) -> {grapheme(), estr()}.
next_grapheme(String) when is_binary(String) ->
    'Elixir.String':next_grapheme(String).

%% @doc Checks if a string is printable considering it is encoded as UTF-8. Returns true if so, false otherwise
-spec is_printable(estr()) -> boolean().
is_printable(String) when is_binary(String) ->
    'Elixir.String':'printable?'(String).

%% @doc Returns a new binary based on subject by replacing the parts matching pattern by replacement.
-spec replace(estr(), estr(), estr()) -> estr().
replace(Subject, Pattern, Replacement) when is_binary(Subject), is_binary(Pattern), is_binary(Replacement) ->
    binary:replace(Subject, Pattern, Replacement, [global]).

%% @doc Replaces all leading occurrences of match by replacement of match in string.
-spec replace_leading(estr(), estr(), estr()) -> estr().
replace_leading(String, Match, Replacement) when is_binary(String), is_binary(Match), is_binary(Replacement), Match =/= <<>> ->
    'Elixir.String':replace_leading(String, Match, Replacement).

%% @doc Replaces all trailing occurrences of match by replacement of match in string.
-spec replace_trailing(estr(), estr(), estr()) -> estr().
replace_trailing(String, Match, Replacement) when is_binary(String), is_binary(Match), is_binary(Replacement), Match =/= <<>> ->
    'Elixir.String':replace_trailing(String, Match, Replacement).

%% @doc Replaces prefix in string by replacement if it matches match.
%% Returns the string untouched if there is no match.
%% If match is an empty string (""), replacement is just prepended to string.
-spec replace_prefix(estr(), estr(), estr()) -> estr().
replace_prefix(String, Match, Replacement) when is_binary(String), is_binary(Match), is_binary(Replacement) ->
    'Elixir.String':replace_prefix(String, Match, Replacement).

%% @doc Replaces suffix in string by replacement if it matches match.
%% Returns the string untouched if there is no match.
%% If match is an empty string (""), replacement is just appended to string.
-spec replace_suffix(estr(), estr(), estr()) -> estr().
replace_suffix(String, Match, Replacement) when is_binary(String), is_binary(Match), is_binary(Replacement) ->
    'Elixir.String':replace_suffix(String, Match, Replacement).


%% @doc Reverses the given string. Works on graphemes
-spec reverse(estr()) -> estr().
reverse(String) when is_binary(String) ->
    'Elixir.String':reverse(String).

%% @doc Returns a new string of length len with subject right justified and padded with padding. If padding is not present, it defaults to whitespace. When len is less than the length of subject, subject is returned
-spec pad_trailing(estr(), non_neg_integer()) -> estr().
pad_trailing(Subject, Len) when is_binary(Subject), is_integer(Len), Len >= 0 ->
    'Elixir.String':pad_trailing(Subject, Len).

-spec pad_trailing(estr(), non_neg_integer(), binary()) -> estr().
pad_trailing(Subject, Len, Padding) when is_binary(Subject), is_integer(Len), is_binary(Padding), Len >= 0 ->
    'Elixir.String':pad_trailing(Subject, Len, Padding).

%% @doc Returns a string where trailing Unicode whitespace has been removed
-spec rstrip(estr()) -> estr().
rstrip(String) when is_binary(String) ->
    'Elixir.String':rstrip(String).

%% @doc Returns a string where trailing char have been removed
-spec rstrip(estr(), non_neg_integer()) -> estr().
rstrip(String, Char) when is_binary(String), is_integer(Char), Char >= 0 ->
    'Elixir.String':rstrip(String, Char).

%% @doc Returns a substring from the offset given by the start of the range to the offset given by the end of the range
%%slice(String, Start, End) when is_binary(String), is_integer(Start), is_integer(End) ->
%%    ElixirRange = {todo, Start, End},
%%    'Elixir.String':slice(String, ElixirRange).

%% @doc Returns a substring starting at the offset given by the first, and a length given by the second
%%      if offset is negative, count back from end of string.
-spec slice(estr(), integer(), non_neg_integer()) -> estr().
slice(String, Start, Len) when is_binary(String) andalso
                               is_integer(Start) andalso
                               is_integer(Len) andalso
                               ( (Start >= 0 andalso Len >= Start)
                                 orelse
                                 (Start < 0 andalso Len >= 0)
                               ) ->
    'Elixir.String':slice(String, Start, Len).

%% @doc Divides a string into substrings at each Unicode whitespace occurrence with leading and trailing whitespace ignored
-spec split(estr()) -> [estr()].
split(String) when is_binary(String) ->
    'Elixir.String':split(String).

%% @doc Divides a string into substrings based on an estr pattern
-spec split(estr(), estr()) -> [estr()].
split(String, Pattern) ->
    split(String, Pattern, []).
split(String, Pattern, Options) when is_binary(String), is_binary(Pattern), is_list(Options) ->
    'Elixir.String':split(String, Pattern, Options).

%% @doc Divides a string into substrings based on a list of estr patterns
-spec split_by_any(estr(), [estr()]) -> [estr()].
split_by_any(String, Patterns) ->
    split_by_any(String, Patterns, []).
split_by_any(String, Patterns = [P1|_], Options) when is_binary(String), is_binary(P1), is_list(Options) ->
    'Elixir.String':split(String, Patterns, Options).

%% @doc Divides a string into substrings based on a regex (compiles using re)
-spec split_by_re(estr(), binary()) -> [estr()].
split_by_re(String, Pattern) ->
    split_by_re(String, Pattern, []).
split_by_re(String, Pattern, Options) when is_binary(String), is_list(Options) ->
    {ok, Re} = 'Elixir.Regex':compile(estr:new(Pattern)),
    'Elixir.String':split(String, Re, Options).

%% @doc Splits a string into two at the specified offset. When the offset given is negative, location is counted from the end of the string
-spec split_at(estr(), integer()) -> {estr(), estr()}.
split_at(String, Offset) when is_binary(String), is_integer(Offset) ->
    'Elixir.String':split_at(String, Offset).

%% @doc Returns true if string starts with Prefix
-spec starts_with(estr(), estr()) -> boolean().
starts_with(String, Prefix) when is_binary(String), is_binary(Prefix) ->
    'Elixir.String':'starts_with?'(String, Prefix).

%% @doc Returns true if string starts with any of the prefixes given, otherwise false.
-spec starts_with_any(estr(), [estr()]) -> boolean().
starts_with_any(String, Prefixes = [P1|_]) when is_binary(String), is_binary(P1) ->
    'Elixir.String':'starts_with?'(String, Prefixes).

%% @doc Returns a string where leading/trailing Unicode whitespace has been removed
-spec strip(estr()) -> estr().
strip(String) when is_binary(String) ->
    'Elixir.String':strip(String).

%% @doc Returns a string where leading/trailing char have been removed
-spec strip(estr(), non_neg_integer()) -> estr().
strip(String, Char) when is_binary(String), is_integer(Char), Char >= 0 ->
    'Elixir.String':strip(String, Char).

%% @doc Converts a string into a char list
-spec to_char_list(estr()) -> [non_neg_integer()].
to_char_list(String) when is_binary(String) ->
    'Elixir.String':to_char_list(String).

%% @doc Convert all characters on the given string to uppercase
-spec upcase(estr()) -> estr().
upcase(String) when is_binary(String) ->
    'Elixir.String':upcase(String).

%% @doc Checks whether str contains only valid characters
-spec is_valid(estr()) -> boolean().
is_valid(String) when is_binary(String) ->
    'Elixir.String':'valid?'(String).


%% All the clever stuff is tested as part of Elixir (thanks!)
%%
%% These tests are to make sure we have imported the correct elixir modules;
%% from time to time, the elixir string.* module names have changed/moved.

-ifdef(EUNIT).

estr_test() ->
    L = "жen",
    B = <<208,182,101,110>> = estr:new(L),
    ?assertException(error, badarg, list_to_binary(L)),
    ?assertEqual({<<208,182>>,<<"en">>}, next_codepoint(B)),
    ?assertEqual(<<208,150,69,78>>, upcase(B)),
    ?assertEqual(3, ?MODULE:length(B)),
    ?assertEqual([1078,101,110], to_char_list(B)),
    ?assertEqual([<<"1,2">>,<<"3,4">>], estr:split(estr:new("1,2 3,4"), <<" ">>)),
    ?assertEqual([<<"1">>,<<"2">>,<<"3">>,<<"4">>], estr:split_by_any(estr:new("1,2 3,4 "), [<<" ">>, <<",">>], [{trim, true}])),
    ?assertEqual([<<"1">>,<<"2">>,<<"3">>,<<"4">>,<<>>], estr:split_by_any(estr:new("1,2 3,4 "), [<<" ">>, <<",">>])),
    ?assertEqual([<<"1">>,<<"2 3">>,<<"4 ">>], estr:split_by_re(estr:new("1,2 3,4 "), <<",">>)),
    ok.

-endif.
