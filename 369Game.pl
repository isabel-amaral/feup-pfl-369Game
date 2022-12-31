:- use_module(library(lists)).
:- use_module(library(random)).

:- consult('utils.pl').
:- consult('menu.pl').
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


% GameState is saved in the format [BoardSize, Board, Level, WhitePlayer, BlackPlayer, NextPlayer]
% initial_state(+Size, +Level, -GameState)
initial_state(Size, Level, [Size, Board, Level, 0, 0, w]) :-
    create_board(Size, Size, Board).


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


% play/0
% TODO: Add call to game_cycle
play :-
    menu(GameType, Level, Size),
    initial_state(Size, Level, GameState).