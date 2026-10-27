import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';
import '../../services/profile_service.dart';
import 'widgets/siswa_bottom_navigation.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({
    super.key,
    required this.user,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ============================================================
  // SERVICE & FORM
  // ============================================================

  final ProfileService _service = ProfileService();

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  // ============================================================
  // IMAGE
  // ============================================================

  File? selectedImage;

  // ============================================================
  // CONTROLLERS
  // ============================================================

  late TextEditingController namaController;
  late TextEditingController nisController;
  late TextEditingController kelasController;
  late TextEditingController jurusanController;
  late TextEditingController hpController;
  late TextEditingController alamatController;
  late TextEditingController tanggalController;
  late TextEditingController tentangSayaController;

  // ============================================================
  // STATE
  // ============================================================

  String jenisKelamin = 'Laki-laki';

  bool loading = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    namaController = TextEditingController(
      text: widget.user.nama,
    );

    nisController = TextEditingController(
      text: widget.user.nis,
    );

    kelasController = TextEditingController(
      text: widget.user.kelas,
    );

    jurusanController = TextEditingController(
      text: widget.user.jurusan,
    );

    hpController = TextEditingController(
      text: widget.user.noHp,
    );

    alamatController = TextEditingController(
      text: widget.user.alamat,
    );

    tanggalController = TextEditingController(
      text: widget.user.tanggalLahir,
    );

    tentangSayaController = TextEditingController(
      text: widget.user.tentangSaya,
    );

    jenisKelamin =
        widget.user.jenisKelamin.isEmpty
            ? 'Laki-laki'
            : widget.user.jenisKelamin;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    namaController.dispose();
    nisController.dispose();
    kelasController.dispose();
    jurusanController.dispose();
    hpController.dispose();
    alamatController.dispose();
    tanggalController.dispose();
    tentangSayaController.dispose();

    super.dispose();
  }

  // ============================================================
  // PILIH FOTO
  // ============================================================

  Future<void> pilihFoto() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );

      if (file == null) return;

      setState(() {
        selectedImage = File(file.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memilih foto: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // SIMPAN PROFIL
  // ============================================================

  Future<void> simpanProfil() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (loading) return;

    setState(() {
      loading = true;
    });

    try {
      // --------------------------------------------------------
      // DATA USER BARU
      // --------------------------------------------------------

      var updatedUser = widget.user.copyWith(
        nama: namaController.text.trim(),
        nis: nisController.text.trim(),
        kelas: kelasController.text.trim(),
        jurusan: jurusanController.text.trim(),
        noHp: hpController.text.trim(),
        alamat: alamatController.text.trim(),
        tanggalLahir: tanggalController.text.trim(),
        jenisKelamin: jenisKelamin,
        tentangSaya: tentangSayaController.text.trim(),
      );

      // --------------------------------------------------------
      // UPLOAD FOTO JIKA ADA
      // --------------------------------------------------------

      if (selectedImage != null) {
        final photoUrl = await _service.uploadPhoto(
          selectedImage!,
        );

        updatedUser = updatedUser.copyWith(
          foto: photoUrl,
        );
      }

      // --------------------------------------------------------
      // UPDATE FIREBASE
      // --------------------------------------------------------

      await _service.updateProfile(
        updatedUser,
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Profil berhasil diperbarui.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memperbarui profil: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,

        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------

      body: Form(
        key: _formKey,

        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            20,
            16,
            35,
          ),

          children: [
            // ==================================================
            // FOTO PROFIL
            // ==================================================

            _buildPhotoSection(),

            const SizedBox(height: 20),

            // ==================================================
            // DATA UTAMA
            // ==================================================

            _buildSectionCard(
              title: 'Data Pribadi',
              subtitle:
                  'Informasi dasar tentang akun Anda',
              icon: Icons.person_rounded,
              children: [
                _buildTextField(
                  controller: namaController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                  icon: Icons.person_outline_rounded,
                  required: true,
                ),

                _buildTextField(
                  controller: nisController,
                  label: 'NIS',
                  hint: 'Masukkan NIS',
                  icon: Icons.badge_outlined,
                  required: true,
                  keyboardType: TextInputType.number,
                ),

                _buildTextField(
                  controller: kelasController,
                  label: 'Kelas',
                  hint: 'Contoh: XI RPL 1',
                  icon: Icons.school_outlined,
                ),

                _buildTextField(
                  controller: jurusanController,
                  label: 'Jurusan',
                  hint: 'Contoh: Rekayasa Perangkat Lunak',
                  icon: Icons.menu_book_outlined,
                ),

                _buildGenderField(),
              ],
            ),

            const SizedBox(height: 18),

            // ==================================================
            // KONTAK
            // ==================================================

            _buildSectionCard(
              title: 'Informasi Kontak',
              subtitle:
                  'Informasi yang dapat digunakan untuk menghubungi Anda',
              icon: Icons.contact_phone_rounded,
              children: [
                _buildTextField(
                  controller: hpController,
                  label: 'Nomor HP',
                  hint: 'Contoh: 08123456789',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                _buildTextField(
                  controller: alamatController,
                  label: 'Alamat',
                  hint: 'Masukkan alamat lengkap',
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==================================================
            // INFORMASI LAHIR
            // ==================================================

            _buildSectionCard(
              title: 'Informasi Kelahiran',
              subtitle:
                  'Data tanggal lahir Anda',
              icon: Icons.cake_rounded,
              children: [
                _buildTextField(
                  controller: tanggalController,
                  label: 'Tanggal Lahir',
                  hint: 'Contoh: 12 Januari 2005',
                  icon: Icons.calendar_month_outlined,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ==================================================
            // TENTANG SAYA
            // ==================================================

            _buildSectionCard(
              title: 'Tentang Saya',
              subtitle:
                  'Ceritakan sedikit tentang diri Anda',
              icon: Icons.info_outline_rounded,
              children: [
                TextFormField(
                  controller: tentangSayaController,
                  maxLines: 6,
                  maxLength: 500,

                  textInputAction:
                      TextInputAction.newline,

                  decoration: InputDecoration(
                    labelText: 'Tentang Saya',
                    hintText:
                        'Contoh: Saya adalah siswa yang tertarik pada bidang teknologi dan pemrograman...',
                    alignLabelWithHint: true,

                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(
                        bottom: 80,
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                      ),
                    ),

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(
                        color:
                            Color(0xFF4F46E5),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Container(
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3FF),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color:
                            Color(0xFF7C3AED),
                        size: 20,
                      ),

                      SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          'Tuliskan informasi singkat mengenai diri, minat, atau hal yang ingin Anda bagikan.',
                          style: TextStyle(
                            color:
                                Color(0xFF5B21B6),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ==================================================
            // SIMPAN
            // ==================================================

            SizedBox(
              height: 54,

              child: ElevatedButton.icon(
                onPressed:
                    loading ? null : simpanProfil,

                icon: loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.save_rounded,
                      ),

                label: Text(
                  loading
                      ? 'Menyimpan...'
                      : 'Simpan Perubahan',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4F46E5),
                  foregroundColor:
                      Colors.white,
                  elevation: 0,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // BATAL
            // ==================================================

            SizedBox(
              height: 50,

              child: OutlinedButton(
                onPressed: loading
                    ? null
                    : () {
                        Navigator.pop(
                          context,
                        );
                      },

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xFF4F46E5),

                  side: const BorderSide(
                    color: Color(0xFF4F46E5),
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                child: const Text(
                  'Batal',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    
      bottomNavigationBar: SiswaBottomNavigation(
        currentIndex: 4,
      ),
);
  }

  // ============================================================
  // PHOTO SECTION
  // ============================================================

  Widget _buildPhotoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),

            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,

              border: Border.all(
                color:
                    const Color(0xFF4F46E5),
                width: 3,
              ),
            ),

            child: CircleAvatar(
              radius: 55,

              backgroundColor:
                  const Color(0xFFE0E7FF),

              backgroundImage:
                  selectedImage != null
                      ? FileImage(
                          selectedImage!,
                        )
                      : widget.user.foto
                              .isNotEmpty
                          ? NetworkImage(
                              widget.user.foto,
                            )
                          : null,

              child:
                  selectedImage == null &&
                          widget.user.foto
                              .isEmpty
                      ? const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color:
                              Color(0xFF4F46E5),
                        )
                      : null,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            'Foto Profil',
            style: const TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Gunakan foto yang jelas dan sopan',
            style: TextStyle(
              fontSize: 12,
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 15),

          OutlinedButton.icon(
            onPressed:
                loading ? null : pilihFoto,

            icon: const Icon(
              Icons.photo_camera_rounded,
            ),

            label: const Text(
              'Pilih Foto',
            ),

            style:
                OutlinedButton.styleFrom(
              foregroundColor:
                  const Color(0xFF4F46E5),

              side: const BorderSide(
                color:
                    Color(0xFF4F46E5),
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 18,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,

                decoration: BoxDecoration(
                  color:
                      const Color(0xFF4F46E5)
                          .withOpacity(.10),
                  borderRadius:
                      BorderRadius.circular(
                          13),
                ),

                child: Icon(
                  icon,
                  color:
                      const Color(0xFF4F46E5),
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w900,
                        color:
                            Color(0xFF1F2937),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),

      child: TextFormField(
        controller: controller,

        keyboardType: keyboardType,

        maxLines: maxLines,

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),

          filled: true,
          fillColor: const Color(0xFFFAFAFC),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide: BorderSide(
              color:
                  Colors.grey.shade300,
            ),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide: BorderSide(
              color:
                  Colors.grey.shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide:
                const BorderSide(
              color:
                  Color(0xFF4F46E5),
              width: 2,
            ),
          ),
        ),

        validator: required
            ? (value) {
                if (value == null ||
                    value.trim().isEmpty) {
                  return '$label wajib diisi';
                }

                return null;
              }
            : null,
      ),
    );
  }

  // ============================================================
  // JENIS KELAMIN
  // ============================================================

  Widget _buildGenderField() {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 2),

      child:
          DropdownButtonFormField<String>(
        value: jenisKelamin,

        decoration: InputDecoration(
          labelText: 'Jenis Kelamin',
          prefixIcon:
              const Icon(
            Icons.people_outline_rounded,
          ),

          filled: true,
          fillColor:
              const Color(0xFFFAFAFC),

          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide:
                BorderSide(
              color:
                  Colors.grey.shade300,
            ),
          ),

          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(15),
            borderSide:
                const BorderSide(
              color:
                  Color(0xFF4F46E5),
              width: 2,
            ),
          ),
        ),

        items: const [
          DropdownMenuItem(
            value: 'Laki-laki',
            child:
                Text('Laki-laki'),
          ),
          DropdownMenuItem(
            value: 'Perempuan',
            child:
                Text('Perempuan'),
          ),
        ],

        onChanged: loading
            ? null
            : (value) {
                if (value == null) {
                  return;
                }

                setState(() {
                  jenisKelamin = value;
                });
              },
      ),
    );
  }
}