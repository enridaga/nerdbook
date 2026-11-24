%% Anthropology (Charlie Parker, Dizzy Gillespie), key B-flat.
%% Melody and rhythm from a lead sheet image (concert, low resolution):
%% pitches read with care, check against a recording. Chords: core changes.
\version "2.24.0"

tonic = bes

melody = \fixed c' {
  \key bes \major \time 4/4
  \repeat volta 2 {
    \section "A"
    bes8 d' c' bes ees' cis' d' f' | r4 r8 ees' r f' ees'4 |
    r8 d' ees' d' c' a bes d' | c'8 g bes a r4 r8 bes~ | \break
    bes4 g8 bes d' bes r e' | r8 ees' r ges~ ges bes c' d' |
  }
  \alternative {
    { f'4 r8 b r aes'4 fis'8 | g'8 ees' b g d' e' r f | \break }
    { ees'8 f'16 ees' d'8 f' r d' ees' g | c'8 g bes c' r4 r8 fis'~ | }
  }
  \hiddenBars 2 11 \break
  \section "B"
  fis'4 g'8 gis' a' fis' g' a' | fis'8 d' r4 r r8 c' |
  f'8 e' d' b e' d' b a | r4 r8 a' r a' r a'~ | \break
  a'8 g' e' d'~ d'4. a8 | \tuplet 3/2 { c'16 d' c' } g8 bes c' r4 r8 ees'~ |
  ees'4 d'8 c' b d' c' a | c'4 bes8 a r4 r8 f | \bar "||" \break
  \section "A"
  bes8 d' c' bes ees' cis' d' f' | r4 r8 ees' r f' ees'4 |
  r8 d' ees' d' c' a bes d' | c'8 g bes a r4 r8 bes~ | \break
  bes4 g8 bes d' bes r e' | r8 ees' r ges~ ges bes c' d' |
  ees'8 f'16 ees' d'8 f' r d' ees' g | c'8 bes a bes r2 | \bar "|."
}

harmony = \chordmode {
  \key bes \major
  % A (core changes; the lead sheet's changes are in grey in the form)
  bes1 | f:7 | bes | f:7 |
  bes1:7 | ees2 ees:m |
  bes1 | f:7 |
  bes1 | f:7 | \hiddenChords 2
  % B
  d1:7 | s1 | g1:7 | s1 |
  c1:7 | s1 | f1:7 | s1 |
  % A
  bes1 | f:7 | bes | f:7 |
  bes1:7 | ees2 ees:m | bes1 | f:7 |
}
