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

  static const String fotoPengembang = 'assets/images/pengembang.JPG';
  static const String fotoPbb1 = 'assets/images/pbb1.JPG';
  static const String fotoPbb2 = 'assets/images/pbb2.jpeg';

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color purple = Color(0xFF7C3AED);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color green = Color(0xFF10B981);
  static const Color orange = Color(0xFFF59E0B);
  static const Color red = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: dark ? const Color(0xFF111827) : Colors.white,
        foregroundColor: dark ? Colors.white : const Color(0xFF111827),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: StreamBuilder<UserModel>(
        stream: _service.getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return _buildEmpty();
          }

          final user = snapshot.data!;

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final compact = width < 380;
              final horizontal = compact ? 12.0 : 16.0;

              return RefreshIndicator(
                color: primary,
                onRefresh: () async => setState(() {}),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    compact ? 12 : 16,
                    horizontal,
                    28,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileHeader(user, compact, dark),
                          const SizedBox(height: 14),
                          _buildStatistics(dark, compact),
                          const SizedBox(height: 24),
                          _buildSectionTitle(
                            icon: Icons.person_outline_rounded,
                            title: 'Informasi Profil',
                            subtitle: 'Data akun siswa',
                            dark: dark,
                          ),
                          const SizedBox(height: 10),
                          _buildProfileInformation(user, dark),
                          const SizedBox(height: 24),
                          _buildAboutSection(user, dark),
                          const SizedBox(height: 24),
                          _buildDeveloperSection(dark, compact),
                          const SizedBox(height: 24),
                          _buildActionSection(dark),
                          const SizedBox(height: 22),
                          _buildFooter(dark),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(UserModel user, bool compact, bool dark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryDark, primary, purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(compact ? 22 : 26),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: compact ? 43 : 50,
              backgroundColor: const Color(0xFFE0E7FF),
              backgroundImage:
                  user.foto.trim().isNotEmpty ? NetworkImage(user.foto) : null,
              onBackgroundImageError:
                  user.foto.trim().isNotEmpty ? (_, __) {} : null,
              child: user.foto.trim().isEmpty
                  ? Icon(
                      Icons.person_rounded,
                      size: compact ? 48 : 56,
                      color: primary,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 13),
          Text(
            user.nama.trim().isNotEmpty ? user.nama : 'Nama Siswa',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: compact ? 19 : 22,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            user.email,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: compact ? 11 : 12,
            ),
          ),
          const SizedBox(height: 11),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.school_rounded, color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  user.role.trim().isNotEmpty
                      ? user.role.toUpperCase()
                      : 'SISWA',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: compact ? 44 : 46,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(user: user),
                  ),
                );
              },
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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

  Widget _buildStatistics(bool dark, bool compact) {
    final card = dark ? const Color(0xFF182235) : Colors.white;
    final divider = dark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 5 : 8,
        vertical: compact ? 13 : 15,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: dark ? const Color(0xFF26344B) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.16 : 0.045),
            blurRadius: 18,
            offset: const Offset(0, 7),
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
              color: orange,
              dark: dark,
            ),
          ),
          _buildDivider(divider),
          Expanded(
            child: _buildStat(
              title: 'Materi',
              value: '20',
              icon: Icons.menu_book_rounded,
              color: green,
              dark: dark,
            ),
          ),
          _buildDivider(divider),
          Expanded(
            child: _buildStat(
              title: 'Ranking',
              value: '#5',
              icon: Icons.emoji_events_rounded,
              color: Colors.amber.shade700,
              dark: dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(width: 1, height: 48, color: color);
  }

  Widget _buildStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool dark,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: dark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: dark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
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
    required bool dark,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primary.withValues(alpha: 0.15),
                purple.withValues(alpha: 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
  icon,
  color: primary,
  size: 21,
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
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: dark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      dark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
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

  Widget _buildProfileInformation(UserModel user, bool dark) {
    return _sectionCard(
      dark: dark,
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

  Widget _sectionCard({
    required bool dark,
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(vertical: 5),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF182235) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark ? const Color(0xFF26344B) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.15 : 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  Widget _buildAboutSection(UserModel user, bool dark) {
    return _sectionCard(
      dark: dark,
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _miniHeader(
            icon: Icons.auto_awesome_rounded,
            title: 'Tentang Aplikasi',
            subtitle: 'Mengenal AlgoSmart',
            gradient: const [cyan, primary],
          ),
          const SizedBox(height: 15),
          Text(
            user.tentangSaya.trim().isNotEmpty
                ? user.tentangSaya
                : 'AlgoSmart merupakan media pembelajaran interaktif '
                    'berbasis Android yang membantu siswa mempelajari '
                    'Algoritma dan Pemrograman dengan cara yang lebih '
                    'mudah, menarik, dan interaktif.',
            style: TextStyle(
              color: dark ? const Color(0xFFCBD5E1) : const Color(0xFF4B5563),
              fontSize: 12.5,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: dark
                    ? [
                        const Color(0xFF312E81).withValues(alpha: 0.45),
                        const Color(0xFF1E1B4B).withValues(alpha: 0.5),
                      ]
                    : [
                        const Color(0xFFF5F3FF),
                        const Color(0xFFEDE9FE),
                      ],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: purple.withValues(alpha: dark ? 0.22 : 0.10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_rounded,
                  color: purple,
                  size: 21,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    'Belajar lebih mudah melalui materi, video, quiz, '
                    'dan latihan algoritma.',
                    style: TextStyle(
                      color:
                          dark ? const Color(0xFFC4B5FD) : const Color(0xFF5B21B6),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
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
  // DEVELOPER
  // ============================================================

  Widget _buildDeveloperSection(bool dark, bool compact) {
    return _sectionCard(
      dark: dark,
      padding: EdgeInsets.all(compact ? 15 : 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _miniHeader(
            icon: Icons.developer_mode_rounded,
            title: 'Profil Pengembang',
            subtitle: 'Pembuat media pembelajaran AlgoSmart',
            gradient: const [primary, purple],
          ),
          const SizedBox(height: 20),

          // Foto pengembang
          Center(
            child: Container(
              width: compact ? 104 : 118,
              height: compact ? 104 : 118,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [primary, purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  fotoPengembang,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: dark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE),
                    child: Icon(
                      Icons.person_rounded,
                      size: compact ? 54 : 60,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 13),
          Center(
            child: Text(
              namaPembuat,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: compact ? 19 : 21,
                fontWeight: FontWeight.w900,
                color: dark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: purple.withValues(alpha: dark ? 0.22 : 0.10),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Pembuat Media Pembelajaran',
                style: TextStyle(
                  color: purple,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 19),

          _buildDeveloperInfo(
            icon: Icons.person_rounded,
            title: 'Nama',
            value: namaPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.badge_rounded,
            title: 'NPM',
            value: npmPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.school_rounded,
            title: 'Pendidikan',
            value: pendidikanPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.account_balance_rounded,
            title: 'Fakultas',
            value: fakultasPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.camera_alt_rounded,
            title: 'Instagram',
            value: instagramPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.email_rounded,
            title: 'Email',
            value: emailPembuat,
            dark: dark,
          ),
          _buildDeveloperInfo(
            icon: Icons.phone_rounded,
            title: 'Kontak',
            value: noHpPembuat,
            dark: dark,
          ),

          const SizedBox(height: 9),
          Text(
            'Dosen Pembimbing',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: dark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Dosen pembimbing media pembelajaran',
            style: TextStyle(
              fontSize: 10,
              color: dark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 14),

          LayoutBuilder(
            builder: (context, constraints) {
              // Pada HP kecil kartu pembimbing dibuat vertikal agar
              // nama panjang tidak bertabrakan.
              if (constraints.maxWidth < 390) {
                return Column(
                  children: [
                    _buildPbbCard(
                      label: 'PBB 1',
                      name: pbb1,
                      photo: fotoPbb1,
                      dark: dark,
                    ),
                    const SizedBox(height: 10),
                    _buildPbbCard(
                      label: 'PBB 2',
                      name: pbb2,
                      photo: fotoPbb2,
                      dark: dark,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildPbbCard(
                      label: 'PBB 1',
                      name: pbb1,
                      photo: fotoPbb1,
                      dark: dark,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPbbCard(
                      label: 'PBB 2',
                      name: pbb2,
                      photo: fotoPbb2,
                      dark: dark,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _miniHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperInfo({
    required IconData icon,
    required String title,
    required String value,
    required bool dark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dark ? const Color(0xFF293548) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: purple.withValues(alpha: dark ? 0.20 : 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: purple, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: dark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  softWrap: true,
                  style: TextStyle(
                    color: dark ? const Color(0xFFE5E7EB) : const Color(0xFF1F2937),
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

  Widget _buildPbbCard({
    required String label,
    required String name,
    required String photo,
    required bool dark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dark ? const Color(0xFF293548) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primary, purple],
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                photo,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: dark ? const Color(0xFF312E81) : const Color(0xFFEDE9FE),
                  child: const Icon(
                    Icons.person_rounded,
                    color: purple,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: primary,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  name,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark ? const Color(0xFFE5E7EB) : const Color(0xFF1F2937),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
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
  // ACTION
  // ============================================================

  Widget _buildActionSection(bool dark) {
    return _sectionCard(
      dark: dark,
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _showChangePasswordDialog,
              icon: const Icon(Icons.lock_reset_rounded, size: 20),
              label: const Text(
                'Ganti Password',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: red,
                side: BorderSide(color: red.withValues(alpha: 0.35), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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

  Widget _buildFooter(bool dark) {
    return Center(
      child: Column(
        children: [
          Text(
            'AlgoSmart',
            style: TextStyle(
              color: dark ? const Color(0xFFCBD5E1) : const Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Media Pembelajaran Algoritma & Pemrograman',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: dark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '© ${DateTime.now().year} AlgoSmart',
            style: TextStyle(
              color: dark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
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
          builder: (context, setDialogState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              title: const Row(
                children: [
                  Icon(Icons.lock_reset_rounded, color: orange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Ganti Password',
                      style: TextStyle(fontWeight: FontWeight.w800),
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
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () => setDialogState(() {
                              obscure = !obscure;
                            }),
                    icon: Icon(
                      obscure ? Icons.visibility_off : Icons.visibility,
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
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final password = controller.text.trim();

                          if (password.length < 6) {
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Password minimal 6 karakter.'),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => isLoading = true);

                          try {
                            await _service.changePassword(password);

                            if (!mounted) return;

                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              const SnackBar(
                                content: Text('Password berhasil diubah.'),
                                backgroundColor: green,
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            setDialogState(() => isLoading = false);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Gagal mengubah password: $e'),
                                backgroundColor: red,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
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
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout_rounded, color: red),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
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
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout gagal: $e'),
          backgroundColor: red,
        ),
      );
    }
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildError(String error) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: red,
              size: 60,
            ),
            const SizedBox(height: 15),
            const Text(
              'Gagal Memuat Profil',
              textAlign: TextAlign.center,
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
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
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
      child: SingleChildScrollView(
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
              textAlign: TextAlign.center,
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
              onPressed: () => setState(() {}),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Muat Ulang'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
