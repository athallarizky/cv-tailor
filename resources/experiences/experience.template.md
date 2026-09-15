---
# ==============================================================================
# Core Metadata (Wajib - Digunakan langsung pada template subheader LaTeX/ATS)
# ==============================================================================
company: "Nama Perusahaan / Organisasi (contoh: Kitabisa / Tech Corp)"
role: "Jabatan / Posisi Resmi (contoh: Senior Platform Engineer / Software Engineer)"
location: "Kota, Negara atau Format Kerja (contoh: Jakarta, Indonesia / Remote / Hybrid)"
employment_type: "Full-time" # Pilihan: Full-time | Contract | Internship | Freelance | Part-time
start_date: "Bulan Tahun (contoh: Jan 2021)"
end_date: "Bulan Tahun atau Present (contoh: Present)"
is_current: true # true jika masih aktif bekerja di sini

# ==============================================================================
# Organization & Team Context (Membantu AI memahami domain bisnis & skala)
# ==============================================================================
industry: "Crowdfunding / Fintech / E-commerce / SaaS / Edutech"
company_scale: "Contoh: 150+ engineers, 5M+ active users, high-traffic production"
team: "Platform Engineering / Core Backend / Infrastructure / Data"

# ==============================================================================
# Tech Stack & Keywords (Penting untuk pencocokan ATS Keywords)
# ==============================================================================
skills_used:
  - Go
  - Kubernetes
  - AWS
  - Docker
  - PostgreSQL
  - Terraform
  - CI/CD (GitHub Actions)
  - Prometheus / Grafana

# ==============================================================================
# Prioritas & Filter Ruang (Membantu AI saat trimming 1-2 halaman)
# ==============================================================================
featured: true # true: role utama/terkini; false: role lama/minor yang bisa di-compress ke 2 bullet jika ruang sempit
overlap_risk: false # true jika role ini berjalan bersamaan/overlap dengan pekerjaan lain (flag moonlighting)
---

# Ringkasan Tanggung Jawab Utama (BAU Ownership)

> Tuliskan 1–2 kalimat pernyataan kepemilikan sistem utama (*system ownership*). Untuk role utama, bullet pertama CV berfokus pada apa yang Anda miliki (*Own/Run/Lead*), bukan sekadar apa yang Anda bangun.

- Bertanggung jawab penuh (*end-to-end ownership*) atas keandalan infrastruktur Kubernetes, pipeline CI/CD untuk 100+ engineer, dan sistem observabilitas produksi.

---

# Daftar Pencapaian / Brag Items (Ground Truth Konten CV)

> Tuliskan setiap project atau inisiatif penting menggunakan format di bawah ini. AI akan mengekstrak bagian ini menjadi bullet point berformat **XYZ (Outcome, Metric, Mechanism)**:

### 1. [Nama Inisiatif / Project 1 - Contoh: Modernisasi Runner CI/CD]
- **What I Did**: Merancang ulang infrastruktur runner GitHub Actions menggunakan `actions-runner-controller` di atas Kubernetes dengan autoscaling berbasis EC2 Spot instances dan fallback On-Demand.
- **Impact**: Menghemat biaya operasional CI hingga 50% ($60K/tahun menjadi $30K/tahun) tanpa penurunan SLA antrean pipeline.
- **Context**: Sebelumnya menggunakan runner on-demand dengan utilisasi rendah saat malam dan antrean panjang saat jam kerja sibuk.
- **Framing Notes**:
  - *Untuk target role SRE / DevOps*: Tekankan autoscaling spot, zero downtime cutover, dan keandalan antrean.
  - *Untuk target role FinOps / Engineering Manager*: Tekankan penghematan biaya riil ($30K/thn) dan efisiensi resource.

---

### 2. [Nama Inisiatif / Project 2 - Contoh: Migrasi Arsitektur / Optimasi Database]
- **What I Did**: Melakukan optimasi query kompleks dan re-indexing pada tabel transaksi utama PostgreSQL berukuran multi-gigabyte, serta menambahkan caching layer berbasis Redis.
- **Impact**: Mengurangi p99 latency query API transaksi dari 850ms menjadi 120ms dan memangkas beban CPU database sebesar 40%.
- **Context**: Lonjakan trafik donasi/transaksi saat event besar menyebabkan bottleneck pada database utama.
- **Framing Notes**:
  - *Untuk target role Backend*: Tekankan pola indexing, query plan profiling, dan data consistency.
  - *Untuk target role Database / Infra*: Tekankan pengurangan IOPS dan stabilitas database saat peak traffic.

---

### 3. [Nama Inisiatif / Project 3 - Tambahkan project lainnya...]
- **What I Did**: [Langkah teknis nyata, tools/arsitektur yang digunakan]
- **Impact**: [Angka/metrik nyata yang terukur: %, $, latency, throughput. Jangan karang angka jika tidak ada data pasti, gunakan dampak terarah kualitatif]
- **Context**: [Latar belakang masalah, arsitektur lama, atau tantangan bisnis]
- **Framing Notes**: [Panduan sudut pandang jika melamar ke jenis posisi tertentu]
