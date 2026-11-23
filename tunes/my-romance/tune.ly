%% My Romance (Richard Rodgers, Lorenz Hart), key B-flat.
%% Melody and rhythm from a lead sheet in C (myromance-1.pdf, p. 2), transposed to B-flat.
%% Chords: main changes of the form (Jazzschool handout); Ben Webster changes not shown.
%% Bar 27: the lead sheet has 3 3 3 3 (degrees 10 10 10 10); the handout 10 10 10 9.
\version "2.24.0"

tonic = bes

melody = \transpose c bes \relative c' {
  \key c \major \time 4/4
  \partial 4 e8 f |
  \section "A"
  g2. e8 f | g4 a b c | c2. b8 a | g2. c,8 d | \break
  e2. c8 d | e4 f g a | a2. g8 f | e2. g4 | \break
  c,2. c'4 | g2. g4 | c,2. c'4 | g2. c4 | \break
  b2. a4 | g2. c4 | b2. a4 | g2. e8 f | \bar "||" \break
  \section "B"
  g2. e8 f | g4 a b c | c2. b8 a | g2. c,8 d | \break
  e2. c8 d | e4 f g a | a2. g8 f | e2. f8 g | \break
  a2. f8 g | a4 b c d | e e e e | c2. c8 d | \break
  e2. c8 d | e4 c a f | c'1 | R1 | \bar "|."
}

harmony = \transpose c bes \chordmode {
  \key c \major
  \partial 4 s4
  % A
  c1 | s1 | d2:m7 g:7 | c1 |
  a1:m7 | s1 | d2:m7 g:7 | c1 |
  f1 | c | f | c |
  ges2:m7.5- b:7 | e:m7 a:7 | d1:7 | d2:m7 g:7 |
  % B
  c1 | s1 | d2:m7 g:7 | c1 |
  a1:m7 | s1 | d2:m7 g:7 | c1 |
  f1 | s1 | b2:m7.5- e:7 | a1:m7 |
  c2 a:m7 | d:m7 g:7 | c1 | d2:m7 g:7 |
}
