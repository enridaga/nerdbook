%% Tangerine (Victor Schertzinger, Johnny Mercer), key F.
%% Melody, rhythm and chords from the lead sheet (score.pdf, p. 1, concert);
%% bars 13-14 checked against the B-flat and bass-clef pages.
\version "2.24.0"

pickupIndent = #19  % mm, room for the 2-beat pickup
tonic = f

melody = \relative c'' {
  \key f \major \time 4/4
  \partial 2 d4 bes |
  \section "A"
  a1~ | a2 c4 a | g f d2~ | d2 f4 d | \break
  f4. d8 e4. d8 | f4. d8 e4. c8 | a'1~ | a2 d4 bes | \bar "||" \break
  \section "B"
  a1~ | a2 c4 a | g f d2~ | d2 e4 f | \break
  d4. fis8 a4. fis8 | a4. fis8 b4 fis | a1~ | a2 d4 bes | \bar "||" \break
  \section "A"
  a1~ | a2 c4 a | g f d2~ | d2 f4 d | \break
  f4. d8 e4. d8 | f4. d8 e4 c | a'1~ | a2 bes4 c | \bar "||" \break
  \section "C"
  d4 bes \tuplet 3/2 { a c bes } | a2. g8 gis | a4 f \tuplet 3/2 { d g f } | e2. d4 | \break
  cis4 d f a | d2 f, | f1~ | f2 r2 | \bar "|."
}

harmony = \chordmode {
  \key f \major
  \partial 2 s2
  % A
  g1:m | c:7 | f2 bes | a:m d:7.9- |
  g2:m c:7 | g:m c:7 | f1 | a2:m7.5- d:7.9+ |
  % B
  g1:m | c:7 | f | b2:m7.5- e:7.9+ |
  a1 | b2:m e:7 | a1:7 | d:7.9- |
  % A
  g1:m | c:7 | f2 bes | a:m d:7.9- |
  g2:m c:7 | g:m c:7 | ees1:7 | d:7.9+ |
  % C
  g1:m | e2:m7.5- a:7.9+ | d1:m | g:7 |
  g1:m | c:7 | f | d:7.9+ |
}
