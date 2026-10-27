import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/profile_service.dart';
import '../../widgets/profile_item.dart';
import '../auth/login_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileService _service = ProfileService();

  // ============================================================
  // DATA PROFIL PENGEMBANG
  // ============================================================

  static const String namaPembuat = 'Februari Risma';
  static const String npmPembuat = '2201100086';
  static const String instagramPembuat = 'Februari_Risma21';
  static const String emailPembuat = 'februaririsma@gmail.com';
  static const String noHpPembuat = '085169170802';
  static const String pendidikanPembuat = 'Informatika';
  static const String fakultasPembuat = 'Sains dan Teknologi';

  static const String pbb1 = 'Heri Mulyono, M.Pd';
  static const String pbb2 = 'Ami Anggraini Samudra, S.Pd., M.Si';

  // ============================================================
  // PATH FOTO
  // ============================================================

  static const String fotoPengembang = 'assets/images/pengembang.JPG';
  static const String fotoPbb1 = 'assets/images/pbb1.JPG';
  static const String fotoPbb2 = 'assets/images/pbb2.jpeg';

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      body: StreamBuilder<UserModel>(
        stream: _service.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF4F46E5),
              ),
            );
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildEmpty();
          }

          final user = snapshot.data!;

          return RefreshIndicator(
            color: const Color(0xFF4F46E5),
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                14,
                16,
                14,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PROFIL SAYA
                  // ==================================================

                  _buildProfileHeader(user),

                  const SizedBox(height: 14),

                  // ==================================================
                  // STATISTIK
                  // ==================================================

                  _buildStatistics(),

                  const SizedBox(height: 22),

                  // ==================================================
                  // INFORMASI PROFIL
                  // ==================================================

                  _buildSectionTitle(
                    icon: Icons.person_outline_rounded,
                    title: 'Informasi Profil',
                    subtitle: 'Informasi akun siswa',
                  ),

                  const SizedBox(height: 10),

                  _buildProfileInformation(user),

                  const SizedBox(height: 22),

                  // ==================================================
                  // TENTANG APLIKASI
                  // ==================================================

                  _buildAboutSection(user),

                  const SizedBox(height: 22),

                  // ==================================================
                  // PROFIL PENGEMBANG
                  // ==================================================

                  _buildDeveloperSection(),

                  const SizedBox(height: 22),

                  // ==================================================
                  // AKSI AKUN
                  // ==================================================

                  _buildActionSection(),

                  const SizedBox(height: 25),

                  // ==================================================
                  // FOOTER
                  // ==================================================

                  _buildFooter(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        22,
        18,
        18,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF6366F1),
            Color(0xFF7C3AED),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        children: [
          // FOTO SISWA
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 14,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFFE0E7FF),
              backgroundImage: user.foto.isNotEmpty
                  ? NetworkImage(user.foto)
                  : null,
              child: user.foto.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 54,
                      color: Color(0xFF4F46E5),
                    )
                  : null,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            user.nama.isNotEmpty ? user.nama : 'Nama Siswa',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            user.email,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 12),

          // ROLE
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  user.role.isNotEmpty
                      ? user.role.toUpperCase()
                      : 'SISWA',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // EDIT PROFIL
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      user: user,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_rounded,
                size: 18,
              ),
              label: const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF4F46E5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              title: 'Quiz',
              value: '12',
              icon: Icons.quiz_rounded,
              color: Colors.orange,
            ),
          ),

          _buildDivider(),

          Expanded(
            child: _buildStat(
              title: 'Materi',
              value: '20',
              icon: Icons.menu_book_rounded,
              color: Colors.green,
            ),
          ),

          _buildDivider(),

          Expanded(
            child: _buildStat(
              title: 'Ranking',
              value: '#5',
              icon: Icons.emoji_events_rounded,
              color: Colors.amber.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 50,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.11),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1F2937),
          ),
        ),

        const SizedBox(height: 1),

        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF4F46E5),
            size: 21,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F2937),
                ),
              ),

              const SizedBox(height: 2),

              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PROFILE INFORMATION
  // ============================================================

  Widget _buildProfileInformation(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileItem(
            icon: Icons.badge_rounded,
            title: 'NIS',
            value: user.nis,
          ),

          ProfileItem(
            icon: Icons.email_rounded,
            title: 'Email',
            value: user.email,
          ),

          ProfileItem(
            icon: Icons.school_rounded,
            title: 'Kelas',
            value: user.kelas,
          ),

          ProfileItem(
            icon: Icons.menu_book_rounded,
            title: 'Jurusan',
            value: user.jurusan,
          ),

          ProfileItem(
            icon: Icons.phone_rounded,
            title: 'Nomor HP',
            value: user.noHp,
          ),

          ProfileItem(
            icon: Icons.location_on_rounded,
            title: 'Alamat',
            value: user.alamat,
          ),

          ProfileItem(
            icon: Icons.people_rounded,
            title: 'Jenis Kelamin',
            value: user.jenisKelamin,
          ),

          ProfileItem(
            icon: Icons.cake_rounded,
            title: 'Tanggal Lahir',
            value: user.tanggalLahir,
          ),

          ProfileItem(
            icon: Icons.calendar_month_rounded,
            title: 'Tanggal Bergabung',
            value: user.createdAt != null
                ? '${user.createdAt!.day}/${user.createdAt!.month}/${user.createdAt!.year}'
                : '-',
          ),

          ProfileItem(
            icon: Icons.fingerprint_rounded,
            title: 'User ID',
            value: user.uid,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TENTANG APLIKASI
  // ============================================================

  Widget _buildAboutSection(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF06B6D4),
                      Color(0xFF3B82F6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mengenal AlgoSmart',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            user.tentangSaya.isNotEmpty
                ? user.tentangSaya
                : 'AlgoSmart merupakan media pembelajaran interaktif '
                    'berbasis Android yang membantu siswa mempelajari '
                    'Algoritma dan Pemrograman dengan cara yang lebih '
                    'mudah, menarik, dan interaktif.',
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 12.5,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFF7C3AED),
                  size: 21,
                ),

                SizedBox(width: 9),

                Expanded(
                  child: Text(
                    'Belajar lebih mudah melalui materi, video, '
                    'quiz external, dan latihan algoritma.',
                    style: TextStyle(
                      color: Color(0xFF5B21B6),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROFIL PENGEMBANG
  // ============================================================

  Widget _buildDeveloperSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // HEADER
          // ========================================================

          Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4F46E5),
                      Color(0xFF7C3AED),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.developer_mode_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Pengembang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1F2937),
                      ),
                    ),

                    SizedBox(height: 2),

                    Text(
                      'Pembuat media pembelajaran AlgoSmart',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ========================================================
          // FOTO PENGEMBANG
          // ========================================================

          Center(
            child: Container(
              width: 115,
              height: 115,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4F46E5),
                    Color(0xFF8B5CF6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4F46E5)
                        .withValues(alpha: 0.20),
                    blurRadius: 18,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  fotoPengembang,
                  fit: BoxFit.cover,
                  errorBuilder: (
                    context,
                    error,
                    stackTrace,
                  ) {
                    return Container(
                      color: const Color(0xFFEDE9FE),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 58,
                        color: Color(0xFF4F46E5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 13),

          const Center(
            child: Text(
              namaPembuat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE9FE),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Pembuat Media Pembelajaran',
                style: TextStyle(
                  color: Color(0xFF6D28D9),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ========================================================
          // DATA PENGEMBANG
          // ========================================================

          _buildDeveloperInfo(
            icon: Icons.person_rounded,
            title: 'Nama',
            value: namaPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.badge_rounded,
            title: 'NPM',
            value: npmPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.school_rounded,
            title: 'Pendidikan',
            value: pendidikanPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.account_balance_rounded,
            title: 'Fakultas',
            value: fakultasPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.camera_alt_rounded,
            title: 'Instagram',
            value: instagramPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.email_rounded,
            title: 'Email',
            value: emailPembuat,
          ),

          _buildDeveloperInfo(
            icon: Icons.phone_rounded,
            title: 'Kontak',
            value: noHpPembuat,
          ),

          const SizedBox(height: 10),

          // ========================================================
          // PEMBIMBING
          // ========================================================

          const Text(
            'Dosen Pembimbing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Dosen pembimbing media pembelajaran',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 14),

          // ========================================================
          // PBB 1 & PBB 2
          // ========================================================

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildPbbCard(
                  label: 'PBB 1',
                  name: pbb1,
                  photo: fotoPbb1,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildPbbCard(
                  label: 'PBB 2',
                  name: pbb2,
                  photo: fotoPbb2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMASI PENGEMBANG
  // ============================================================

  Widget _buildDeveloperInfo({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6366F1),
              size: 19,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  softWrap: true,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // KARTU PBB
  // ============================================================

  Widget _buildPbbCard({
    required String label,
    required String name,
    required String photo,
  }) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        children: [
          // FOTO
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFF8B5CF6),
                ],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                photo,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: const Color(0xFFEDE9FE),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Color(0xFF6D28D9),
                      size: 34,
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 9),

          // LABEL
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION SECTION
  // ============================================================

  Widget _buildActionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // GANTI PASSWORD
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _showChangePasswordDialog,
              icon: const Icon(
                Icons.lock_reset_rounded,
                size: 20,
              ),
              label: const Text(
                'Ganti Password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // LOGOUT
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(
                Icons.logout_rounded,
                size: 20,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(
                  color: Colors.red.shade200,
                  width: 1.2,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          const Text(
            'AlgoSmart',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Media Pembelajaran Algoritma & Pemrograman',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            '© ${DateTime.now().year} AlgoSmart',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  Future<void> _showChangePasswordDialog() async {
    final controller = TextEditingController();

    bool obscure = true;
    bool isLoading = false;

    await showDialog(
      context: context,
      barrierDismissible: !isLoading,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            context,
            setDialogState,
          ) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              title: const Row(
                children: [
                  Icon(
                    Icons.lock_reset_rounded,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ganti Password',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              content: TextField(
                controller: controller,
                obscureText: obscure,
                enabled: !isLoading,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  hintText: 'Minimal 6 karakter',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                  ),
                  suffixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setDialogState(() {
                              obscure = !obscure;
                            });
                          },
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text('Batal'),
                ),

                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final password =
                              controller.text.trim();

                          if (password.length < 6) {
                            ScaffoldMessenger.of(
                              this.context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password minimal 6 karakter.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() {
                            isLoading = true;
                          });

                          try {
                            await _service.changePassword(
                              password,
                            );

                            if (!mounted) return;

                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(
                              this.context,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Password berhasil diubah.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            setDialogState(() {
                              isLoading = false;
                            });

                            ScaffoldMessenger.of(
                              this.context,
                            ).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal mengubah password: $e',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    controller.dispose();
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Colors.red,
              ),

              SizedBox(width: 10),

              Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Batal'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    try {
      await _service.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logout gagal: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.red,
              size: 60,
            ),

            const SizedBox(height: 15),

            const Text(
              'Gagal Memuat Profil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Coba Lagi',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 15),

            const Text(
              'Data profil tidak ditemukan',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Silakan coba muat ulang halaman.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(
                Icons.refresh_rounded,
              ),
              label: const Text(
                'Muat Ulang',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}