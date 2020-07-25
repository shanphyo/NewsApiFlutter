import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/*void main() {
  //runApp(MyApp());
  runApp(MaterialApp(
    initialRoute: '/',
      routes: {
        '/':(context) => MyApp(),
        '/second':(context) => SecondPage()
      }
  ));
}*/

void main() {

  runApp(MaterialApp(
    // home:MyApp(),
      initialRoute: '/',
      routes: {
        '/':(context) => MyApp(),
        '/second':(context) => SecondPage ()
      }
  ));


}
class News{
  final String title;
  final String description;
  final String author;
  final String urlToImage;
  final String publishedAt;
  News(this.title,this.description,this.author,this.urlToImage,this.publishedAt);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.black,
         title: Center(
           child: Text(
             'New Api Sample',
             style: TextStyle(
               color: Colors.blue,
               fontFamily: 'Pacifico'

             ),
           ),
         ),
       ),
       body: NewsHome(),
     ),

    );
  }
}

class NewsHome extends StatefulWidget {
  @override
  _NewsHomeState createState() => _NewsHomeState();
}

class _NewsHomeState extends State<NewsHome> {
  Future<List<News>> getNews() async{
    var data= await http.get(
        'http://newsapi.org/v2/everything?q=bitcoin&from=2020-06-25&sortBy=publishedAt&apiKey=57a2e15d1f48416d986fa6e25771ee9a'
    );
    var jsonData= json.decode(data.body);
    var newsData= jsonData['articles'];
    List<News> news=[];
    for (var data in newsData){
      News newItem = News(data['title'], data['description'], data['author'], data['urlToImage'], data['publishedAt']);
      news.add(newItem);
    }
    return news;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getNews(),
        builder: (
        BuildContext context,AsyncSnapshot snapshot
        ){
          if(snapshot.data==null){
            return Container(
               child: Center(
                 child: CircularProgressIndicator(),
               ),
            );
          }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context,int index){
                return InkWell(
                  child: Card(
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 70.0,
                          height: 70.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(8.0),
                              topRight: const Radius.circular(8.0)
                            ),
                            child: (snapshot.data[index].urlToImage==null)?
                              Image.network('https://upload.wikimedia.org/wikipedia/commons/e/e0/New.gif')
                                :Image.network(snapshot.data[index].urlToImage,width:70,fit:BoxFit.fill)
                       ,
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].author == null
                                ? 'Unknown': (snapshot.data[index].author))

                            ,
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    //Navigator.push(context,  MaterialPageRoute(builder: (context) =>SecondPage()));
                    //Navigator.pushNamed(context, '/second',arguments: snapshot.data[index]);
                    Navigator.pushNamed(context, '/second',arguments: snapshot.data[index]) ;
                    //Navigator.pushNamed(context, '/second');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {

  @override
  Widget build(BuildContext context) {
   final News args=ModalRoute.of(context).settings.arguments;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Second Page',
          style: TextStyle(
            fontFamily: 'Modak'
          ),),
        ),
        body: Container(
          child: Image.network(args.urlToImage,height: 100.0,),

        ),

      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final News args=ModalRoute.of(context).settings.arguments;
    return Container();
  }
}







