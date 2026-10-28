import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A robust network image widget that automatically handles CORS issues on Flutter Web
/// by failing over to a CORS-friendly proxy (images.weserv.nl) if the direct fetch is blocked.
class SafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget? placeholder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;
  final Widget? fallbackWidget;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholder,
    this.errorBuilder,
    this.fallbackWidget,
  });

  static String sanitizeUrl(String url) {
    final clean = url.trim();
    if (clean.isEmpty) return '';
    // Blocked or expired Google default placeholder avatar link -> treat as empty so default user icon is shown
    if (clean.contains('encrypted-tbn0.gstatic.com')) {
      return '';
    }
    return clean;
  }

  static String toProxyUrl(String url) {
    if (url.contains('images.weserv.nl')) return url;
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(url)}';
  }

  @override
  Widget build(BuildContext context) {
    final cleanUrl = sanitizeUrl(imageUrl);
    if (cleanUrl.isEmpty || !cleanUrl.startsWith('http')) {
      return fallbackWidget ?? _buildDefaultFallback();
    }

    return Image.network(
      cleanUrl,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: const Color(0xFF14151C),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white38,
                ),
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('[SafeNetworkImage] Direct load failed: $cleanUrl ($error)');
        // On Flutter Web, browser CORS often blocks Firebase Storage.
        // Self-heal by fetching through the CORS-enabled weserv cache proxy.
        if (kIsWeb && !cleanUrl.contains('images.weserv.nl')) {
          final proxyUrl = toProxyUrl(cleanUrl);
          return Image.network(
            proxyUrl,
            fit: fit,
            width: width,
            height: height,
            cacheWidth: cacheWidth,
            cacheHeight: cacheHeight,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return placeholder ??
                  Container(
                    width: width,
                    height: height,
                    color: const Color(0xFF14151C),
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white38,
                      ),
                    ),
                  );
            },
            errorBuilder: (ctx, err, st) {
              debugPrint('[SafeNetworkImage] Proxy load also failed: $proxyUrl ($err)');
              if (errorBuilder != null) {
                return errorBuilder!(ctx, err, st);
              }
              return fallbackWidget ?? _buildDefaultFallback();
            },
          );
        }

        if (errorBuilder != null) {
          return errorBuilder!(context, error, stackTrace);
        }
        return fallbackWidget ?? _buildDefaultFallback();
      },
    );
  }

  Widget _buildDefaultFallback() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF1B1C22),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        color: Color(0xFF7A7E85),
        size: 24,
      ),
    );
  }
}
