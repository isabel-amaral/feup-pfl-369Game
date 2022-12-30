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


%display_winner(+Winner)
display_winner(b) :- write('Player with white pieces won!'), nl.
display_winner(w) :- write('Player with black pieces won!'), nl.
display_winner(t) :- write('Tie'), nl.


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
