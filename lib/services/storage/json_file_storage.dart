import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'file_storage.dart';

// Simplified JSON file storage implementation with atomic operations and validation
// This class provides concrete implementation of FileStorage for JSON files
// Key features:
// - Atomic writes (temp file -> rename) to prevent corruption
// - JSON validation to ensure data integrity
// - Simple and reliable file operations
class JsonFileStorage implements FileStorage {
  final StorageConfig _config;
  late final Directory _baseDirectory;
  
  bool _initialized = false;

  JsonFileStorage(this._config);

  @override
  Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      /* Get the directory location or use the provided one */
      final Directory documentsDir;
      if (path.isAbsolute(_config.basePath)) {
        documentsDir = Directory(_config.basePath);
      } else {
        final appDocsDir = await getApplicationDocumentsDirectory();
        documentsDir = Directory(path.join(appDocsDir.path, _config.basePath));
      }

      /* Ensure there is a directory in the location */
      _baseDirectory = documentsDir;
      if (!await _baseDirectory.exists()) {
        await _baseDirectory.create(recursive: true);
      }

      _initialized = true;
      return true;
    } catch (e) {
      // TODO: Add proper error handling - log initialization errors, provide detailed error info
      return false;
    }
  }

  // Check if the storage is initialized and a file exists in the location provided
  @override
  Future<bool> exists(String filePath) async {
    if (!_initialized) return false;
    final file = File(_getFullPath(filePath));
    return await file.exists();
  }


  @override
  Future<String?> read(String filePath) async {
    if (!_initialized) return null;

    try {
      final file = File(_getFullPath(filePath));
      if (!await file.exists()) return null;
      
      final content = await file.readAsString();
      
      // Validate JSON if validation is enabled
      if (_config.enableValidation && content.isNotEmpty) {
        jsonDecode(content); // Will throw if invalid JSON
        // TODO(Do further validation)
      }
      
      return content;
    } catch (e) {
      // TODO: Add proper error handling - log read errors, distinguish between file not found vs corruption
      return null;
    }
  }

  @override
  Future<bool> write(String filePath, String data, {bool validate = true}) async {
    if (!_initialized) return false;

    try {
      // Validate JSON if validation is enabled
      if (validate && _config.enableValidation && data.isNotEmpty) {
        jsonDecode(data); // Will throw if invalid JSON
        // TODO(Do further validation)
      }

      final fullPath = _getFullPath(filePath);
      final targetFile = File(fullPath);
      
      // Create parent directories if they don't exist
      final parentDir = targetFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }

      // Use atomic write: write to temp file, then rename
      final tempFile = File('$fullPath.tmp');
      try {
        await tempFile.writeAsString(data);
        await tempFile.rename(fullPath);
        return true;
      } catch (e) {
        // Clean up temp file if rename fails
        if (await tempFile.exists()) {
          try {
            await tempFile.delete();
          } catch (_) {
            // Ignore cleanup errors
          }
        }
        rethrow;
      }
    } catch (e) {
      // TODO: Add proper error handling - log write errors, distinguish between validation vs I/O errors
      return false;
    }
  }

  // Delete the file at the given path
  @override
  Future<bool> delete(String filePath) async {
    if (!_initialized) return false;

    try {
      final file = File(_getFullPath(filePath));
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (e) {
      // TODO: Add proper error handling - log deletion errors, handle permission issues
      return false;
    }
  }

  // Validate the content of the given file
  @override
  Future<bool> validateFile(String filePath) async {
    if (!_initialized) return false;

    try {
      final content = await read(filePath);
      if (content == null) return false;
      
      // Try to parse as JSON
      if (content.isNotEmpty) {
        jsonDecode(content);
        // TODO(Do further validation)
      }
      return true;
    } catch (e) {
      // TODO: Add proper error handling - log validation errors, provide detailed error messages
      return false;
    }
  }

  // Get the size of the file at the given path
  @override
  Future<int> getFileSize(String filePath) async {
    if (!_initialized) return -1;

    try {
      final file = File(_getFullPath(filePath));
      if (!await file.exists()) return -1;
      return await file.length();
    } catch (e) {
      // TODO: Add proper error handling - log file size errors, provide meaningful error codes
      return -1;
    }
  }

  // Get the modification time of the file at the given path
  @override
  Future<DateTime?> getModificationTime(String filePath) async {
    if (!_initialized) return null;

    try {
      final file = File(_getFullPath(filePath));
      if (!await file.exists()) return null;
      return await file.lastModified();
    } catch (e) {
      // TODO: Add proper error handling - log timestamp errors, handle file system issues
      return null;
    }
  }

  // Copy a file from source to destination
  @override
  Future<bool> copyFile(String sourcePath, String destinationPath) async {
    if (!_initialized) return false;

    try {
      final sourceFile = File(_getFullPath(sourcePath));
      final destFile = File(_getFullPath(destinationPath));
      
      if (!await sourceFile.exists()) return false;
      
      // Create parent directories if they don't exist
      final parentDir = destFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }
      
      await sourceFile.copy(destFile.path);
      return true;
    } catch (e) {
      // TODO: Add proper error handling - log copy errors, handle disk space issues
      return false;
    }
  }

  // Move a file from source to destination
  @override
  Future<bool> moveFile(String sourcePath, String destinationPath) async {
    if (!_initialized) return false;

    try {
      final sourceFile = File(_getFullPath(sourcePath));
      final destPath = _getFullPath(destinationPath);
      
      if (!await sourceFile.exists()) return false;
      
      // Create parent directories if they don't exist
      final destFile = File(destPath);
      final parentDir = destFile.parent;
      if (!await parentDir.exists()) {
        await parentDir.create(recursive: true);
      }
      
      await sourceFile.rename(destPath);
      return true;
    } catch (e) {
      // TODO: Add proper error handling - log move errors, handle cross-filesystem moves
      return false;
    }
  }

  // JSON convenience methods
  // Read JSON data from file with automatic parsing and error handling
  Future<Map<String, dynamic>?> readJson(String filePath, {Map<String, dynamic>? defaultValue}) async {
    try {
      final content = await read(filePath);
      if (content == null) return defaultValue;
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      // TODO: Add proper error handling - log JSON parsing errors, provide better error context
      return defaultValue;
    }
  }
  
  // Write JSON data to file with automatic encoding
  Future<bool> writeJson(String filePath, Map<String, dynamic> data, {bool validate = true}) async {
    try {
      final jsonString = jsonEncode(data);
      return await write(filePath, jsonString, validate: validate);
    } catch (e) {
      // TODO: Add proper error handling - log error, notify user appropriately
      return false;
    }
  }

  String _getFullPath(String filePath) {
    if (path.isAbsolute(filePath)) {
      return filePath;
    }
    return path.join(_baseDirectory.path, filePath);
  }
}
