
import 'package:api_app/cart_c.dart';
import 'package:api_app/Repository.dart';
import 'package:api_app/dummy.dart';
import 'package:api_app/moor_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

var db = AppDatabase();
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HttpScreen(),
    );
  }
}

class HttpScreen extends StatefulWidget {
  HttpScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HttpScreen createState() => _HttpScreen();

}

class _HttpScreen extends State<HttpScreen> {
  @override
  int cartCount = 0;
  var streamDb = Repository().getTotal();
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // isLoading = 1;
      getCart4Grid();

      streamDb.listen((valueStreamDb) {
        // print("dadaw");
        // print(valueStreamDb.length);
        var arrayCart = [];
        for(var valueCart in valueStreamDb){
          arrayCart.add(valueCart.id);
        }
        cartCount = arrayCart.toSet().toList().length;
        setState(() {
        });
      });
    });
  }
  void getCart4Grid() async{
    // var ListCart = await Repository().getCart();
    //   print(ListCart);

    Repository().getCart().then((response){
        isLoading = 2;
        carts = response;
        setState(() {
        });
    },
        onError: (exception){
      if(exception.message != null ){
        isLoading = 3;
        setState(() {
        });
      }
    },);
  }
  _body (context){
    print(isLoading);
    if(isLoading == 1){
      return Center(
          child: CircularProgressIndicator(),
      );
    }
    else if(isLoading == 3){
      return Center(
        child: Text("gagal mendapatkan barang dari server"),
      );
    }
    else {
      return
      Container(
        child :
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1),
              ),
              itemCount: carts?.length ?? 0,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                    child:  Card(
                      color: Colors.white,

                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Flexible(child: Image.network("https://ranting.twisdev.com/uploads/${carts[index].foto}"),),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                            Container (
                                  padding: const EdgeInsets.all(0),
                                  width: MediaQuery.of(context).size.width/2.5,
                                  child: new Row (
                                    children:[
                                      Flexible(child: Text(carts[index].title),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text("Rp. ${carts[index].price}",),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 7,),
                            Row(
                              children: [
                                Icon(Icons.maps_ugc,size: 20,),
                                Text(carts[index].location_name),
                              ],
                            ),
                            SizedBox(height: 7,),
                            Container(
                              // color: Colors.red,
                              child:
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.account_circle,size: 20,),
                                          Text(carts[index].username),
                                        ],
                                      ),
                                      // if(carts[index] != "")
                                      if(int.parse(carts[index].is_sold_out ?? 0) > 0)
                                        Row(
                                          children: [
                                            SizedBox(height: 50,),
                                            Container(
                                              color: Colors.blueAccent,
                                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                              child: Text("Ready Stock", style: TextStyle(color: Colors.white),),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child:
                                      Column(
                                      children: [
                                        if(int.parse(carts[index].halal) > 0)
                                          Row(
                                            children: [
                                              // Spacer(),
                                              Image.network(
                                                "https://seeklogo.com/images/H/halal-logo-150ED752BD-seeklogo.com.png", height: 35,),
                                            ],
                                          ),
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            )


                          ],
                        ),
                      )
                    ),
                    onTap: () {
                      setState(() {
                        Repository().insertCart(carts[index]);
                      });
                    }
                );
              }
          )
      );

    }
  }

  int isLoading = 1;
  List<Cart_c> carts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Flutter"),
         actions: [
           Stack(
             children:[
               IconButton(
                 icon: SizedBox(
                     height: 30,
                     width: 22,
                     child: Icon(Icons.shopping_bag)
                 ),
                 onPressed: () {
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => showCart()),
                   );
                 },
               ),
               if(cartCount > 0)
               Positioned(
                 right: 12,
                 top: 3,
                 child: Container(
                   color: Colors.red,
                   padding: EdgeInsets.all(1),
                   child:
                   Text('$cartCount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                 )
               ),
            ]
           )

         ],
      ),
      body: _body(context),
    );
  }
  void showDialog1(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content: Text("Alert aasasasasas"),
        )
    );
  }
}

