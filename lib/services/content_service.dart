import 'package:uuid/uuid.dart';
import '../data/mysql_connection.dart';
import '../models/content.dart';
import '../models/content_price.dart';
import '../models/episode.dart';
import '../models/content_material.dart';

class ContentService {
  // ==================== Content CRUD ====================

  /// Get all contents
  static Future<List<Content>> getAllContents({bool? isActive}) async {
    final conn = await MySQLConnection.openConnection();
    try {
      String query = 'SELECT * FROM contents';
      List<Object?> params = [];
      
      if (isActive != null) {
        query += ' WHERE is_active = ?';
        params.add(isActive);
      }
      
      query += ' ORDER BY ordering ASC, created_at DESC';
      
      final results = await conn.query(query, params);
      return results.map((row) => _contentFromRow(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Get content by ID
  static Future<Content?> getContentById(String contentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM contents WHERE id = ?',
        [contentId],
      );
      if (results.isEmpty) return null;
      return _contentFromRow(results.first.fields);
    } finally {
      await conn.close();
    }
  }

  /// Create new content
  static Future<Content> createContent({
    required String title,
    String? description,
    String? shortDescription,
    String? telegramGroupUrl,
    String? coverImageUrl,
    required ContentType contentType,
    String? videoUrl,
    String? videoProvider,
    bool featured = false,
    int ordering = 0,
    bool isActive = true,
    String? createdBy,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final contentId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO contents 
          (id, title, description, short_description, telegram_group_url, cover_image_url,
           content_type, video_url, video_provider, featured, ordering, is_active,
           created_by, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [
          contentId,
          title,
          description,
          shortDescription,
          telegramGroupUrl,
          coverImageUrl,
          contentType.name,
          videoUrl,
          videoProvider,
          featured,
          ordering,
          isActive,
          createdBy,
        ],
      );

      return Content(
        id: contentId,
        title: title,
        description: description,
        shortDescription: shortDescription,
        telegramGroupUrl: telegramGroupUrl,
        coverImageUrl: coverImageUrl,
        contentType: contentType,
        videoUrl: videoUrl,
        videoProvider: videoProvider,
        featured: featured,
        ordering: ordering,
        isActive: isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: createdBy,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  /// Update content
  static Future<bool> updateContent(
    String contentId,
    Map<String, dynamic> updates, {
    String? updatedBy,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updateFields = <String>[];
      final params = <Object?>[];

      if (updates.containsKey('title')) {
        updateFields.add('title = ?');
        params.add(updates['title']);
      }
      if (updates.containsKey('description')) {
        updateFields.add('description = ?');
        params.add(updates['description']);
      }
      if (updates.containsKey('shortDescription')) {
        updateFields.add('short_description = ?');
        params.add(updates['shortDescription']);
      }
      if (updates.containsKey('telegramGroupUrl')) {
        updateFields.add('telegram_group_url = ?');
        params.add(updates['telegramGroupUrl']);
      }
      if (updates.containsKey('coverImageUrl')) {
        updateFields.add('cover_image_url = ?');
        params.add(updates['coverImageUrl']);
      }
      if (updates.containsKey('contentType')) {
        updateFields.add('content_type = ?');
        params.add((updates['contentType'] as ContentType).name);
      }
      if (updates.containsKey('videoUrl')) {
        updateFields.add('video_url = ?');
        params.add(updates['videoUrl']);
      }
      if (updates.containsKey('videoProvider')) {
        updateFields.add('video_provider = ?');
        params.add(updates['videoProvider']);
      }
      if (updates.containsKey('featured')) {
        updateFields.add('featured = ?');
        params.add(updates['featured']);
      }
      if (updates.containsKey('ordering')) {
        updateFields.add('ordering = ?');
        params.add(updates['ordering']);
      }
      if (updates.containsKey('isActive')) {
        updateFields.add('is_active = ?');
        params.add(updates['isActive']);
      }

      if (updateFields.isEmpty) return false;

      updateFields.add('updated_at = NOW()');
      if (updatedBy != null) {
        updateFields.add('updated_by = ?');
        params.add(updatedBy);
      }
      params.add(contentId);

      final query = 'UPDATE contents SET ${updateFields.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Delete content (soft delete by setting is_active = false, or hard delete)
  static Future<bool> deleteContent(String contentId, {bool hardDelete = false}) async {
    final conn = await MySQLConnection.openConnection();
    try {
      if (hardDelete) {
        final result = await conn.query('DELETE FROM contents WHERE id = ?', [contentId]);
        return result.affectedRows! > 0;
      } else {
        final result = await conn.query(
          'UPDATE contents SET is_active = false, updated_at = NOW() WHERE id = ?',
          [contentId],
        );
        return result.affectedRows! > 0;
      }
    } finally {
      await conn.close();
    }
  }

  // ==================== Content Prices ====================

  /// Get prices for a content
  static Future<List<ContentPrice>> getContentPrices(String contentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM content_prices WHERE content_id = ? ORDER BY ordering ASC, price ASC',
        [contentId],
      );
      return results.map((row) => _contentPriceFromRow(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Create content price
  static Future<ContentPrice> createContentPrice({
    required String contentId,
    required double price,
    String currency = 'UAH',
    required AccessType accessType,
    int? accessDurationMonths,
    String? description,
    bool isDefault = false,
    int ordering = 0,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      // If this is default, unset other defaults
      if (isDefault) {
        await conn.query(
          'UPDATE content_prices SET is_default = false WHERE content_id = ?',
          [contentId],
        );
      }

      final priceId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO content_prices 
          (id, content_id, price, currency, access_type, access_duration_months,
           description, is_default, ordering, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [
          priceId,
          contentId,
          price,
          currency,
          accessType.name,
          accessDurationMonths,
          description,
          isDefault,
          ordering,
        ],
      );

      return ContentPrice(
        id: priceId,
        contentId: contentId,
        price: price,
        currency: currency,
        accessType: accessType,
        accessDurationMonths: accessDurationMonths,
        description: description,
        isDefault: isDefault,
        ordering: ordering,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      await conn.close();
    }
  }

  /// Update content price
  static Future<bool> updateContentPrice(
    String priceId,
    Map<String, dynamic> updates,
  ) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updateFields = <String>[];
      final params = <Object?>[];

      if (updates.containsKey('price')) {
        updateFields.add('price = ?');
        params.add(updates['price']);
      }
      if (updates.containsKey('currency')) {
        updateFields.add('currency = ?');
        params.add(updates['currency']);
      }
      if (updates.containsKey('accessType')) {
        updateFields.add('access_type = ?');
        params.add((updates['accessType'] as AccessType).name);
      }
      if (updates.containsKey('accessDurationMonths')) {
        updateFields.add('access_duration_months = ?');
        params.add(updates['accessDurationMonths']);
      }
      if (updates.containsKey('description')) {
        updateFields.add('description = ?');
        params.add(updates['description']);
      }
      if (updates.containsKey('isDefault')) {
        final isDefault = updates['isDefault'] as bool;
        updateFields.add('is_default = ?');
        params.add(isDefault);
        
        // If setting as default, unset other defaults
        if (isDefault) {
          final price = await getContentPriceById(priceId);
          if (price != null) {
            await conn.query(
              'UPDATE content_prices SET is_default = false WHERE content_id = ? AND id != ?',
              [price.contentId, priceId],
            );
          }
        }
      }
      if (updates.containsKey('ordering')) {
        updateFields.add('ordering = ?');
        params.add(updates['ordering']);
      }

      if (updateFields.isEmpty) return false;

      updateFields.add('updated_at = NOW()');
      params.add(priceId);

      final query = 'UPDATE content_prices SET ${updateFields.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Get content price by ID
  static Future<ContentPrice?> getContentPriceById(String priceId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM content_prices WHERE id = ?',
        [priceId],
      );
      if (results.isEmpty) return null;
      return _contentPriceFromRow(results.first.fields);
    } finally {
      await conn.close();
    }
  }

  /// Delete content price
  static Future<bool> deleteContentPrice(String priceId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM content_prices WHERE id = ?',
        [priceId],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // ==================== Episodes ====================

  /// Get episodes for a content
  static Future<List<Episode>> getEpisodesByContentId(String contentId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM episodes WHERE content_id = ? ORDER BY ordering ASC',
        [contentId],
      );
      return results.map((row) => _episodeFromRow(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Get episode by ID
  static Future<Episode?> getEpisodeById(String episodeId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final results = await conn.query(
        'SELECT * FROM episodes WHERE id = ?',
        [episodeId],
      );
      if (results.isEmpty) return null;
      return _episodeFromRow(results.first.fields);
    } finally {
      await conn.close();
    }
  }

  /// Create episode
  static Future<Episode> createEpisode({
    required String contentId,
    required String title,
    String? description,
    String? videoUrl,
    String? videoProvider,
    int ordering = 0,
    int? durationSeconds,
    String? createdBy,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final episodeId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO episodes 
          (id, content_id, title, description, video_url, video_provider,
           ordering, duration_seconds, created_by, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [
          episodeId,
          contentId,
          title,
          description,
          videoUrl,
          videoProvider,
          ordering,
          durationSeconds,
          createdBy,
        ],
      );

      return Episode(
        id: episodeId,
        contentId: contentId,
        title: title,
        description: description,
        videoUrl: videoUrl,
        videoProvider: videoProvider,
        ordering: ordering,
        durationSeconds: durationSeconds,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: createdBy,
        updatedBy: null,
      );
    } finally {
      await conn.close();
    }
  }

  /// Update episode
  static Future<bool> updateEpisode(
    String episodeId,
    Map<String, dynamic> updates, {
    String? updatedBy,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final updateFields = <String>[];
      final params = <Object?>[];

      if (updates.containsKey('title')) {
        updateFields.add('title = ?');
        params.add(updates['title']);
      }
      if (updates.containsKey('description')) {
        updateFields.add('description = ?');
        params.add(updates['description']);
      }
      if (updates.containsKey('videoUrl')) {
        updateFields.add('video_url = ?');
        params.add(updates['videoUrl']);
      }
      if (updates.containsKey('videoProvider')) {
        updateFields.add('video_provider = ?');
        params.add(updates['videoProvider']);
      }
      if (updates.containsKey('ordering')) {
        updateFields.add('ordering = ?');
        params.add(updates['ordering']);
      }
      if (updates.containsKey('durationSeconds')) {
        updateFields.add('duration_seconds = ?');
        params.add(updates['durationSeconds']);
      }

      if (updateFields.isEmpty) return false;

      updateFields.add('updated_at = NOW()');
      if (updatedBy != null) {
        updateFields.add('updated_by = ?');
        params.add(updatedBy);
      }
      params.add(episodeId);

      final query = 'UPDATE episodes SET ${updateFields.join(", ")} WHERE id = ?';
      final result = await conn.query(query, params);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  /// Delete episode
  static Future<bool> deleteEpisode(String episodeId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query('DELETE FROM episodes WHERE id = ?', [episodeId]);
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // ==================== Content Materials ====================

  /// Get materials for content or episode
  static Future<List<ContentMaterial>> getMaterials({
    String? contentId,
    String? episodeId,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      String query = 'SELECT * FROM content_materials WHERE';
      List<Object?> params = [];

      if (contentId != null) {
        query += ' content_id = ?';
        params.add(contentId);
      } else if (episodeId != null) {
        query += ' episode_id = ?';
        params.add(episodeId);
      } else {
        return [];
      }

      query += ' ORDER BY ordering ASC';

      final results = await conn.query(query, params);
      return results.map((row) => _contentMaterialFromRow(row.fields)).toList();
    } finally {
      await conn.close();
    }
  }

  /// Create content material
  static Future<ContentMaterial> createContentMaterial({
    String? contentId,
    String? episodeId,
    required MaterialType materialType,
    required String title,
    String? description,
    String? fileUrl,
    String? externalUrl,
    int? fileSizeBytes,
    String? mimeType,
    int ordering = 0,
    String? createdBy,
  }) async {
    final conn = await MySQLConnection.openConnection();
    try {
      if (contentId == null && episodeId == null) {
        throw ArgumentError('Either contentId or episodeId must be provided');
      }

      final materialId = Uuid().v4();
      await conn.query(
        '''
        INSERT INTO content_materials 
          (id, content_id, episode_id, material_type, title, description,
           file_url, external_url, file_size_bytes, mime_type, ordering, created_by, created_at, updated_at)
        VALUES 
          (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())
        ''',
        [
          materialId,
          contentId,
          episodeId,
          materialType.name,
          title,
          description,
          fileUrl,
          externalUrl,
          fileSizeBytes,
          mimeType,
          ordering,
          createdBy,
        ],
      );

      return ContentMaterial(
        id: materialId,
        contentId: contentId,
        episodeId: episodeId,
        materialType: materialType,
        title: title,
        description: description,
        fileUrl: fileUrl,
        externalUrl: externalUrl,
        fileSizeBytes: fileSizeBytes,
        mimeType: mimeType,
        ordering: ordering,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: createdBy,
      );
    } finally {
      await conn.close();
    }
  }

  /// Delete content material
  static Future<bool> deleteContentMaterial(String materialId) async {
    final conn = await MySQLConnection.openConnection();
    try {
      final result = await conn.query(
        'DELETE FROM content_materials WHERE id = ?',
        [materialId],
      );
      return result.affectedRows! > 0;
    } finally {
      await conn.close();
    }
  }

  // ==================== Helper Methods ====================

  static Content _contentFromRow(Map<String, dynamic> fields) {
    return Content(
      id: fields['id']?.toString() ?? '',
      title: fields['title']?.toString() ?? '',
      description: fields['description']?.toString(),
      shortDescription: fields['short_description']?.toString(),
      telegramGroupUrl: fields['telegram_group_url']?.toString(),
      coverImageUrl: fields['cover_image_url']?.toString(),
      contentType: ContentType.values.firstWhere(
        (e) => e.name == fields['content_type'],
        orElse: () => ContentType.singleVideo,
      ),
      videoUrl: fields['video_url']?.toString(),
      videoProvider: fields['video_provider']?.toString(),
      featured: _parseBool(fields['featured']),
      ordering: int.tryParse(fields['ordering']?.toString() ?? '0') ?? 0,
      isActive: _parseBool(fields['is_active']),
      createdAt: DateTime.parse(fields['created_at'].toString()),
      updatedAt: DateTime.parse(fields['updated_at'].toString()),
      createdBy: fields['created_by']?.toString(),
      updatedBy: fields['updated_by']?.toString(),
    );
  }

  static ContentPrice _contentPriceFromRow(Map<String, dynamic> fields) {
    return ContentPrice(
      id: fields['id']?.toString() ?? '',
      contentId: fields['content_id']?.toString() ?? '',
      price: double.tryParse(fields['price']?.toString() ?? '0.0') ?? 0.0,
      currency: fields['currency']?.toString() ?? 'UAH',
      accessType: AccessType.values.firstWhere(
        (e) => e.name == fields['access_type'],
        orElse: () => AccessType.lifetime,
      ),
      accessDurationMonths: fields['access_duration_months'] != null
          ? int.tryParse(fields['access_duration_months'].toString())
          : null,
      description: fields['description']?.toString(),
      isDefault: _parseBool(fields['is_default']),
      ordering: int.tryParse(fields['ordering']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(fields['created_at'].toString()),
      updatedAt: DateTime.parse(fields['updated_at'].toString()),
    );
  }

  static Episode _episodeFromRow(Map<String, dynamic> fields) {
    return Episode(
      id: fields['id']?.toString() ?? '',
      contentId: fields['content_id']?.toString() ?? '',
      title: fields['title']?.toString() ?? '',
      description: fields['description']?.toString(),
      videoUrl: fields['video_url']?.toString(),
      videoProvider: fields['video_provider']?.toString(),
      ordering: int.tryParse(fields['ordering']?.toString() ?? '0') ?? 0,
      durationSeconds: fields['duration_seconds'] != null
          ? int.tryParse(fields['duration_seconds'].toString())
          : null,
      createdAt: DateTime.parse(fields['created_at'].toString()),
      updatedAt: DateTime.parse(fields['updated_at'].toString()),
      createdBy: fields['created_by']?.toString(),
      updatedBy: fields['updated_by']?.toString(),
    );
  }

  static ContentMaterial _contentMaterialFromRow(Map<String, dynamic> fields) {
    return ContentMaterial(
      id: fields['id']?.toString() ?? '',
      contentId: fields['content_id']?.toString(),
      episodeId: fields['episode_id']?.toString(),
      materialType: MaterialType.values.firstWhere(
        (e) => e.name == fields['material_type'],
        orElse: () => MaterialType.other,
      ),
      title: fields['title']?.toString() ?? '',
      description: fields['description']?.toString(),
      fileUrl: fields['file_url']?.toString(),
      externalUrl: fields['external_url']?.toString(),
      fileSizeBytes: fields['file_size_bytes'] != null
          ? int.tryParse(fields['file_size_bytes'].toString())
          : null,
      mimeType: fields['mime_type']?.toString(),
      ordering: int.tryParse(fields['ordering']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(fields['created_at'].toString()),
      updatedAt: DateTime.parse(fields['updated_at'].toString()),
      createdBy: fields['created_by']?.toString(),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}

