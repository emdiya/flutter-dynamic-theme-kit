class StorageService {
  const StorageService();

  Future<void> writeString({required String key, required String value}) async {
    throw UnimplementedError('Connect your local storage implementation here.');
  }

  Future<String?> readString(String key) async {
    throw UnimplementedError('Connect your local storage implementation here.');
  }
}
