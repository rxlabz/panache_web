import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:panache_lib/panache_lib.dart';
import 'package:scoped_model/scoped_model.dart';

import 'src/theme_exporter_web.dart';
import 'src/web_local_data.dart';

void main() async {
  clearPersisted();
  final localData = WebLocalData();
  await localData.init();

  final themeModel = ThemeModel(
    localData: localData,
    cloudService: null,
    service: ThemeService(
      themeExporter: exportTheme,
      dirProvider: null,
    ),
  );

  runApp(PanacheApp(themeModel: themeModel));
}

class PanacheApp extends StatelessWidget {
  final ThemeModel themeModel;

  const PanacheApp({Key key, @required this.themeModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ScopedModel<ThemeModel>(
      model: themeModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: /*panacheTheme*/ buildAppTheme(theme, panachePrimarySwatch),
        home: LaunchScreen(model: themeModel),
        routes: {
          '/home': (context) => LaunchScreen(model: themeModel),
          '/editor': (context) => PanacheEditorScreen(),
        },
      ),
    );
  }
}

exportTheme(String code, String filename) async {
  print('exportTheme... $code');
  jsSaveTheme(code, filename, (success) => print('export $success'));
}
