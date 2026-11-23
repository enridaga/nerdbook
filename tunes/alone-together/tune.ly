%% Alone Together (Arthur Schwartz, Howard Dietz), key D minor.
%% Melody, rhythm and chords from the lead sheet (score.pdf, p. 1, concert);
%% pitches as in form.tex. Grey: chords in brackets on the lead sheet.
\version "2.24.0"

pickupIndent = #6  % mm, room for the pickup
tonic = d

melody = \relative c' {
  \key d \minor \time 4/4
  \partial 8 d8 |
  \repeat volta 2 {
    \section "A"
    f2.. d8 | e8 e4.~ e2~ | e4 r8 d e4. f8 | a1~ | \break
    a4 r8 d, e4. f8 | a1~ | a4 r8 g a4. bes8 | e2.. d8 | \break
    e2.. d8 | c8 c4.~ c4. bes8 | a4. g8 a4. g8 | a2.. g8 | \break
  }
  \alternative {
    { fis8 fis4.~ fis2~ | fis2. r8 d | }
    { fis8 fis4.~ fis2~ | fis2. d4 | }
  }
  \bar "||" \break
  \section "B"
  c'1~ | \tuplet 3/2 { c4 a bes } \tuplet 3/2 { c ees d } | bes1~ | bes2. d,4 | \break
  bes'1~ | \tuplet 3/2 { bes4 g a } \tuplet 3/2 { bes cis c } | a2.. f8 | g2.. d8 | \bar "||" \break
  \section "A"
  f2.. d8 | e8 e4.~ e2~ | e4 r8 d e4. f8 | a1~ | \break
  a4 r8 a b4. d8 | f2.. cis8 | d8 d4.~ d2~_\markup \italic "Fine" | d2 r4 r8 d, | \bar "|."
}

harmony = \chordmode {
  \key d \minor
  \partial 8 s8
  % A
  d1:m | e2:m7.5- a:7.9- | d1:m | e2:m7.5- a:7.9- |
  d1:m | a2:m7.5- d:7.9- | g1:m | g:m7 |
  b2:m7 e:7 | g:m7 c:7 | f f:7 | e:m7.5- a:7 |
  d1:maj7 | e2:m7.5- a:7 |
  d1:maj7 | d:maj7 |
  % B
  a1:m7.5- | d:7.9- | g:m | g:m |
  g:m7.5- | c:7.9- | f2 f:7 | e:m7.5- a:7.9- |
  % A
  d1:m | e2:m7.5- a:7.9- | d1:m | e2:m7.5- a:7.9- |
  d1:m | bes2:7 a:7 | d1:m | \alt e2:m7.5- \alt a:7 |
}
