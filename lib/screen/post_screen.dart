import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/screen/home_screen.dart';
import 'package:flutter_application_1/screen/globals.dart' as globals;

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  XFile? _pickedImage;
  Uint8List? _pickedImageBytes;
  bool _isPosting = false;

  static const int _maxChars = 500;

  // Curated expressive emojis for quick mood insertion
  final List<String> _quickEmojis = [
    '🖤', '🌙', '✨', '💭', '🤫', '🔥',
    '💀', '👀', '🥀', '⚡', '☕', '🎶',
    '😴', '😶‍🌫️', '💔', '💫', '🫠', '🫡',
    '🥹', '🤐', '🫂', '🕊️', '🌧️', '🪐',
  ];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  bool get _hasDraftContent {
    return _textController.text.trim().isNotEmpty || _pickedImage != null;
  }

  bool get _canSubmit {
    final text = _textController.text.trim();
    final hasContent = text.isNotEmpty || _pickedImage != null;
    final isWithinLimit = _textController.text.length <= _maxChars;
    return hasContent && isWithinLimit && !_isPosting;
  }

  Future<void> _pickImage(ImageSource source) async {
    HapticFeedback.lightImpact();
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedImage = picked;
          _pickedImageBytes = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal memilih gambar: $e"),
          backgroundColor: const Color(0xFF22242E),
        ),
      );
    }
  }

  void _insertEmoji(String emoji) {
    HapticFeedback.selectionClick();
    final text = _textController.text;
    final selection = _textController.selection;
    if (selection.start >= 0 && selection.end >= selection.start) {
      final newText = text.replaceRange(selection.start, selection.end, emoji);
      _textController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + emoji.length),
      );
    } else {
      final newText = '$text$emoji';
      _textController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  void _showEmojiSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14151C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        side: BorderSide(color: Color(0xFF272932), width: 1),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF383B48),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    "Pilih Ekspresi & Emoji",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _quickEmojis.length,
                  itemBuilder: (context, index) {
                    final emoji = _quickEmojis[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        _insertEmoji(emoji);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1D28),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2A2E3D),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF14151C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        side: BorderSide(color: Color(0xFF272932), width: 1),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF383B48),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "Lampirkan Gambar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F212D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2E3240)),
                    ),
                    child: const Icon(
                      Icons.photo_library_outlined,
                      color: Color(0xFFFFAA20),
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    "Pilih dari Galeri",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Pilih foto tersimpan dari perangkatmu",
                    style: TextStyle(
                      color: Color(0xFF8E92A8),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F212D),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF2E3240)),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xFFFFAA20),
                      size: 24,
                    ),
                  ),
                  title: const Text(
                    "Ambil Foto Baru",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    "Buka kamera dan ambil foto sekarang",
                    style: TextStyle(
                      color: Color(0xFF8E92A8),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasDraftContent) {
      return true;
    }

    final shouldDiscard = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF14151C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        side: BorderSide(color: Color(0xFF272932), width: 1),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF383B48),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  "Buang draf postingan?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Teks atau gambar yang sudah kamu masukkan akan hilang jika keluar sekarang.",
                  style: TextStyle(
                    color: Color(0xFF8E92A8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          side: const BorderSide(color: Color(0xFF343848)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          backgroundColor: const Color(0xFF1A1C24),
                        ),
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text(
                          "Lanjut Menulis",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: const Color(0xFFD32F2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text(
                          "Buang Draf",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    return shouldDiscard ?? false;
  }

  Future<void> _handlePost() async {
    final text = _textController.text.trim();
    if (text.isEmpty && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tulis sesuatu atau pilih gambar untuk diposting"),
          backgroundColor: Color(0xFF1B1C22),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_textController.text.length > _maxChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Panjang postingan melebihi batas 500 karakter"),
          backgroundColor: Color(0xFFD32F2F),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isPosting = true;
    });

    try {
      await _publishPost(
        text: text,
        imageUrl: _pickedImage?.path,
        imageBytes: _pickedImageBytes,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFFFFAA20), size: 18),
              SizedBox(width: 8),
              Text(
                "Postingan berhasil dibagikan",
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF181A22),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF2A2D3A)),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memposting: $e"),
            backgroundColor: const Color(0xFFD32F2F),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Future<void> _publishPost({
    required String text,
    required String? imageUrl,
    Uint8List? imageBytes,
  }) async {
    final docUser = FirebaseFirestore.instance.collection('post').doc();

    String? downloadUrl;
    if (imageBytes != null || imageUrl != null) {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      if (imageBytes != null) {
        final uploadTask = await storageReference.putData(
          imageBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        downloadUrl = await uploadTask.ref.getDownloadURL();
      } else if (!kIsWeb && imageUrl != null) {
        await storageReference.putFile(File(imageUrl));
        downloadUrl = await storageReference.getDownloadURL();
      }
    }

    // Every post is inherently anonymous by design
    final Map<String, dynamic> data = {
      'name': 'Anonim',
      'text': text,
      'date': DateTime.now().toString(),
      'url': '',
      'uid': globals.uid,
      'blocked_users': [],
    };

    if (downloadUrl != null) {
      data['image'] = downloadUrl;
    }

    await docUser.set(data);
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _textController.text.length;
    final remainingChars = _maxChars - charCount;
    final isOverLimit = remainingChars < 0;

    return PopScope(
      canPop: !_hasDraftContent,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F1015),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1015),
          elevation: 0,
          toolbarHeight: 60,
          leadingWidth: 56,
          shape: const Border(
            bottom: BorderSide(
              color: Color(0xFF1E202B),
              width: 1,
            ),
          ),
          leading: IconButton(
            tooltip: "Tutup",
            icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const BottomNavBar()),
                  );
                }
              }
            },
          ),
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 26,
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              const Text(
                "Postingan Baru",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14, top: 12, bottom: 12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: _canSubmit
                      ? const LinearGradient(
                          colors: [Color(0xFF3F465A), Color(0xFF252937)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF1E2028), Color(0xFF16181F)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _canSubmit
                        ? const Color(0xFF535B74)
                        : const Color(0xFF2A2D38),
                    width: 1,
                  ),
                  boxShadow: _canSubmit
                      ? [
                          BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: _canSubmit ? _handlePost : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Center(
                        child: _isPosting
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.send_rounded,
                                    color: _canSubmit
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                    size: 13,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Post",
                                    style: TextStyle(
                                      color: _canSubmit
                                          ? Colors.white
                                          : const Color(0xFF6B7280),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Clean Distraction-Free Text Composer ──
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      maxLines: null,
                      minLines: 6,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        height: 1.5,
                        letterSpacing: -0.2,
                      ),
                      cursorColor: Colors.white70,
                      cursorWidth: 2,
                      decoration: const InputDecoration(
                        hintText:
                            "Apa yang sedang terjadi di sekitarmu? Tulis ceritamu tanpa ragu...",
                        hintStyle: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 16,
                          height: 1.5,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Image Preview Card ──
                    if (_pickedImage != null) _buildImagePreview(),
                  ],
                ),
              ),
            ),

            // ── Docked Bottom Toolbar ──
            _buildDockedToolbar(charCount, remainingChars, isOverLimit),
          ],
        ),
      ),
    );
  }

  // ── Image Preview Card ──
  Widget _buildImagePreview() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF14151C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF272932),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 280,
                minWidth: double.infinity,
              ),
              color: const Color(0xFF0F1015),
              child: _pickedImageBytes != null
                  ? Image.memory(
                      _pickedImageBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : (kIsWeb
                      ? Image.network(
                          _pickedImage!.path,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )),
            ),
            // Actions Overlay
            Positioned(
              top: 10,
              right: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: _showImageSourceModal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF383B48),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Ganti",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() {
                        _pickedImage = null;
                        _pickedImageBytes = null;
                      });
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(200),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF383B48),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Docked Bottom Toolbar With IconButtons ──
  Widget _buildDockedToolbar(
    int charCount,
    int remainingChars,
    bool isOverLimit,
  ) {
    final progress = (charCount / _maxChars).clamp(0.0, 1.0);
    final indicatorColor = isOverLimit
        ? const Color(0xFFD32F2F)
        : (remainingChars <= 50
            ? const Color(0xFFFFAA20)
            : const Color(0xFF535B74));

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F1015),
        border: Border(
          top: BorderSide(
            color: Color(0xFF1E202B),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        left: 8,
        right: 16,
        top: 6,
        bottom: 6 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Row(
        children: [
          // Gallery
          IconButton(
            tooltip: "Pilih dari Galeri",
            icon: const Icon(
              Icons.photo_library_outlined,
              color: Color(0xFF8E92A8),
              size: 22,
            ),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),

          // Camera
          IconButton(
            tooltip: "Ambil Foto",
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: Color(0xFF8E92A8),
              size: 22,
            ),
            onPressed: () => _pickImage(ImageSource.camera),
          ),

          // Emoji / Expression
          IconButton(
            tooltip: "Emoji",
            icon: const Icon(
              Icons.sentiment_satisfied_alt_outlined,
              color: Color(0xFF8E92A8),
              size: 22,
            ),
            onPressed: _showEmojiSheet,
          ),

          // GIF
          IconButton(
            tooltip: "GIF",
            icon: const Icon(
              Icons.gif_box_outlined,
              color: Color(0xFF8E92A8),
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur GIF akan segera hadir"),
                  backgroundColor: Color(0xFF1F212D),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          // Location / Suasana
          IconButton(
            tooltip: "Lokasi / Suasana",
            icon: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF8E92A8),
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur penanda lokasi akan segera hadir"),
                  backgroundColor: Color(0xFF1F212D),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          const Spacer(),

          // Character Counter & Progress Ring
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (charCount > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    "$remainingChars",
                    style: TextStyle(
                      color: isOverLimit
                          ? const Color(0xFFD32F2F)
                          : const Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight:
                          isOverLimit ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.2,
                  backgroundColor: const Color(0xFF22242E),
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
