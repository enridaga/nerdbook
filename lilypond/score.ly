%% Driver: the "Tune" section of a tune (degrees with rhythm, chords as Roman numerals).
%% make.sh runs:  lilypond -I tunes/<name> -I lilypond -o tunes/<name>/tune-score lilypond/score.ly
%% tune.ly must define: tonic (pitch), melody, harmony.
\version "2.24.0"
\include "nerdbook.ily"
\include "tune.ly"

\header { tagline = ##f }
\paper {
  #(set-paper-size "a4")
  line-width = 17\cm           % = \textwidth of the book, so the PDF is not scaled
  % Every line is justified to the full width with proportional spacing, so the
  % bar lines of 4-bar lines align. short-indent leaves room on lines 2.. for the
  % width the pickup takes on line 1. Shorter lines are padded with \hiddenBars.
  indent = 0
  short-indent = \pickupIndent
  ragged-right = ##f
  ragged-last = ##f
  system-system-spacing.basic-distance = #17
  system-system-spacing.padding = #3
}
#(set-global-staff-size 18)

\score {
  <<
    \new ChordNames \with { \nbChords tonic = \tonic } \keepWithTag #'print \harmony
    \new Staff \with \nbDegreeStaff \degrees \tonic \keepWithTag #'print \melody
  >>
  \layout {
    \context { \Score
      \override RehearsalMark.self-alignment-X = #LEFT
      \override RehearsalMark.break-align-symbols = #'(staff-bar left-edge)
      % proportional spacing: every 4/4 bar gets the same width, so bar lines align
      proportionalNotationDuration = #(ly:make-moment 1/12)
      \override SpacingSpanner.uniform-stretching = ##t
      % room between bar lines and notes
      \override BarLine.extra-spacing-width = #'(-0.6 . 0.6)
      \override SpacingSpanner.strict-grace-spacing = ##t
    }
  }
}

%% MIDI of melody and chords, to check the transcription by ear
\score {
  \unfoldRepeats \removeWithTag #'print << \melody \harmony >>
  \midi { \tempo 4 = 180 }
}
