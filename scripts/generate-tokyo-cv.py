#!/usr/bin/env python3
"""Generate tokyo-job-fair .tex files (rirekisho resume + shokumu keirekisho CV)
from a content JSON, then compile them with scripts/compile.sh if available.

Usage:
    scripts/generate-tokyo-cv.py <content.json> [--outdir DIR] [--no-compile]

Content JSON schema (all strings; entries drive both documents):
{
  "name": "...", "address": "...", "phone": "...", "email": "...", "web": "...",
  "dob": "optional — defaults to 'provided upon request'",
  "date_label": "September 28, 2026",
  "target_label": "optional label shown in the motivation box",
  "motivation": "...",          // rirekisho motivation box text
  "self_pr": "...",             // keirekisho Self-PR text
  "education": [ {"date": "2018.08", "text": "..."} ],
  "entries": [
    {"start": "Aug 2026", "end": "Present",           // "Mon YYYY" / "Present"
     "org": "...", "role": "...", "loc": "...",
     "bullets": ["...", "..."]}
  ],
  "skills": ["...", "..."]
}

Output (next to the JSON unless --outdir):
    resume-rirekisho_<stem>.tex   (one page, personal info + chronological table + motivation)
    cv-keirekisho_<stem>.tex      (career summary + self-PR + detailed history + skills)
"""
import argparse, json, os, re, subprocess, sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TPL_DIR = os.path.join(REPO, "templates", "tokyo-job-fair")
MONTHS = {"Jan": 1, "Feb": 2, "Mar": 3, "Apr": 4, "May": 5, "Jun": 6,
          "Jul": 7, "Aug": 8, "Sep": 9, "Oct": 10, "Nov": 11, "Dec": 12}


def esc(s):
    """LaTeX-escape, turning **bold** markers into \\textbf{}."""
    s = s.replace("\\", "")
    s = re.sub(r"\*\*(.+?)\*\*", r"\\textbf{\1}", s)
    for ch, rep in [("&", r"\&"), ("%", r"\%"), ("$", r"\$"), ("#", r"\#"), ("_", r"\_")]:
        s = s.replace(ch, rep)
    return (s.replace("—", "---").replace("–", "--")
             .replace("’", "'").replace("“", '"').replace("”", '"'))


def texlist(items):
    return "\n".join("\\item " + esc(i) for i in items)


def fmt_ym(eng):
    mo, yr = eng.split()
    return f"{yr}.{MONTHS[mo]:02d}"


def fmt_period(e):
    end = "Present" if e["end"] == "Present" else fmt_ym(e["end"]).replace(".", "/")
    return f"{fmt_ym(e['start']).replace('.', '/')} -- {end}"


def work_rows(entries):
    """Rirekisho chronological rows: joined/left event per row."""
    out = []
    for e in entries:
        joined = f"{fmt_ym(e['start'])} & {esc(e['org'])} --- {esc(e['role'])}, Joined"
        out.append(joined + (" (to present)" if e["end"] == "Present" else ""))
        if e["end"] != "Present":
            out.append(f"{fmt_ym(e['end'])} & Left")
    return " \\\\ \\hline\n".join(out)


def edu_rows(education):
    return " \\\\ \\hline\n".join(f"{esc(e['date'])} & {esc(e['text'])}" for e in education)


def summary_rows(entries):
    rows = [f"{fmt_period(e)} & {esc(e['org'])} ({esc(e['loc'])}) --- {esc(e['role'])}" for e in entries]
    return " \\\\ \\hline\n".join(rows)


def work_detail(entries):
    blocks = []
    for e in entries:
        period = "\\textbf{" + fmt_period(e) + "}"
        org = ("\\textbf{" + esc(e["org"]) + "} (" + esc(e["loc"]) + ") --- \\textbf{"
               + esc(e["role"]) + "}")
        blocks.append(f"{period} \\\\ {org}\n\\begin{{itemize}}\n{texlist(e['bullets'])}\n\\end{{itemize}}")
    return "\n\n".join(blocks)


def fill(tpl, mapping):
    for k, v in mapping.items():
        tpl = tpl.replace("[[" + k + "]]", v)
    leftover = re.findall(r"\[\[.+?\]\]", tpl)
    if leftover:
        sys.exit(f"ERROR: unfilled placeholders: {leftover}")
    return tpl


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("content", help="content JSON path")
    ap.add_argument("--outdir", default=None)
    ap.add_argument("--no-compile", action="store_true")
    args = ap.parse_args()

    with open(args.content) as f:
        c = json.load(f)

    stem = os.path.splitext(os.path.basename(args.content))[0].replace("content_", "")
    outdir = args.outdir or os.path.dirname(os.path.abspath(args.content))
    os.makedirs(outdir, exist_ok=True)

    common = dict(
        NAME=esc(c["name"]), DOB=esc(c.get("dob", "---- (provided upon request)")),
        ADDRESS=esc(c["address"]), PHONE=esc(c["phone"]), EMAIL=esc(c["email"]),
        WEB=esc(c["web"]), DATE=esc(c["date_label"]),
    )

    with open(os.path.join(TPL_DIR, "resume-rirekisho.tex")) as f:
        resume = fill(f.read(), dict(
            common,
            EDU_ROWS=edu_rows(c["education"]),
            WORK_ROWS=work_rows(c["entries"]),
            MOTIVATION=esc(c["motivation"]),
            TARGET=esc(c.get("target_label", "")),
        ))
    with open(os.path.join(outdir, f"resume-rirekisho_{stem}.tex"), "w") as f:
        f.write(resume)

    with open(os.path.join(TPL_DIR, "cv-shokumu-keirekisho.tex")) as f:
        cv = fill(f.read(), dict(
            common,
            SUMMARY_ROWS=summary_rows(c["entries"]),
            SELF_PR=esc(c["self_pr"]),
            WORK_DETAIL=work_detail(c["entries"]),
            SKILLS="\\begin{itemize}\n" + texlist(c["skills"]) + "\n\\end{itemize}",
        ))
    with open(os.path.join(outdir, f"cv-keirekisho_{stem}.tex"), "w") as f:
        f.write(cv)

    print(f"generated: resume-rirekisho_{stem}.tex, cv-keirekisho_{stem}.tex in {outdir}")

    if not args.no_compile:
        compiler = os.path.join(REPO, "scripts", "compile.sh")
        if os.path.exists(compiler):
            for name in (f"resume-rirekisho_{stem}", f"cv-keirekisho_{stem}"):
                r = subprocess.run([compiler, os.path.join(outdir, name + ".tex")],
                                   capture_output=True, text=True)
                print(r.stdout.strip().splitlines()[-1] if r.stdout.strip() else r.stderr.strip())
        else:
            print("compile.sh not found — skipping PDF compilation")


if __name__ == "__main__":
    main()
