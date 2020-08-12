import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluter_tube/api.dart';
import 'package:fluter_tube/blocs/favorite_bloc.dart';
import 'package:fluter_tube/models/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        initialData: {},
        stream: bloc.outFav,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.values
                  .map((v) =>
                  InkWell(
                    onTap: () {
                      FlutterYoutube.playYoutubeVideoById(
                          apiKey: API_KEY, videoId: v.id);
                    },
                    onLongPress: () {
                      bloc.toggleFavorite(v);
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 50,
                          child: Image.network(v.thumb),
                        ),
                        Expanded(
                          child: Text(
                            v.title,
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                            maxLines: 2,
                          ),
                        )
                      ],
                    ),
                  ))
                  .toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          }
        },
      ),
    );
  }
}
