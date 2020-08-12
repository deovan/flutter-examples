import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluter_tube/blocs/favorite_bloc.dart';
import 'package:fluter_tube/blocs/videos_bloc.dart';
import 'package:fluter_tube/screen/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'FlutterTube',
          home: Home(),
        ),
      ),
    );
  }
}
