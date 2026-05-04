/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   A few sorting algorithms implemented in Prolog
   Written Jan. 17th 2007 by Markus Triska (triska@metalevel.at)
   Public domain code. Tested with Scryer Prolog.

   Two naming conventions I am using throughout all examples:

   a) Ls0 refers to the initial list. Ls1, Ls2, ... refer to
      successive states of the list. Ls refers to its final state.
   b) The names of variables that stand for lists always end with
      an "s", in analogy to the regular English plural form.

   See the chapter "Sorting and Searching" for more information:

               https://www.metalevel.at/prolog/sorting
               =======================================

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- use_module(library(dcgs)).
:- use_module(library(time)).
:- use_module(library(lists)).
:- use_module(library(clpz)).
:- use_module(library(format)).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Bubble sort. This is very easy to describe and encode in Prolog:

   As long as there are two elements ...,A,B,... where A @> B (note
   the use of (@>)/2 to make it work for all terms, using the
   standard order of terms), exchange the elements and repeat.

   Usage example:

      ?- bubblesort([a,b,c,1,5,0,x], Ls).
         Ls = [0,1,5|"abcx"].

   I am using ediprolog to evaluate queries directly in the Emacs buffer.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

bubblesort(Ls0, Ls) :-
    (	append(Lefts, [A,B|Rights], Ls0), A @> B ->
	append(Lefts, [B,A|Rights], Ls1),
	bubblesort(Ls1, Ls)
    ;	Ls = Ls0
    ).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Quicksort

   The well-known and often very slow quicksort. Beware! This is
   typically not a good algorithm for sorting. One of the reasons is
   that data that occurs naturally is often already presorted in some
   way. See the literature for more information. In Prolog, quicksort
   can be much more elegantly be described using DCGs, see below.

   We use the auxiliary predicate partition/4 (see below), which
   splits the initial list into two parts: Elements smaller and
   elements bigger than the pivot element. In the implementation
   below, we pick the first element of the original list as the pivot.
   Other strategies are possible and often affect the average running
   time, but typically not the worst-case complexity of the algorithm.

   Usage example:

      ?- quicksort([a,b,c,1,5,0,x], Qs).
         Qs = [0,1,5|"abcx"].
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

quicksort([], []).
quicksort([L|Ls0], Ls) :-
        partition(Ls0, L, Smallers0, Biggers0),
        quicksort(Smallers0, Smallers),
        quicksort(Biggers0, Biggers),
        append(Smallers, [L|Biggers], Ls).

partition([], _, [], []).
partition([L|Ls], Pivot, Smallers0, Biggers0) :-
        (   L @< Pivot ->
            Smallers0 = [L|Smallers],
            partition(Ls, Pivot, Smallers, Biggers0)
        ;   Biggers0 = [L|Biggers],
            partition(Ls, Pivot, Smallers0, Biggers)
        ).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   The above version of quicksort is not very elegant. A much more
   elegant way to describe lists in Prolog is to use a built-in
   formalism called Definite Clause Grammars (DCGs).

   A short DCG primer explaining the core ideas is available at:

                 https://www.metalevel.at/prolog/dcg
                 ===================================

   We now use a DCG to express quicksort in a very natural and more
   elegant way. Note that it is no longer necessary to use append/3 in
   this version. We reuse the definition of partition/4 above.

   We use the interface predicate phrase/2 to run the DCG:

      ?- phrase(quicksort([a,b,c,1,5,0,x]), Ls).
         Ls = [0,1,5|"abcx"].
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

quicksort([])	  --> [].
quicksort([L|Ls]) -->
        { partition(Ls, L, Smallers, Biggers) },
        quicksort(Smallers),
        [L],
        quicksort(Biggers).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   Merge sort.

   This is often a good choice. One advantage is that it can be easily
   made stable, which means that equal elements retain their original
   relative positions.

   Notice the use of append/3 to split the list. The auxiliary
   predicate merge/3 is used, see below. In some Prolog systems, this
   predicate is available as a built-in or library predicate, and you
   can omit its definition.

   Usage example:

      ?- mergesort([a,b,c,1,5,0,x], Ls).
         Ls = [0,1,5|"abcx"].
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

mergesort(Ls0, Ls) :-
        length(Ls0, L),
        zcompare(C, L, 1),
        halving(C, L, Ls0, Ls).

halving(<, _, Ls, Ls).
halving(=, _, Ls, Ls).
halving(>, L, Ls0, Ls) :-
        Half #= L // 2,
        length(Lefts0, Half),
        append(Lefts0, Rights0, Ls0),
        mergesort(Lefts0, Lefts),
        mergesort(Rights0, Rights),
        merge(Lefts, Rights, Ls).

% If your Prolog library provides merge/3, you can remove this definition.

merge([], Ys, Ys) :- !.
merge(Xs, [], Xs) :- !.
merge([X|Xs], [Y|Ys], Ms) :-
        (   X @< Y ->
            Ms = [X|Rs],
            merge(Xs, [Y|Ys], Rs)
        ;   Ms = [Y|Rs],
            merge([X|Xs], Ys, Rs)
        ).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   A few comparisons.
   ==================

   Bubble sort, sorting ascending integers

      ?- numlist(1, 3000, Ls), time(bubblesort(Ls,_)).
         % CPU time: 0.002s
         Ls = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20|...].


   Bubble sort, sorting descending integers

      ?- numlist(1, 150, Ls0), reverse(Ls0, Ls), time(bubblesort(Ls,_)).
         % CPU time: 0.432s
         Ls0 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20|...], Ls = [150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,134,133,132,131|...].

   Quicksort (non-DCG version), sorting ascending integers

      ?- numlist(0, 3000, Ls), time(quicksort(Ls, _)).
         % CPU time: 2.201s
         Ls = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...].


   Quicksort (DCG version), sorting ascending integers

      %?- numlist(0, 3000, Ls), time(phrase(quicksort(Ls), _)).
         % CPU time: 2.155s
         Ls = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...].


   Quicksort (non-DCG version), sorting descending integers

      %?- numlist(0, 500, Ls0), reverse(Ls0, Ls), time(quicksort(Ls, _)).
         % CPU time: 0.069s
         Ls0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...], Ls = [500,499,498,497,496,495,494,493,492,491,490,489,488,487,486,485,484,483,482,481|...].


   Quicksort (DCG version), sorting descending integers

      %?- numlist(0, 500, Ls0), reverse(Ls0, Ls), time(phrase(quicksort(Ls), _)).
         % CPU time: 0.059s
         Ls0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...], Ls = [500,499,498,497,496,495,494,493,492,491,490,489,488,487,486,485,484,483,482,481|...].


   Merge sort, sorting ascending integers

      %?- numlist(0, 3000, Ls), time(mergesort(Ls, _)).
         % CPU time: 0.022s
         Ls = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...].


   Merge sort, sorting descending integers

      %?- numlist(0, 3000, Ls0), reverse(Ls0, Ls), time(mergesort(Ls, _)).
         % CPU time: 0.022s
         Ls0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19|...], Ls = [3000,2999,2998,2997,2996,2995,2994,2993,2992,2991,2990,2989,2988,2987,2986,2985,2984,2983,2982,2981|...].


   It is of course interesting to see how well these different
   algorithms scale. For example, let us check quicksort on ascending
   lists. The following query is built in such a way that the list
   length doubles on each successive solution. We use false/0 to
   force backtracking:

      ?- length(_, N),
         L #= 2^N,
         portray_clause(length=L),
         numlist(1, L, Ls),
         time(quicksort(Ls,_)),
         false.
      length=1.
         % CPU time: 0.000s
      length=2.
         % CPU time: 0.000s
      length=4.
         % CPU time: 0.000s
      length=8.
         % CPU time: 0.000s
      length=16.
         % CPU time: 0.000s
      length=32.
         % CPU time: 0.000s
      length=64.
         % CPU time: 0.001s
      length=128.
         % CPU time: 0.004s
      length=256.
         % CPU time: 0.015s
      length=512.
         % CPU time: 0.063s
      length=1024.
         % CPU time: 0.254s
      length=2048.
         % CPU time: 0.994s
      length=4096.
         % CPU time: 4.095s

   I leave benchmarking the other algorithms as an exercise.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */


numlist(To, To, [To]) :- !.
numlist(From, To, [From|Ls]) :-
        From #< To,
        Next #= From + 1,
        numlist(Next, To, Ls).
