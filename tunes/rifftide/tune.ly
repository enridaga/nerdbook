%% Rifftide (Coleman Hawkins), concert key F.
%% Transcribed from the Jazzschool handout (all four transpositions compared).
%% Uncertain: bridge bars 7-8 (handwriting; read as a sequence, bar 8 = bar 7 up a semitone);
%%            A bar 4, tie between the two flat-3 notes.
%% ^ = short accent (marcato), > = accent.
\version "2.24.0"

tonic = f

melody = \relative c' {
  \key f \major \time 4/4
  \partial 8 b8 |
  \repeat volta 2 {
    \section "A"
    c8 f a c~ c4 bes8 g |
    aes4 r r r8 b, |
    c8 f a c~ c4 bes8-^ aes |
    a4 r8 aes~ aes r r b, | \break
    c8 f a c~ c4 bes8-> b, |
    c8 f a c~ c4 bes8-> aes |
  }
  \alternative {
    { a8 f d c f4 d-^ | r2 r4 r8 b | \break }
    { a'8 f d c f4 d-^ | R1 | }
  }
  \hiddenBars 2 11 \break
  \section "B"
  r8 f8 d c f4 d-^ | \fill |
  r8 f d c f4 d-^ | \fill | \break
  r8 a' f d a'4 f-^ | r2 r4 g8 c~ |
  c8 c a g c4 aes8 des~ | des des bes aes des4 bes8 b, | \bar "||" \break
  \section "A"
  c8 f a c~ c4 bes8 g |
  aes4 r r r8 b, |
  c8 f a c~ c4 bes8-^ aes |
  a4 r8 aes~ aes r r b, | \break
  c8 f a c~ c4 bes8-> b, |
  c8 f a c~ c4 bes8-> aes |
  a8 f d c f4 d-^ | R1 | \bar "|."
}

harmony = \chordmode {
  \key f \major
  \partial 8 s8
  % A
  f1 | bes:7 | f2 bes:7 | a:m7 aes:m7 |
  g1:m7 | c:7 |
  f2 \alt d:7 | \alt g:m7 \alt c:7 |
  f1 | c2:m7 f:7 | \hiddenChords 2
  % B
  bes1:7 | b:dim | f | \alt e2:m7.5- \alt a:7 |
  d1:m7 | g:7 | g2:m7 c:7 | aes:m7 des:7 |
  % A
  f1 | bes:7 | f2 bes:7 | a:m7 aes:m7 |
  g1:m7 | c:7 |
  f2 \alt d:7 | \alt g:m7 \alt c:7 |
}
