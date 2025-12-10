import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class PhotoGallery extends StatelessWidget {
  final List<String> existingPhotoUrls;
  final List<Uint8List> newImageBytes;
  final VoidCallback onAddPhoto;
  final Function(int) onRemoveExisting;
  final Function(int) onRemoveNew;
  final bool readOnly;

  const PhotoGallery({
    super.key,
    required this.existingPhotoUrls,
    required this.newImageBytes,
    required this.onAddPhoto,
    required this.onRemoveExisting,
    required this.onRemoveNew,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    if (readOnly && existingPhotoUrls.isEmpty && newImageBytes.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!readOnly && existingPhotoUrls.isEmpty && newImageBytes.isEmpty) {
      return GestureDetector(
        onTap: onAddPhoto,
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text('Add Photos', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Existing photos
          ...existingPhotoUrls.asMap().entries.map((entry) {
            final index = entry.key;
            final url = entry.value;
            return _buildPhotoItem(
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey[100]),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              onRemove: readOnly ? null : () => onRemoveExisting(index),
            );
          }),
          // New photos
          ...newImageBytes.asMap().entries.map((entry) {
            final index = entry.key;
            final bytes = entry.value;
            return _buildPhotoItem(
              child: Image.memory(bytes, fit: BoxFit.cover),
              onRemove: readOnly ? null : () => onRemoveNew(index),
            );
          }),
          // Add more button
          if (!readOnly)
            GestureDetector(
              onTap: onAddPhoto,
              child: Container(
                width: 130,
                height: 130,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 40, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoItem({required Widget child, VoidCallback? onRemove}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 130,
          height: 130,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
        if (onRemove != null)
          Positioned(
            top: 4,
            right: 12,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
