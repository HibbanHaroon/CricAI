class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateUserException extends CloudStorageException {}

class CouldNotGetUserException extends CloudStorageException {}

class CouldNotUpdateUserException extends CloudStorageException {}

class CouldNotDeleteUserException extends CloudStorageException {}
