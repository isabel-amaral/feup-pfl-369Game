:- use_module(library(lists)).
:- use_module(library(random)).

:- consult('utils.pl').
:- consult('display.pl').
:- consult('input.pl').
:- consult('points.pl').
:- consult('move.pl').

% create_board_line(+Counter, -Line)
create_board_line(0, []).
create_board_line(Counter, Line) :-
    Counter > 0,
    CounterAux is Counter - 1,
    create_board_line(CounterAux, LineAux),
    Line = [e | LineAux].

% create_board(+Size, +Counter, -Board)
create_board(Size, 1, Board) :-
    create_board_line(Size, Line),
    Board = [Line].
create_board(Size, Counter, Board) :-
    Counter > 0,
    CounterAux is Counter - 1,
    create_board(Size, CounterAux, BoardAux),
    create_board_line(Size, Line),
    Board = [Line | BoardAux].


% GameState is saved in the format [BoardSize, Board, WhitePlayer, BlackPlayer, NextPlayer]
% initial_state(+Size, -GameState)
initial_state(Size, [Size, Board, 0, 0, w]) :-
    create_board(Size, Size, Board).


% map_option_to_game_type(+Option, -GameType)
map_option_to_game_type(1, h/h).
map_option_to_game_type(2, h/pc).
map_option_to_game_type(3, pc/pc).


% choose_game_type(-GameType)
choose_game_type(GameType) :- 
    repeat, nl,
    write('Choose the game type: '), nl,
    write('1 - Human-Human (H/H)'),nl,
    write('2 - Human-Computer (H/PC)'), nl,
    write('3 - Computer-Computer (PC/PC)'), nl,
    read(N),
    number(N),
    N >= 1,
    N =< 3,
    map_option_to_game_type(N, GameType).


% choose_level(-Level)
choose_level(Level) :-
    repeat, nl,
    write('Choose game level (1 or 2):'), nl,
    read(L),
    number(L),
    N >= 1,
    N =< 2,
    Level is L.


% choose_board_size(-Size)
choose_board_size(Size) :-
    repeat, nl,
    write('Choose board size:'), nl,
    read(S),
    number(S),
    Size is S.


% display_winner(+Winner)
display_winner(b) :- write('The black pieces won the victory in this battle of wits!'), nl.
display_winner(w) :- write('The white pieces won the victory in this battle of wits!'), nl.
display_winner(t) :- write('No winner today. The game ends in a draw!'), nl.


% game_over_aux(+WhitePoints, +BlackPoints, -Winner)
game_over_aux(WPoints, BPoints, Winner) :-
    WPoints > BPoints,
    Winner = w,
    !.
game_over_aux(WPoints, BPoints, Winner) :-
    BPoints > WPoints,
    Winner = b,
    !.
game_over_aux( _, _, t).

% game_over(+GameState, -Winner)
game_over(GameState, Winner) :- 
    get_next_player(GameState, Player),
    valid_moves(GameState, Player, FreePositions),
    length(FreePositions, 0),
    value(GameState, w, WPoints),
    value(GameState, b, BPoints),
    game_over_aux(WPoints, BPoints, Winner),
    display_winner(Winner).


% menu(-GameType, -Level, -Size)
menu(GameType, Level, Size) :- 
    nl, 
    choose_game_type(GameType),
    choose_level(Level),
    choose_board_size(Size).


% play/0
