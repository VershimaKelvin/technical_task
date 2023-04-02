import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var jsonList;
  var jsonList2;
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  @override
  void initState(){
    super.initState();
    runinit();

  }

   runinit()async{
    await getUser();
  }

  createUser(String name,String job)async{
    Map data = {'name': name,'job':job};
    try{
      Dio dio = Dio();
      Response response = await dio.post('https://reqres.in/api/users?page=2',data: data);
      if(response.statusCode==201){
        jsonList2=response.data;
      }
    }catch(e){
    }

  }

   getUser()async{
    try{
      Dio dio = Dio();
      Response response = await dio.get('https://reqres.in/api/users?page=2');
      if(response.statusCode==200){
        jsonList=response.data['data'] as List;
        setState(() {});
      }
    }catch(e){

    }

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical:20),
                child: ListView.builder(
                    itemBuilder: ( context, index){
                      return ListTile(
                        title: Text(jsonList[index]['first_name']),
                        subtitle: Text(jsonList[index]['email']),
                        leading: CircleAvatar(
                          child: Image(
                            image: NetworkImage(jsonList[index]['avatar']),
                          ),
                        ),
                      );
                    },
                  itemCount: jsonList==null?0:jsonList.length,
                  shrinkWrap: true,
                    )
              ),
              //SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: myController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'name',
                      ),
                    ),
                    const SizedBox(height:10),
                    TextFormField(
                      controller: myController2,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.work),
                        hintText: 'job',
                      ),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                        onPressed: ()async{
                        if (myController.text.isNotEmpty && myController2.text.isNotEmpty){
                          await createUser(myController.text,myController2.text);
                          setState(() {

                          });
                        }
                        },
                        child: const Text('Create')),
                    const SizedBox(height: 30,),
                    Text(
                      jsonList2 ==null? '':'name: ${jsonList2['name']} \n job: ${jsonList2['job']} \n id: ${jsonList2['id']} \n createdAt: ${jsonList2['createdAt']} ' ,
                    ),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
