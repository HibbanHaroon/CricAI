class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateUserException extends CloudStorageException {}

class CouldNotGetUserException extends CloudStorageException {}

class CouldNotUpdateUserException extends CloudStorageException {}

class CouldNotDeleteUserException extends CloudStorageException {}

class CouldNotCreateSessionException extends CloudStorageException {}

class CouldNotUpdateSessionException extends CloudStorageException {}

class CouldNotGetSessionException extends CloudStorageException {}

class CouldNotAddPlayerException extends CloudStorageException {}
