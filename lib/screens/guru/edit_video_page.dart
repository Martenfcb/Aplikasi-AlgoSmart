import 'package:flutter/material.dart';

import '../../services/video_service.dart';

class EditVideoPage extends StatefulWidget {
  final String id;
  final String judul;
  final String deskripsi;
  final String link;

  const EditVideoPage({
    super.key,
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.link,
  });

  @override
  State<EditVideoPage> createState() => _EditVideoPageState();
}
 
class _EditVideoPageState extends State<EditVideoPage> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color violet = Color(0xFF7C3AED);

  static const Color background = Color(0xFFF6F7FB);
  static const Color textDark = Color(0xFF111827);
  static const Color textGrey = Color(0xFF667085);

  static const Color red = Color(0xFFEF4444);
  static const Color green = Color(0xFF10B981);

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late TextEditingController judulController;
  late TextEditingController deskripsiController;
  late TextEditingController linkController;

  bool loading = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    judulController = TextEditingController(
      text: widget.judul,
    );

    deskripsiController = TextEditingController(
      text: widget.deskripsi,
    );

    linkController = TextEditingController(
      text: widget.link,
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    judulController.dispose();
    deskripsiController.dispose();
    linkController.dispose();

    super.dispose();
  }

  // ============================================================
  // UPDATE VIDEO
  // ============================================================

  Future<void> updateVideo() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await VideoService().updateVideo(
        id: widget.id,
        judul: judulController.text.trim(),
        deskripsi: deskripsiController.text.trim(),
        link: linkController.text.trim(),
      );

      if (!mounted) return;

      _showSuccess();

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      _showError(
        _cleanErrorMessage(e),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  String _cleanErrorMessage(Object error) {
    String message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.substring(11);
    }

    return message.isEmpty
        ? 'Gagal memperbarui video.'
        : message;
  }

  // ============================================================
  // SUCCESS
  // ============================================================

  void _showSuccess() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: green,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Video berhasil diperbarui.',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: red,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,

        leading: Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: IconButton(
            onPressed: loading
                ? null
                : () {
                    Navigator.pop(context);
                  },
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(13),
                border: Border.all(
                  color: const Color(0xFFE7E8EF),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: textDark,
                size: 21,
              ),
            ),
          ),
        ),

        titleSpacing: 8,

        title: const Text(
          'Edit Video',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final width = constraints.maxWidth;

            final horizontalPadding =
                width >= 700 ? 32.0 : 18.0;

            final maxWidth =
                width >= 900 ? 720.0 : double.infinity;

            return SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                35,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // HEADER CARD
                        // ==================================================

                        _buildHeaderCard(),

                        const SizedBox(height: 18),

                        // ==================================================
                        // FORM CARD
                        // ==================================================

                        _buildFormCard(),

                        const SizedBox(height: 18),

                        // ==================================================
                        // LINK PREVIEW
                        // ==================================================

                        _buildLinkInfo(),

                        const SizedBox(height: 20),

                        // ==================================================
                        // UPDATE BUTTON
                        // ==================================================

                        _buildUpdateButton(),

                        const SizedBox(height: 15),

                        // ==================================================
                        // INFO
                        // ==================================================

                        _buildInfo(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER CARD
  // ============================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryDark,
            primary,
            violet,
          ],
        ),
        borderRadius:
            BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(
              alpha: .20,
            ),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // DEKORASI

          Positioned(
            right: -35,
            top: -45,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .06,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            left: -45,
            bottom: -70,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: .04,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Row(
            children: [
              // ICON
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(
                    alpha: .13,
                  ),
                  borderRadius:
                      BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.white.withValues(
                      alpha: .15,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.video_settings_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(width: 14),

              // TEXT
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Video',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Perbarui informasi video pembelajaran.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORM CARD
  // ============================================================

  Widget _buildFormCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE7E8EF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // TITLE

          const Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: primary,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Informasi Video',
                style: TextStyle(
                  color: textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ======================================================
          // JUDUL
          // ======================================================

          _buildLabel(
            'Judul Video',
            Icons.title_rounded,
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: judulController,
            textInputAction:
                TextInputAction.next,
            maxLength: 100,
            decoration: _inputDecoration(
              hint:
                  'Masukkan judul video',
              icon:
                  Icons.video_library_rounded,
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Judul video wajib diisi.';
              }

              if (value.trim().length < 3) {
                return 'Judul video minimal 3 karakter.';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // ======================================================
          // DESKRIPSI
          // ======================================================

          _buildLabel(
            'Deskripsi',
            Icons.description_rounded,
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: deskripsiController,
            textInputAction:
                TextInputAction.newline,
            maxLines: 5,
            maxLength: 500,
            decoration: _inputDecoration(
              hint:
                  'Masukkan deskripsi video',
              icon:
                  Icons.description_rounded,
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null ||
                  value.trim().isEmpty) {
                return 'Deskripsi wajib diisi.';
              }

              if (value.trim().length < 5) {
                return 'Deskripsi minimal 5 karakter.';
              }

              return null;
            },
          ),

          const SizedBox(height: 14),

          // ======================================================
          // LINK
          // ======================================================

          _buildLabel(
            'Link Video',
            Icons.link_rounded,
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: linkController,
            keyboardType:
                TextInputType.url,
            textInputAction:
                TextInputAction.done,
            decoration: _inputDecoration(
              hint:
                  'https://youtu.be/xxxx',
              icon:
                  Icons.link_rounded,
            ),
            validator: (value) {
              final link =
                  value?.trim() ?? '';

              if (link.isEmpty) {
                return 'Link video wajib diisi.';
              }

              final uri =
                  Uri.tryParse(link);

              if (uri == null ||
                  !uri.hasScheme ||
                  !uri.hasAuthority) {
                return 'Masukkan link video yang valid.';
              }

              if (uri.scheme != 'http' &&
                  uri.scheme != 'https') {
                return 'Link harus menggunakan http atau https.';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(
    String text,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: primary.withValues(
              alpha: .08,
            ),
            borderRadius:
                BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 16,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          text,
          style: const TextStyle(
            color: textDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: const TextStyle(
        color: Color(0xFFA0A4B2),
        fontSize: 12,
      ),

      alignLabelWithHint:
          alignLabelWithHint,

      prefixIcon: Padding(
        padding: const EdgeInsets.only(
          left: 12,
          right: 8,
        ),
        child: Icon(
          icon,
          color: primary,
          size: 20,
        ),
      ),

      prefixIconConstraints:
          const BoxConstraints(
        minWidth: 48,
      ),

      filled: true,

      fillColor:
          const Color(0xFFF8F9FC),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 15,
      ),

      counterStyle: const TextStyle(
        color: textGrey,
        fontSize: 9,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xFFE6E8F0),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: primary,
          width: 1.4,
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: red,
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: red,
          width: 1.4,
        ),
      ),

      errorStyle: const TextStyle(
        color: red,
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ============================================================
  // LINK INFO
  // ============================================================

  Widget _buildLinkInfo() {
    return ValueListenableBuilder<
        TextEditingValue>(
      valueListenable: linkController,
      builder: (
        context,
        value,
        child,
      ) {
        final link = value.text.trim();

        if (link.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color: red.withValues(
                alpha: .10,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: red.withValues(
                    alpha: .10,
                  ),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: red,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Link Video',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Link akan digunakan untuk memutar video pembelajaran.',
                      style: TextStyle(
                        color: textGrey,
                        fontSize: 9,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // UPDATE BUTTON
  // ============================================================

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed:
            loading ? null : updateVideo,
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          disabledBackgroundColor:
              primary.withValues(
            alpha: .45,
          ),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primary.withValues(
            alpha: .25,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 21,
                    height: 21,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.3,
                      valueColor:
                          AlwaysStoppedAnimation<
                              Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Menyimpan...',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                ],
              )
            : const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.save_rounded,
                    size: 20,
                  ),
                  SizedBox(width: 9),
                  Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // INFO
  // ============================================================

  Widget _buildInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: primary,
            size: 19,
          ),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'Pastikan judul, deskripsi, dan link video sudah benar sebelum menyimpan perubahan.',
              style: TextStyle(
                color: Color(0xFF4338CA),
                fontSize: 9.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}