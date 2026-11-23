%% Fotografia (Antonio Carlos Jobim), key G.
%% Melody, rhythm and chords from the Jazzschool handout (concert page, checked
%% against the B-flat page). Solos on the 16-bar form; last time, coda from bar 15.
\version "2.24.0"

tonic = g

melody = \relative c'' {
  \key g \major \time 4/4
  \repeat volta 2 {
    \section "A"
    a4. g8 a g4 a8~ | a4. g8 a b a g | a4. g8 a4 g8 a~ | a4. g8 a bes a g | \break
    a4. g8 a4 g8 a~ | a4. g8 fis g a b | d4 c8 d~ d c d4~ | d4. c8 d e d c | \break
    b4. a8 b a4 b8~ | b4. a8 d des c b | a4. g8 a g4 a8~ | a4. g8 a b a g | \break
    a4. g8 a b a g | a4. g8 a bes a g | \toCoda "last time" a2~ a8 g a g | a2. r4^\markup \italic "solos on form" |
  }
  \break
  \coda
  \repeat volta 2 {
    a4. d8~ d2~ | d2. a8 g | a4. d8~ d2~ | d2 r4^\markup \italic "repeat and fade" a8 g |
  }
}

harmony = \chordmode {
  \key g \major
  g1:maj7 | s1 | c:9 | s1 |
  g1:maj7 | s1 | b:m7.5- | e:7.9- |
  a1:m9 | fis2:m7.5- b:7.9- | e1:m9 | a:13.11+ |
  a1:m7 | d:7 | g:maj7 | c:13 |
  % coda
  g1:maj7 | c:13 | g:maj7 | c:13 |
}
