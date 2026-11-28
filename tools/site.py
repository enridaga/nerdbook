#!/usr/bin/env python3
"""Build a static website (site/) from the build outputs, for GitHub Pages.

Reuses the sources: tune list from tunes.tex, metadata from each tunes/<name>/tune.tex
(\\tune{Title}{Authors}{Year}{Keys}{Form}), iReal files from the generated
tunes/<name>/ireal-files.tex. Run after make.sh has produced the PDFs.
"""
import os, re, shutil, html, urllib.parse

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SITE = os.path.join(ROOT, "site")

def args(s, start, n):
    """Read n brace groups from s starting at index start."""
    out, i = [], start
    while len(out) < n:
        i = s.index("{", i); depth = 0; j = i
        while True:
            if s[j] == "{": depth += 1
            elif s[j] == "}":
                depth -= 1
                if depth == 0: break
            j += 1
        out.append(s[i+1:j]); i = j + 1
    return out

def tex2html(t):
    for a, b in [(r"$\flat$", "♭"), (r"$\sharp$", "♯"), (r"$\times$", "×"), (r"\ldots", "…"),
                 ("--", "–"), (r"\&", "&"), ("``", "“"), ("''", "”")]:
        t = t.replace(a, b)
    t = re.sub(r"\\[a-zA-Z]+\s*", "", t)
    return html.escape(t.replace("{", "").replace("}", "").replace("$", ""))

def link(path, label):
    return f'<a href="{urllib.parse.quote(path)}">{html.escape(label)}</a>'

def credits_html():
    """Convert credits.tex (restricted markup) to HTML, so the credits have one source."""
    t = open(os.path.join(ROOT, "credits.tex")).read()
    t = re.sub(r"^%.*$", "", t, flags=re.M)
    t = re.sub(r"\\(chapter\*|addcontentsline|markboth)(\{[^{}]*\})+", "", t)
    t = html.escape(t, quote=False)
    t = re.sub(r"\\href\{([^}]*)\}\{([^}]*)\}", r'<a href="\1">\2</a>', t)
    t = re.sub(r"\\textbf\{([^}]*)\}", r"<b>\1</b>", t)
    t = re.sub(r"\\emph\{([^}]*)\}", r"<i>\1</i>", t)
    t = re.sub(r"\\section\*\{([^}]*)\}", r"<h3>\1</h3>\n\n", t)
    t = t.replace("\\begin{itemize}", "<ul>").replace("\\end{itemize}", "</ul>")
    t = t.replace("\\item", "<li>").replace("--", "–")
    out = []
    for block in re.split(r"\n\s*\n", t.strip()):
        block = block.strip()
        out.append(block if block.startswith(("<h3>", "<ul>")) else f"<p>{block}</p>")
    return "\n".join(out)

def wheel_svg():
    """The cover wheel: chromatic degrees, diatonic Roman numerals, ii-V-I path."""
    import math
    def pt(k, r):
        a = math.radians(90 - 30 * k)
        return 160 + r * math.cos(a), 160 - r * math.sin(a)
    labs = ["1", "♭2", "2", "♭3", "3", "4", "♯4", "5", "♭6", "6", "♭7", "7"]
    dia = {0, 2, 4, 5, 7, 9, 11}
    out = ['<svg class="wheel" viewBox="0 0 320 320" role="img" aria-label="Scale degrees and diatonic chords">',
           '<circle cx="160" cy="160" r="130" class="ring"/><circle cx="160" cy="160" r="80" class="ring2"/>']
    (x2, y2), (x5, y5), (x1, y1) = pt(2, 64), pt(7, 64), pt(0, 64)
    out.append(f'<path d="M{x2:.1f},{y2:.1f} Q160,215 {x5:.1f},{y5:.1f}" class="arrow"/>')
    out.append(f'<path d="M{x5:.1f},{y5:.1f} Q135,110 {x1:.1f},{y1:.1f}" class="arrow"/>')
    out.append('<text x="160" y="163" class="iivi">ii – V – I</text>')
    for k, lab in enumerate(labs):
        x, y = pt(k, 130)
        c = "dia" if k in dia else "chr"
        r = 22 if k in dia else 17
        out.append(f'<circle cx="{x:.1f}" cy="{y:.1f}" r="{r}" class="{c}"/>'
                   f'<text x="{x:.1f}" y="{y + 6:.1f}" class="{c}">{lab}</text>')
    for k, rn in [(0, "I"), (2, "ii"), (4, "iii"), (5, "IV"), (7, "V"), (9, "vi"), (11, "viiø")]:
        x, y = pt(k, 80)
        out.append(f'<text x="{x:.1f}" y="{y + 5:.1f}" class="rn">{rn}</text>')
    out.append("</svg>")
    return "".join(out)

PAGE = """<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Nerdbook — a jazz study book in number notation</title>
<style>
:root{{--violet:#4d1f6b;--gold:#cc9433;--paper:#fbf8f1;--ink:#2a2430}}
*{{box-sizing:border-box}}
body{{margin:0;background:var(--paper);color:var(--ink);font-family:Georgia,"Times New Roman",serif;line-height:1.55}}
.band{{position:fixed;left:0;top:0;bottom:0;width:2.6rem;background:var(--violet);color:#fff;
  writing-mode:vertical-rl;transform:rotate(180deg);text-align:center;font:600 .7rem/2.6rem system-ui,sans-serif;letter-spacing:.35em}}
main{{max-width:60rem;margin:0 auto;padding:2rem 1.5rem 3rem 4.5rem}}
header{{display:grid;grid-template-columns:1fr minmax(14rem,20rem);gap:2rem;align-items:center;margin:1rem 0 2.5rem}}
h1{{font:700 clamp(3rem,9vw,5.6rem)/1 system-ui,"Helvetica Neue",sans-serif;color:var(--violet);margin:0;letter-spacing:-.02em}}
.sub{{font-style:italic;font-size:1.2rem;color:#5c5464;margin:.6rem 0 1rem}}
.rule{{width:5rem;height:3px;background:var(--gold);margin:1.2rem 0}}
.lead{{max-width:32rem}}
.books{{display:flex;flex-wrap:wrap;gap:.6rem;margin-top:1.4rem}}
.btn{{display:inline-block;padding:.55rem 1rem;border-radius:999px;border:2px solid var(--violet);color:var(--violet);
  text-decoration:none;font:600 .9rem system-ui,sans-serif}}
.btn.primary{{background:var(--violet);color:#fff}}
.btn:hover{{background:var(--gold);border-color:var(--gold);color:#fff}}
.wip{{margin-top:1.4rem;padding:.7rem 1rem;border-left:4px solid var(--gold);background:#fbf1de;font-size:.92rem;max-width:32rem}} .wip a{{color:var(--violet)}}
.wheel{{width:100%;height:auto}}
.wheel .ring{{fill:none;stroke:#e3dae8;stroke-width:1.5}} .wheel .ring2{{fill:none;stroke:#eee6f0;stroke-width:1}}
.wheel circle.dia{{fill:var(--paper);stroke:var(--violet);stroke-width:2}} .wheel circle.chr{{fill:var(--paper);stroke:#cfc8d3}}
.wheel text{{text-anchor:middle;font-family:Georgia,serif}}
.wheel text.dia{{fill:var(--violet);font-size:18px}} .wheel text.chr{{fill:#9a92a0;font-size:13px}}
.wheel .rn{{fill:#444;font-size:14px;font-weight:700}}
.wheel .arrow{{fill:none;stroke:var(--gold);stroke-width:3;marker-end:url(#a)}}
.wheel .iivi{{fill:#a87420;font:700 11px system-ui,sans-serif;text-anchor:middle}}
h2{{font:700 .85rem system-ui,sans-serif;letter-spacing:.25em;text-transform:uppercase;color:var(--violet);
  border-bottom:2px solid var(--gold);display:inline-block;padding-bottom:.2rem;margin:2rem 0 1rem}}
.tunelist{{list-style:none;padding:0;margin:0;max-width:42rem}}
.tunelist li{{padding:.45rem 0;border-bottom:1px solid #e6dfea}}
.tunelist a{{color:var(--violet);font-size:1.12rem;text-decoration:none;font-weight:600}} .tunelist a:hover{{text-decoration:underline}}
.tunelist .meta{{display:inline;margin-left:.5rem;font-size:.9rem}}
.back{{font:500 .9rem system-ui,sans-serif;color:var(--violet);text-decoration:none}}
.tunehead h1{{font-size:clamp(2.2rem,6vw,3.6rem);margin-top:.8rem}}
.ireal li{{margin:.4rem 0}} .ireal a{{color:var(--violet);font-weight:600}} .ireal .desc{{display:block;color:#6a6270;font-size:.88rem}}
.card{{background:#fff;border:1px solid #e6dfea;border-left:4px solid var(--violet);border-radius:8px;padding:.9rem 1.1rem}}
.card h3{{margin:0;font-size:1.25rem}} .meta{{font-style:italic;color:#6a6270;margin:.15rem 0 .5rem;font-size:.92rem}}
.facts{{font-size:.9rem;margin:.2rem 0}} .facts b{{font-family:system-ui,sans-serif;font-size:.75rem;letter-spacing:.08em;text-transform:uppercase;color:#7b6a86}}
.links{{margin:.6rem 0 0;font:500 .85rem system-ui,sans-serif}} .links a{{color:var(--violet)}}
.links .pdf{{background:var(--violet);color:#fff;padding:.15rem .55rem;border-radius:4px;text-decoration:none;margin-right:.3rem}}
footer{{color:#8a8290;font-size:.85rem;margin-top:3rem}} footer a,.credits a{{color:var(--violet)}} .credits{{max-width:42rem}} .credits h3{{font-size:1.05rem;margin:1.2rem 0 .4rem}} .credits li{{margin:.3rem 0}}
@media (max-width:700px){{header{{grid-template-columns:1fr}} .wheel{{max-width:18rem}} .band{{display:none}} main{{padding-left:1.5rem}}}}
</style></head><body>
<div class="band">NUMBER NOTATION · JAZZ STUDY</div>
<main>
<header>
<div>
<h1>Nerdbook</h1>
<p class="sub">A jazz study book in number notation</p>
<div class="rule"></div>
<p class="lead">Every tune is written relative to its key: the melody as scale degrees, the chords as
Roman numerals. Learn the shape once, play it in any key.</p>
<div class="books">{books}</div>
<p class="wip"><b>Work in progress.</b> Nerdbook is not a finished product: it is being written,
and it may contain errors in the transcriptions, the harmony or the notes. If you find one,
please <a href="https://github.com/enridaga/nerdbook/issues">open an issue on GitHub</a>.</p>
</div>
<svg width="0" height="0" style="position:absolute"><defs><marker id="a" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0,0L10,5L0,10z" fill="#cc9433"/></marker></defs></svg>
{wheel}
</header>
<h2>Tunes</h2>
<ul class="tunelist">{cards}</ul>
<h2>Credits</h2>
<div class="credits">{credits}</div>
<footer>Nerdbook © 2026 the Nerdbook contributors · {version}<br>
Licensed under <a href="https://creativecommons.org/licenses/by-nc-nd/4.0/">CC BY-NC-ND 4.0</a>:
free to use for study and teaching and to share unmodified, with credit; no commercial use, no modified versions.
The songs belong to their composers, lyricists and publishers. Made with the help of AI (Claude, by Anthropic): see Credits.</footer>
</main>
</body></html>"""

VERSION = ""

def tune_page(name, title, authors, year, keys, form, has_pdf, ireal):
    """One HTML page per tune: details, PDF and iReal Pro files."""
    style = PAGE[PAGE.index("<style>"):PAGE.index("</style>") + 8].replace("{{", "{").replace("}}", "}")
    btn = (f'<a class="btn primary" href="../songs/{urllib.parse.quote(name)}.pdf">PDF</a>'
           if has_pdf else "")
    items = "".join(f'<li>{link("../ireal/" + fn, label)}<span class="desc">{desc}</span></li>'
                    for fn, label, desc in ireal)
    ir = f'<h2>iReal Pro</h2><p>Open on a device with iReal Pro and tap the link.</p><ul class="ireal">{items}</ul>' if ireal else ""
    return f"""<!DOCTYPE html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title} — Nerdbook</title>
{style}</head><body>
<div class="band">NUMBER NOTATION · JAZZ STUDY</div>
<main>
<p><a class="back" href="../index.html">← Nerdbook</a></p>
<div class="tunehead"><h1>{title}</h1>
<p class="sub">{authors} · {year}</p></div>
<p class="facts"><b>Key</b> {keys}</p><p class="facts"><b>Form</b> {form}</p>
<div class="books">{btn}</div>
{ir}
<footer>Nerdbook © 2026 the Nerdbook contributors · {html.escape(VERSION)} ·
<a href="https://creativecommons.org/licenses/by-nc-nd/4.0/">CC BY-NC-ND 4.0</a> ·
work in progress: <a href="https://github.com/enridaga/nerdbook/issues">report an error</a></footer>
</main></body></html>"""

def main():
    if os.path.isdir(SITE): shutil.rmtree(SITE)
    for d in ("songs", "ireal", "tunes"): os.makedirs(os.path.join(SITE, d))
    books = [("main.pdf", "Nerdbook.pdf", "Study book (PDF)"),
             ("forms.pdf", "Nerdbook - Forms.pdf", "Forms"),
             ("patternbook.pdf", "Nerdbook - Pattern Book.pdf", "Pattern book")]
    rows = []
    for src, dst, label in books:
        if os.path.exists(os.path.join(ROOT, src)):
            shutil.copy(os.path.join(ROOT, src), os.path.join(SITE, dst))
            cls = "btn primary" if src == "main.pdf" else "btn"
            rows.append(f'<a class="{cls}" href="{urllib.parse.quote(dst)}">{html.escape(label)}</a>')
    for f in os.listdir(os.path.join(ROOT, "ireal")):
        shutil.copy(os.path.join(ROOT, "ireal", f), os.path.join(SITE, "ireal", f))

    version = ""
    vt = os.path.join(ROOT, "version.tex")
    if os.path.exists(vt):
        v = re.findall(r"\{([^{}]*)\}\n", open(vt).read())
        version = f"Version {v[0]} · {v[1]}" if len(v) >= 2 else ""
    global VERSION; VERSION = version
    tunes = re.findall(r"^\\tuneinclude\{([^}]+)\}", open(os.path.join(ROOT, "tunes.tex")).read(), re.M)
    cards = []
    for name in tunes:
        tex = open(os.path.join(ROOT, "tunes", name, "tune.tex")).read()
        title, authors, year, keys, form = map(tex2html, args(tex, tex.index(r"\tune{") + 5, 5))
        pdf = os.path.join(ROOT, "songs", name + ".pdf")
        if os.path.exists(pdf):
            shutil.copy(pdf, os.path.join(SITE, "songs", name + ".pdf"))
        ireal = []
        irf = os.path.join(ROOT, "tunes", name, "ireal-files.tex")
        if os.path.exists(irf):
            for fn, desc in re.findall(r"\\irealfile\{(.*?)\}\{(.*?)\}\n", open(irf).read()):
                fn = fn.replace(r"\&", "&")
                ireal.append((fn, fn.split(" - ", 1)[-1].removesuffix(".html"), tex2html(desc)))
        cards.append(f'<li><a href="tunes/{urllib.parse.quote(name)}.html">{title}</a>'
                     f'<p class="meta">{authors} · {year}</p></li>')
        open(os.path.join(SITE, "tunes", name + ".html"), "w").write(tune_page(
            name, title, authors, year, keys, form, os.path.exists(pdf), ireal))

    page = PAGE.format(books="".join(rows), wheel=wheel_svg(), cards="".join(cards), credits=credits_html(), version=html.escape(version))
    open(os.path.join(SITE, "index.html"), "w").write(page)
    open(os.path.join(SITE, ".nojekyll"), "w").close()
    print("site/ with", len(tunes), "tunes")

if __name__ == "__main__":
    main()
