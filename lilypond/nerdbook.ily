%% nerdbook.ily: Nerdbook number notation for LilyPond.
%% Melody: scale degrees on a single line, with standard rhythm (stems, beams, ties, rests).
%% Chords: Roman numerals relative to the key.
%% Tunes are written in ordinary LilyPond pitches (tunes/<name>/tune.ly); this file only
%% changes how they are drawn, so the same source can also give tabs, MIDI, other keys.
\version "2.24.0"

#(define major-semis '#(0 2 4 5 7 9 11))

%% degree, alteration (in semitones) and octave of pitch p relative to tonic t (t in the c' octave)
#(define (nb-degree p t)
  (let* ((d (- (ly:pitch-steps p) (ly:pitch-steps t)))
         (oct (floor (/ d 7)))
         (deg (modulo d 7))
         (semi (- (ly:pitch-semitones p) (ly:pitch-semitones t) (* 12 oct)))
         (alt (- semi (vector-ref major-semis deg))))
    (list (+ deg 1) alt oct)))

#(define (nb-acc-markup alt)
  (cond ((= alt 0) (markup ""))
        ((< alt 0) (markup #:fontsize -3 #:raise 0.6 #:flat))
        (else (markup #:fontsize -3 #:raise 0.6 #:sharp))))

%% NoteHead stencil: the degree (with accidental) centred on the line; half notes in a rounded box (circles are for target notes);
%% octave dots added outside the extent so every number sits at the same height
#(define (nb-head-stencil p t)
  (lambda (grob)
    (let* ((dao (nb-degree p t))
           (deg (car dao)) (alt (cadr dao)) (oct (caddr dao))
           (log (ly:grob-property grob 'duration-log))
           (num (markup #:bold #:fontsize 1 (number->string deg)))
           (num (if (= log 1) (markup #:override (cons (quote box-padding) 0.25) #:override (cons (quote corner-radius) 0.6) #:rounded-box num) num))
           (mk (markup #:concat ((nb-acc-markup alt) num)))
           (st (ly:stencil-aligned-to (grob-interpret-markup grob mk) Y CENTER))
           (xe (ly:stencil-extent st X)) (ye (ly:stencil-extent st Y))
           (w (interval-length (ly:stencil-extent
                (grob-interpret-markup grob (markup #:bold #:fontsize 1 (number->string deg))) X)))
           (numx (- (cdr xe) (/ w 2)))
           (dot (ly:stencil-aligned-to
                  (grob-interpret-markup grob (markup #:fontsize -3 #:musicglyph "dots.dot")) X CENTER))
           (dw 0.45)
           (dots (let loop ((i 0) (acc empty-stencil))
                   (if (>= i (abs oct)) acc
                       (loop (+ i 1)
                             (ly:stencil-add acc
                               (ly:stencil-translate dot
                                 (cons numx
                                       (if (> oct 0) (+ (cdr ye) 0.4 (* i dw))
                                                     (- (car ye) 0.4 (* i dw))))))))))
           (all (ly:stencil-add st dots)))
      (ly:make-stencil (ly:stencil-expr all) xe ye))))

%% Turn real music into the display version: every note on the line, head = degree
degrees =
#(define-music-function (tonic music) (ly:pitch? ly:music?)
  (let ((t (ly:make-pitch 0 (ly:pitch-notename tonic) (ly:pitch-alteration tonic))))
    (music-map
     (lambda (m)
       (if (music-is-of-type? m 'note-event)
           (let ((p (ly:music-property m 'pitch)))
             (ly:music-set-property! m 'tweaks
               (cons (cons 'stencil (nb-head-stencil p t))
                     (ly:music-property m 'tweaks)))
             (ly:music-set-property! m 'pitch (ly:make-pitch 0 6 0))))
       m)
     (ly:music-deep-copy music))))

%% ---- Roman numeral chord names ----
#(define roman-up '#("I" "II" "III" "IV" "V" "VI" "VII"))

#(define (nb-chord-name pitches bass inversion context)
  (let* ((tonic (ly:context-property context 'tonic (ly:make-pitch 0 0 0)))
         (root (car pitches))
         (dao (nb-degree root (ly:make-pitch 0 (ly:pitch-notename tonic) (ly:pitch-alteration tonic))))
         (deg (car dao)) (alt (cadr dao))
         (ivs (map (lambda (p) (modulo (- (ly:pitch-semitones p) (ly:pitch-semitones root)) 12)) pitches))
         (has (lambda (i) (memv i ivs)))
         (minor (and (has 3) (not (has 4))))
         (dim (and minor (has 6) (not (has 7))))
         (num (vector-ref roman-up (- deg 1)))
         (num (if minor (string-downcase num) num))
         (seventh (or (has 10) (has 11)))
         ;; natural extension shown instead of 7: 9, 13
         (ext (cond ((and seventh (has 9) (not dim)) "13")
                    ((and seventh (has 2)) "9")
                    (else "7")))
         ;; altered tensions
         (alts (string-append
                 (if (has 1) "♭9" "")
                 (if (and (has 3) (has 4)) "♯9" "")
                 (if (and (has 6) (has 7)) "♯11" "")
                 (if (and (has 8) (has 7) seventh) "♭13" "")))
         (sup (cond ((and dim (has 9)) "°7")
                    ((and dim (has 10)) "ø7")
                    (dim "°")
                    ((and minor (has 10)) (string-append "–" ext alts))
                    ((and minor (has 11)) (string-append "–Δ" ext alts))
                    (minor "–")
                    ((has 11) (string-append "Δ" ext alts))
                    ((has 10) (string-append ext alts))
                    (else alts))))
    (markup #:concat ((nb-acc-markup alt) #:bold num #:super sup))))

nbChords = \with {
  chordNameFunction = #nb-chord-name
  % room between chords and melody
  \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #2.5
  \override ChordName.font-size = #1.5
}

%% ---- the degree line ----
nbDegreeStaff = \with {
  \override StaffSymbol.line-count = #1
  \override StaffSymbol.color = #(x11-color 'grey80)
  \override BarLine.bar-extent = #'(-2.5 . 2.5)
  \remove Clef_engraver
  \remove Key_engraver
  \remove Accidental_engraver
  \override TimeSignature.stencil = ##f
  \stemUp
  \override Stem.length = #7.5
  \override Beam.positions = #'(5 . 5)
  \override Rest.staff-position = #0
  \override MultiMeasureRest.staff-position = #0
  \override Script.padding = #0.8
  \override Script.direction = #UP
  \override TextScript.direction = #UP
  \override MultiMeasureRestText.direction = #UP
  \tieUp
  \override Tie.details.height-limit = #1.2
}

%% grey chord for alternative changes: \\alt d2:7
alt = { \once \override ChordName.color = #(x11-color 'grey55) }

%% Indent (mm) of lines 2.. so that bar 1 aligns with the bars below when line 1
%% starts with a pickup. A tune with a pickup sets e.g.  pickupIndent = #6  in tune.ly
pickupIndent = #0

%% section label: \section "A"
section = #(define-music-function (s) (string?)
  #{ \mark \markup \box \bold #s #})

%% bar with a solo break: \fill
fill = { R1^\markup \italic "fill" }

%% Invisible bars to pad a short line, so the bars above and below stay aligned:
%% \hiddenBars 2 11   (pad 2 bars; the next real bar is number 11). Print only, not in MIDI.
hiddenBars = #(define-music-function (n next) (index? index?)
  #{ \tag #'print {
       \stopStaff s1
       \repeat unfold #(- n 1) { \once \omit Score.BarLine s1 }
       \once \omit Score.BarLine
       \startStaff \set Score.currentBarNumber = #next
     } #})
hiddenChords = #(define-music-function (n) (index?)
  #{ \tag #'print { \repeat unfold #n s1 } #})

%% coda: \toCoda "last time" on the bar where to jump; \coda as the section label
toCoda = #(define-music-function (txt) (string?)
  #{ \mark \markup \concat { \musicglyph "scripts.coda" " " \italic #txt } #})
coda = { \mark \markup \musicglyph "scripts.coda" }
