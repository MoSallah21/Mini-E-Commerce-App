/// A generic class to represent the result of an operation,
/// which can be either a success with data or a failure with an error message.
class Result<T> {
  /// The data returned on success. Null if operation failed.
  final T? data;

  /// The error message in case of failure. Null if operation succeeded.
  final String? error;

  // Private constructor
  Result._({this.data, this.error});

  /// Creates a successful result containing [data].
  factory Result.success(T data) => Result._(data: data);

  /// Creates a failed result containing an [error] message.
  factory Result.failure(String error) => Result._(error: error);

  /// Returns true if the result is successful (data is not null).
  bool get isSuccess => data != null;
}

/// Extension to provide a convenient [when] method for handling success and failure cases.
extension ResultWhen<T> on Result<T> {

  /// Executes either [success] or [failure] callback depending on the result.
  ///
  /// Example:
  /// ```dart
  /// result.when(
  ///   success: (data) => print('Success: $data'),
  ///   failure: (error) => print('Error: $error'),
  /// );
  /// ```
  R when<R>({
    required R Function(T value) success,
    required R Function(String error) failure,
  }) {
    if (isSuccess) {
      return success(data as T);
    } else {
      return failure(error!);
    }
  }
}
