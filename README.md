# SQLearning

## Media Pembelajaran Interaktif Berbasis Android pada Materi Algoritma dan Pemrograman

### Deskripsi

SQLearning merupakan aplikasi media pembelajaran interaktif berbasis Android yang dikembangkan untuk membantu proses pembelajaran mata pelajaran Algoritma dan Pemrograman di SMK Negeri 1 Sijunjung.

Aplikasi ini dibangun menggunakan Flutter dan Firebase sehingga dapat memberikan pengalaman belajar yang modern, interaktif, dan mudah digunakan oleh guru maupun siswa.

---

## Tujuan Pengembangan

1. Membantu guru dalam mengelola materi pembelajaran.
2. Membantu siswa memahami materi Algoritma dan Pemrograman secara mandiri.
3. Menyediakan media pembelajaran yang interaktif melalui materi, video, quiz, dan simulasi SQL.
4. Meningkatkan minat belajar siswa melalui teknologi mobile learning.

---

## Teknologi yang Digunakan

### Frontend

* Flutter
* Dart

### Backend

* Firebase Authentication
* Cloud Firestore
* Firebase Storage

### Database

* Cloud Firestore

---

# Fitur Aplikasi

## 1. Sistem Autentikasi

### Login

* Login menggunakan email dan password.
* Terintegrasi dengan Firebase Authentication.

### Register

* Registrasi akun siswa baru.
* Data pengguna disimpan ke Firebase Firestore.

---

## 2. Dashboard Guru

Dashboard utama untuk guru yang berfungsi sebagai pusat pengelolaan aplikasi.

### Fitur Dashboard Guru

* Statistik jumlah materi
* Statistik jumlah quiz
* Statistik jumlah video
* Ringkasan sistem
* Aktivitas terbaru

---

## 3. Kelola Materi

Guru dapat mengelola materi pembelajaran.

### Fitur

* Tambah materi
* Edit materi
* Hapus materi
* Lihat daftar materi

### Data Tersimpan

Collection Firestore:

```text
materi
```

Field:

```json
{
  "judul": "",
  "isi": "",
  "createdAt": ""
}
```

---

## 4. Kelola Video Pembelajaran

Guru dapat menambahkan video pembelajaran berbasis YouTube.

### Fitur

* Tambah video
* Edit video
* Hapus video
* Menampilkan thumbnail video
* Memutar video langsung di aplikasi tanpa membuka YouTube

### Data Tersimpan

```text
video
```

```json
{
  "judul": "",
  "deskripsi": "",
  "url": "",
  "thumbnail": "",
  "createdAt": ""
}
```

---

## 5. Kelola Quiz

Guru dapat mengelola soal quiz.

### Fitur

* Tambah quiz
* Edit quiz
* Hapus quiz
* Menampilkan daftar soal

### Data Tersimpan

```text
quiz
```

```json
{
  "soal": "",
  "opsiA": "",
  "opsiB": "",
  "opsiC": "",
  "jawaban": "",
  "createdAt": ""
}
```

---

## 6. CP dan ATP

Menyediakan informasi terkait:

### CP

Capaian Pembelajaran

### ATP

Alur Tujuan Pembelajaran

### Fitur

* Menampilkan daftar CP
* Menampilkan daftar ATP
* Tampilan expandable card

### Data Tersimpan

```text
cp_atp
```

---

## 7. Ranking Nilai Siswa

Guru dapat melihat ranking nilai siswa berdasarkan hasil quiz.

### Fitur

* Ranking otomatis
* Urut berdasarkan nilai tertinggi
* Menampilkan peringkat siswa

### Data Tersimpan

```text
hasil_quiz
```

---

## 8. Dashboard Siswa

Dashboard utama siswa.

### Menu Dashboard

* Materi Pembelajaran
* Video Pembelajaran
* Quiz
* Simulasi SQL
* Nilai
* Profil

---

## 9. Materi Pembelajaran

Siswa dapat membaca seluruh materi yang telah diunggah oleh guru.

### Fitur

* Daftar materi
* Detail materi
* Tampilan responsif

---

## 10. Video Pembelajaran

Siswa dapat menonton video pembelajaran.

### Fitur

* Menampilkan daftar video
* Menampilkan thumbnail
* Memutar video langsung di aplikasi

---

## 11. Quiz Interaktif

Siswa dapat mengerjakan quiz yang telah dibuat oleh guru.

### Fitur

* Menampilkan soal
* Memilih jawaban
* Menampilkan skor

---

## 12. Nilai Siswa

Siswa dapat melihat hasil quiz yang telah dikerjakan.

### Fitur

* Riwayat nilai
* Nilai quiz
* Rekap hasil belajar

---

## 13. Profil Pengguna

Menampilkan informasi pengguna yang sedang login.

### Fitur

* Nama
* Email
* Role
* Logout

### Data Tersimpan

```text
users
```

```json
{
  "uid": "",
  "nama": "",
  "email": "",
  "role": ""
}
```

---

## 14. Simulasi SQL

Fitur unggulan aplikasi SQLearning.

### Tujuan

Membantu siswa memahami dasar-dasar query SQL secara interaktif.

### Query yang Didukung

```sql
SELECT * FROM siswa;
```

```sql
SELECT nama FROM siswa;
```

### Output

Hasil query ditampilkan langsung pada aplikasi.

---

# Struktur Database Firestore

## users

```json
{
  "uid": "",
  "nama": "",
  "email": "",
  "role": "guru/siswa"
}
```

## materi

```json
{
  "judul": "",
  "isi": "",
  "createdAt": ""
}
```

## video

```json
{
  "judul": "",
  "deskripsi": "",
  "url": "",
  "thumbnail": "",
  "createdAt": ""
}
```

## quiz

```json
{
  "soal": "",
  "opsiA": "",
  "opsiB": "",
  "opsiC": "",
  "jawaban": "",
  "createdAt": ""
}
```

## hasil_quiz

```json
{
  "uid": "",
  "nama": "",
  "nilai": "",
  "createdAt": ""
}
```

## cp_atp

```json
{
  "judul": "",
  "kategori": "CP/ATP",
  "isi": ""
}
```

---

# Kelebihan Aplikasi

* Antarmuka modern dan responsif
* Berbasis Android menggunakan Flutter
* Terintegrasi Firebase
* Mendukung pembelajaran mandiri
* Menyediakan video pembelajaran
* Menyediakan quiz interaktif
* Menyediakan simulasi SQL
* Mendukung pembelajaran Algoritma dan Pemrograman

---

# Pengembang

SQLearning

Media Pembelajaran Interaktif Berbasis Android Pada Materi Algoritma dan Pemrograman

SMK Negeri 1 Sijunjung

Dikembangkan menggunakan Flutter dan Firebase.
