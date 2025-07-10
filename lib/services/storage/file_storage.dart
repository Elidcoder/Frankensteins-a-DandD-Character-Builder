// Interface for file storage operations
abstract interface class FileStorage {
  Future<bool> initialize();
  Future<bool> exists(String filePath);
  Future<String?> read(String filePath);
  Future<bool> write(String filePath, String data, {bool validate = true});
  Future<bool> delete(String filePath);
  Future<bool> validateFile(String filePath);
  Future<int> getFileSize(String filePath);
  Future<DateTime?> getModificationTime(String filePath);
  Future<bool> copyFile(String sourcePath, String destinationPath);
  Future<bool> moveFile(String sourcePath, String destinationPath);
}

class StorageConfig {
  final String basePath;
  final bool enableValidation;

  const StorageConfig({
    required this.basePath,
    this.enableValidation = true,
  });
}

class StorageException implements Exception {
  final String message;
  final String? filePath;
  final dynamic originalError;

  const StorageException(this.message, {this.filePath, this.originalError});

  @override
  String toString() {
    String pathOut = "";
    if (filePath != null) {
      pathOut = " (file: $filePath)";
    }
    return "StorageException: $message$pathOut";
  }
}
