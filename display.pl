% display_line_separators(+Counter)
display_line_separators(0).
display_line_separators(Counter) :-
    write('-'),
    CounterAux is Counter - 1,
    display_line_separators(CounterAux).

% display_column_tags(+BoardSize, +Counter)
display_column_tags(BoardSize, BoardSize) :-
    write('|').
display_column_tags(BoardSize, Counter) :-
    write('| '),
    Ascii is Counter + 97,
    put_code(Ascii),
    write(' '),
    CounterAux is Counter + 1,
    display_column_tags(BoardSize, CounterAux).

% display_line(+Line)
display_line([]) :- write('|').
display_line([e | Rest]) :-
    write('| '),
    write(' '),
    write(' '),    
    display_line(Rest),
    !.
display_line([Column | Rest]) :-
    write('| '),
    write(Column),
    write(' '),    
    display_line(Rest).

% display_game_aux(+BoardSize, +Board, +Counter)
display_game_aux(BoardSize, [], _) :-
    NChars is BoardSize * 4 + 3,
    display_line_separators(NChars).
display_game_aux(BoardSize, [Line | Rest], Counter) :-
    NChars is BoardSize * 4 + 3,
    display_line_separators(NChars),
    nl,
    write(Counter),
    write(' '),
    display_line(Line),
    nl,
    CounterAux is Counter + 1,
    display_game_aux(BoardSize, Rest, CounterAux).

/* TODO: Change in order to receive game state */
% display_game(+GameState)
display_game(GameState) :-
    get_board_size(GameState, BoardSize),
    get_board(GameState, Board),
    nl,
    write('  '),
    display_column_tags(BoardSize, 0),
    nl,
    display_game_aux(BoardSize, Board, 1).
