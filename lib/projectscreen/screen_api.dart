import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../http_url/details_url.dart';
import '../model/AlbumResponse.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  @override
  Widget build(BuildContext context) {
    return buildAlbumList(context);
  }

  Future<List<AlbumResponse>> fetchAlbumList() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable l = json.decode(response.body);
      List<AlbumResponse> listOfAlbums = List<AlbumResponse>.from(l.map((model)=> AlbumResponse.fromJson(model)));

      return listOfAlbums;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

// To build Album List View
  Widget buildAlbumList(BuildContext context){
    return FutureBuilder<List<AlbumResponse>>(
        future: fetchAlbumList(),
        builder: (context, AsyncSnapshot<List<AlbumResponse>> snapshot){
          if (snapshot.hasData){
            print(' album details data ${snapshot.data}');
            List<AlbumResponse>? data = snapshot.data;
            return ListView.builder(
                itemCount: data?.length ?? 0,
                itemBuilder: (context,index){
                  return Text(data?[index].title ?? "");
                }
            );

          } else if (snapshot.hasError){

          }

          return Container();
          }
        );
    }

}
