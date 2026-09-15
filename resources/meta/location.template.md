---
# ==============================================================================
# Location Metadata
# ==============================================================================
city: "Kota Domisili (contoh: Jakarta / Bandung / Tangerang)"
province: "Provinsi (contoh: DKI Jakarta / Jawa Barat)"
country: "Negara (contoh: Indonesia)"
postal_code: ""

# Format tampilan lokasi pada CV (pilih salah satu sesuai kebutuhan target pasar)
# - Lokal/Nasional: "Kota, Provinsi" atau "Jabodetabek / Kota"
# - Regional/Internasional: "Kota, Negara" atau "Greater Jakarta, Indonesia"
# - Remote Role: "Indonesia (UTC+7)"
default_display: "Kota, Negara"
international_display: "Greater Jakarta, Indonesia / Remote (UTC+7)"

# ==============================================================================
# Timezone & Availability (Penting untuk Remote & Global Companies)
# ==============================================================================
timezone: "Asia/Jakarta (UTC+7 / WIB)"
working_hours_overlap: "Flexible / Open to overlap with APAC, EMEA, or US timezones"

# ==============================================================================
# Work Preferences & Mobility
# ==============================================================================
work_type_preference:
  - "Remote"
  - "Hybrid"
  - "On-site"

willing_to_relocate: true # Ubah ke false jika tidak bersedia pindah kota/negara
relocation_destinations:
  - "Jakarta / Jabodetabek"
  - "Singapore / Overseas"
  - "Remote worldwide"

work_authorization: "Indonesian Citizen (Eligible to work in Indonesia; Requires visa sponsorship for overseas on-site)"
---

# Catatan Penggunaan Lokasi untuk AI

File ini membantu AI menentukan bagaimana lokasi Anda dicantumkan di CV berdasarkan tipe lowongan kerja (JD):

1. **Lowongan Lokal**:
   - AI akan menampilkan format standar seperti `Kota, Negara` atau `Jabodetabek`.
2. **Lowongan Internasional / Remote**:
   - Jika JD berbasis remote global, AI dapat menggunakan format yang lebih dikenal secara global seperti `Greater Jakarta, Indonesia` atau menyertakan timezone `(UTC+7)`.
3. **Penyaringan Relevansi**:
   - AI akan menggunakan informasi `willing_to_relocate` dan `work_authorization` saat melakukan *Fit Assessment* (Step 4) untuk mengecek apakah lowongan yang mensyaratkan domisili/visa on-site luar negeri cocok untuk Anda.
