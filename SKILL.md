---
name: cv-tailor
description: >-
  Generate a tailored LaTeX CV for a specific job description, grounded in the user's verified experience and resources. Supports selectable templates (default: ats-friendly-technical-resume). Use this skill when the user provides a job description (text or URL) and asks for a tailored CV, asks for bullet rewrites, or asks "should I apply to this role" (fit assessment). NEVER fabricate metrics — only use facts from the user's resources.
---

# CV Tailoring Skill

Generates a tailored LaTeX CV for a specific JD, drawing strictly from the user's verified resource library (`/resources/`) and formatting with selectable templates (`/templates/`). Also handles bullet rewrites and fit assessments on their own.

---

## Directory Structure & Resource Locations

Resolve the CV repository/workspace root in this order:
1. If the current working directory contains `resources/` and `templates/`, use it.
2. If the user stated a path in conversation, use it.
3. Otherwise, ask the user. Don't guess.

Within the resolved workspace, resources and templates are organized as follows:

```
├── resources/
│   ├── meta/           # General personal data: contact.md, location.md, about.md, links, social profiles
│   ├── educations/     # Education history: degrees, institutions, graduation dates, honors
│   └── experiences/    # Work experience & brag files: achievements, metrics, scope, framing notes
├── templates/          # LaTeX CV templates (e.g. ats-friendly-technical-resume, etc.)
└── output/             # Generated CV outputs by timestamp: output/YYYY-MM-DD_HH-mm-ss/
```

---

## Source of Truth — Hierarchy

**Resource files are the only ground truth for CV content.** Read them fully. Never skim.

| Location | Role | Description |
|---|---|---|
| `/resources/experiences/` | **Primary source** | Detailed experience logs and brag files. Every metric, outcome, and bullet must trace here. |
| `/resources/educations/` | **Education source** | Formal education, degrees, certifications, and academic background. Use verbatim. |
| `/resources/meta/` | **Metadata & Profile** | General personal data (`contact.md` for contact info, `location.md` for location/timezone preferences, `about.md` for summary voice/framing, links). |
| `/templates/` | **Layout Reference** | Master LaTeX templates defining structure, styling, and page limits. |

Each experience file should contain sections such as: **What I Did**, **Impact**, **Context**, and optionally **Framing notes**. The Framing notes section tells you which angle or value proposition to emphasize for a given target audience. Always check for it before writing bullets.

---

## Templates

The `/templates/` directory contains available LaTeX CV templates.

### Template Selection Rule
- **Always ask the user first** which template they want to use before generating the CV.
- **Default template:** `ats-friendly-technical-resume` (use if user confirms or specifies no preference).

### Page Discipline
- Respect the target page limit defined by the selected template (typically 1–2 pages max).
- Spilling over to an extra page is considered a failure — cut to fix. Never shrink fonts or margins below template defaults.
- When cutting to fit:
  1. Drop least-JD-relevant bullets first.
  2. Trim long bullets to their essential outcome and mechanism.
  3. Compress older roles.

---

## Full Workflow

### Step 1 — Fetch the JD
- If a URL is provided: fetch and extract the text. If blocked or behind an auth wall (Greenhouse, Workday, Ashby, Lever, etc.), prompt the user to paste the raw JD text.
- If pasted text: proceed directly.

### Step 2 — Read All Resource Files
Read all files in:
- `/resources/meta/` (contact info, bio/about)
- `/resources/educations/` (education background)
- `/resources/experiences/` (all experience files & brag records, noting hard metrics vs. qualitative impact)

### Step 3 — Extract from the JD
Extract key dimensions:
- Role title and seniority level
- Required core technologies, tools, and methodologies
- Nice-to-have qualifications
- Company profile & engineering culture (size, stage, OSS-first, remote, fintech, crypto, enterprise, etc.)
- Location / timezone constraints

### Step 4 — Fit Assessment (NEVER skip)
Before drafting or generating any CV, present a fit assessment to the user:
- **3–5 strongest matches**: Specific user experience ↔ JD requirement pairs
- **1–3 honest gaps**: Missing technologies, domain differences, or seniority delta
- **Verdict**: Qualified / Well-qualified / Stretch / Overqualified
- **Strategic notes**: Keywords to highlight, angles to take, or points to clarify in an interview / cover letter

Wait for user confirmation before proceeding to draft.

### Step 5 — Confirm Template & Select Bullets
1. **Confirm Template:** Prompt the user to select a template from `/templates/` (recommend/default to `ats-friendly-technical-resume`).
2. **Handle Role Overlaps / Moonlight Signals:**
   - If multiple roles overlap chronologically, assess candidate/company risk. For conservative/enterprise companies, prompt whether secondary/overlapping roles should be omitted or kept.
3. **Establish Ownership Bullets for Primary Role:**
   - Top 1–3 bullets for the primary/current role should establish foundational ownership (e.g. system scale, platform architecture, core operational scope).
   - Use active ownership verbs ("Own", "Lead", "Architect") rather than passive maintenance ("Maintain").
4. **Select JD-Matched Bullets:**
   - Choose 6–8 bullets for the primary role that maximally match the target JD.
   - For older roles, compress to 2–3 high-signal bullets.
   - Drop irrelevant bullets entirely.

### Step 6 — Rewrite Bullets Impact-First
Apply the impact-first pattern to every bullet:

**Use XYZ as a thinking scaffold (Outcome, Metric, Mechanism):**
- **X (Outcome):** Always lead with the business or engineering result.
- **Y (Metric - optional):** Include if quantified and impressive ($ saved, latency reduced, scale achieved). Never invent numbers.
- **Z (Mechanism):** Stack, scope, and engineering mechanism. Names real tools and architecture choices.

**Formatting & Style Rules:**
- **Length:** Max 2 rendered lines (~25 words) per bullet. Lead with outcome; second line carries technical substance.
- **Deduplication:** Avoid repeating the exact same scale number across summary and bullets.
- **Connectors:** Use natural phrasing ("by doing X", em-dash clauses `\---\` in LaTeX). Avoid chaining multiple em-dashes.
- **No Colon-Enumerations:** Avoid "Built system: a, b, c". Use complete verbal clauses.
- **No Internal Jargon:** Generalize internal project codenames or proprietary tooling into clear industry-standard descriptions unless recognized publicly.
- **Bold JD Keywords:** Bold key technologies if specifically emphasized in the JD, helping ATS parsing and recruiter scanning.

**Pattern Examples:**
- ❌ *Built and maintained telemetry pipeline with webhook ingestion and database storage*
- ✅ *Built high-throughput telemetry platform processing ~50K events/day — enabled real-time resource profiling and cost attribution across engineering teams*

### Step 7 — Tailor the Summary / Profile Section
- Lead with core professional identity and total scope of ownership.
- Eliminate empty buzzwords ("passionate", "results-driven", "synergistic"). Let facts, scale, and tools demonstrate seniority.
- Calibrate tone and voice using `/resources/meta/about.md`.
- Mirror JD terminology naturally without copy-pasting entire requirements verbatim.

### Step 8 — Tailor Education & Skills Sections
- Populate education from `/resources/educations/`.
- Reorder technical skills categories so JD-relevant competencies appear first.
- Match keywords verbatim where applicable (e.g., if JD writes "Observability", align with "Observability").
- Ensure single-column ATS-friendly structure.

### Step 9 — Write Output & Compile
- Create a timestamped output directory: `output/YYYY-MM-DD_HH-mm-ss/` (or current local datetime).
- Inside this directory, generate both formats:
  - **Markdown version**: `<company>_resume.md` (or `resume.md`)
  - **LaTeX version**: `<company>_resume.tex` (or `resume.tex`)
- If LaTeX compiler (`pdflatex`) is available:
  ```bash
  cd output/<timestamp>/ && pdflatex -interaction=nonstopmode -halt-on-error <filename>.tex
  ```
- Verify page count. If overflow occurs, trim lower-priority bullets and recompile.

### Step 10 — Debrief
Provide the user with:
1. Output file location.
2. Brief recap of tailored highlights.
3. Recommendations for cover letter or interview discussion regarding any identified gaps.

---

## Honesty Rules — NON-NEGOTIABLE

Every rule here protects candidate credibility. AI must never hallucinate:

1. **Metrics:** Every number (percentages, dollar amounts, throughput, latency) must trace directly to `/resources/experiences/`. If an experience file has directional impact without exact figures, use descriptive language only.
2. **Technologies & Skills:** Never claim a technology or tool that the candidate has not used. If a required skill is missing, surface it as a gap in the Fit Assessment.
3. **Job Titles & Scope:** Retain official titles from the resource records. Describe scope and leadership through bullet verbs, not title inflation.
4. **Credentials & Affiliations:** Only list verified community roles, certifications, and affiliations found in `/resources/meta/` or `/resources/experiences/`.
5. **Push Back on Inventions:** If requested to add unverified tools or fabricated metrics, refuse and provide an honest alternative based on verified experiences.

---

## Bullet Rewrite Mode (Standalone)

When the user asks to rewrite bullets without a full JD, apply Step 6 directly:
1. Identify the core business / technical outcome.
2. Move outcome to the front.
3. Place mechanism, tools, and architecture in the supporting clause.
4. Eliminate internal jargon and fluff.
5. Provide clear Before / After comparisons.

---

## Example Invocations

- `"Tailor my CV for this role: <JD text or URL>"` → Step 1–4 (Fit assessment), ask template (default: `ats-friendly-technical-resume`), then draft.
- `"Should I apply to this role? <JD text or URL>"` → Step 1–4 (Fit assessment only, advise whether to proceed).
- `"Rewrite these bullets impact-first: <bullets>"` → Standalone bullet rewrite mode.
- `"Overhaul my CV bullets from my experience files"` → Review `/resources/experiences/` and rewrite all key bullets impact-first.
