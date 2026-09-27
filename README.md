# CV Tailor

> Generate a tailored LaTeX CV for any job description — grounded strictly in your verified experience, never fabricated.

CV Tailor is an agentic skill for [Claude Code](https://claude.com/product/claude-code) (or any AI agent that reads `SKILL.md`). It turns a job description into a polished, ATS-friendly CV by drawing exclusively from your personal resource library — every metric, technology, and bullet traces back to a source file you control.

## How It Works

Give the agent a job description (text or URL) and it runs a 10-step pipeline defined in [`SKILL.md`](SKILL.md):

1. **Fetch the JD** — from a URL or pasted text
2. **Read your resources** — contact, education, experience brag files
3. **Extract JD signals** — seniority, stack, company culture, constraints
4. **Fit assessment** — 3–5 strongest matches, 1–3 honest gaps, verdict (Qualified / Stretch / Overqualified) — *always shown before drafting*
5. **Select bullets** — ownership-first for the primary role, compressed for older roles
6. **Rewrite impact-first** — XYZ pattern (Outcome → Metric → Mechanism), max 2 lines each
7. **Tailor the summary** — calibrated to your voice from `about.md`
8. **Tailor skills & education** — JD keywords mirrored verbatim for ATS
9. **Write & compile** — Markdown + LaTeX output, compiled with `pdflatex` if available
10. **Debrief** — file location, recap, cover-letter notes for the gaps

## Quick Start

```bash
git clone git@github.com:athallarizky/cv-tailor.git
cd cv-tailor

# Fill in your real data — copy each template and replace the placeholder content
cp resources/meta/contact.template.md resources/meta/contact.md
cp resources/meta/about.template.md resources/meta/about.md
cp resources/meta/location.template.md resources/meta/location.md
cp resources/educations/education.template.md resources/educations/<school>.md
cp resources/experiences/experience.template.md resources/experiences/<company>.md
```

Then, from this directory in Claude Code:

```
"Tailor my CV for this role: <JD text or URL>"
"Should I apply to this role? <JD URL>"          → fit assessment only
"Rewrite these bullets impact-first: <bullets>"  → standalone rewrite mode
```

Output lands in `output/YYYY-MM-DD_HH-mm-ss/` as both `<company>_resume.md` and `<company>_resume.tex` (plus PDF if `pdflatex` is installed).

## Directory Structure

```
cv-tailor/
├── SKILL.md              ← the skill: workflow, rules, modes
├── resources/
│   ├── meta/             ← contact.md, about.md (voice), location.md
│   ├── educations/       ← degrees, honors, coursework
│   └── experiences/      ← brag files: What I Did / Impact / Context / Framing Notes
├── templates/
│   └── ats-friendly-technical-resume/   ← LaTeX + Markdown templates
└── output/               ← generated CVs (gitignored)
```

### Privacy by Design

Your personal data never leaves your machine via git. `.gitignore` excludes everything in `resources/*/*` except the `*.template.md` skeletons — so the repo ships reusable templates while your real experience files, contact details, and brag notes stay local.

## Honesty Rules

The skill refuses to invent. Non-negotiables:

- **No fabricated metrics** — every number traces to `resources/experiences/`; unquantified impact stays descriptive
- **No claimed technologies** you haven't used — missing skills surface as gaps in the fit assessment instead
- **No title inflation** — official titles stay; scope shows through ownership verbs
- **Pushes back** on requests to add unverified tools or numbers

## Experience Files

Each experience file combines YAML metadata (dates, stack, `featured` priority, `overlap_risk` flag) with structured brag entries:

- **What I Did** — the technical work
- **Impact** — measured outcomes (or honest qualitative direction)
- **Context** — the problem behind the work
- **Framing Notes** — which angle to emphasize per target role type (e.g. the same CI/CD project framed as reliability for SRE roles, cost savings for FinOps)

## Templates

| Template | Notes |
|---|---|
| `ats-friendly-technical-resume` | Single-column, `glyphtounicode` for machine-readable PDF, 1–2 page discipline — cut bullets, never shrink fonts |

Page overflow is treated as failure: the skill drops least-relevant bullets first, then trims, then compresses older roles.

## Requirements

- An AI agent that reads `SKILL.md` (developed for Claude Code)
- `pdflatex` (TeX Live / MacTeX) — optional, for PDF output
