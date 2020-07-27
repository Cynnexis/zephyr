import 'package:flutter/widgets.dart';
import 'package:zephyr/page/loading_page.dart';

typedef bool SnapshotReadiness<T>(BuildContext context, AsyncSnapshot<T> snapshot);

/// [LoadingFutureBuilder] is a [FutureBuilder] that build the given [builder] only if the data is ready. If it is not,
/// the loading page will be shown instead.
class LoadingFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final T initialData;
  final SnapshotReadiness<T> dataReady;
  final AsyncWidgetBuilder<T> builder;

  /// Constructor for [LoadingFutureBuilder]. For description of [future], [initialData] and [builder], please see the
  /// [FutureBuilder] documentation. [dataReady] is a callback that returns `true` if the data is ready and [builder]
  /// should be called, or `false` to display the loading page (see [LoadingPage]).
  LoadingFutureBuilder({Key key, this.future, this.initialData, this.dataReady, @required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      initialData: initialData,
      builder: (context, snapshot) {
        if (dataReady != null && !dataReady(context, snapshot) || dataReady == null && !snapshot.hasData)
          return LoadingPage();
        else
          return this.builder(context, snapshot);
      },
    );
  }
}
