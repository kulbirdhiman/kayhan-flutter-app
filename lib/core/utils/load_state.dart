/// Minimal async state holder used by controllers.
class LoadState<T> {
  const LoadState._({this.data, this.error, this.isLoading = false});

  const LoadState.idle() : this._();
  const LoadState.loading([T? previous]) : this._(data: previous, isLoading: true);
  const LoadState.success(T data) : this._(data: data);
  const LoadState.failure(String error, [T? previous])
      : this._(error: error, data: previous);

  final T? data;
  final String? error;
  final bool isLoading;

  bool get hasData => data != null;
  bool get hasError => error != null;
}
