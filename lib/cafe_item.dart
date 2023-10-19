import 'package:flutter/material.dart';
import 'package:flutter_cafe_admin/my_cafe.dart';

MyCafe myCafe = MyCafe();
String categoryCollectionName = "cafe-category";
String itemColletionName = "cafe-item";

class CafeItem extends StatefulWidget {
  const CafeItem({super.key});

  @override
  State<CafeItem> createState() => _CafeItemState();
}

class _CafeItemState extends State<CafeItem> {
  dynamic body = const Text("Loading . . . ");

  Future<void> getCategory() async {
    setState(() {
      body = FutureBuilder(
        future: myCafe.getData(
            collection: categoryCollectionName,
            fieldName: null,
            fieldValue: null,
            id: null),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var datas = snapshot.data?.docs;
            if (datas == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.separated(
              itemBuilder: (context, index) {
                var data = datas[index];
                return ListTile(
                  title: Text(data['categoryName']),
                  trailing: PopupMenuButton(
                    onSelected: (value) async {
                      if (value == "modifiy") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CafeCategoryAddForm(
                                documentID: data.id,
                              ),
                            ));
                      } else if (value == "delete") {
                        var result = await myCafe.deleteData(
                          collection: categoryCollectionName,
                          documentID: data.id,
                        );

                        if (result == true) {
                          getCategory();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "modifiy",
                        child: Text("수정"),
                      ),
                      const PopupMenuItem(
                        value: "delete",
                        child: Text("삭제"),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
              itemCount: datas.length,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CafeCategoryAddForm(
                documentID: null,
              ),
            ),
          );

          if (result == true) {
            getCategory();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CafeCategoryAddForm extends StatefulWidget {
  String? documentID;
  CafeCategoryAddForm({super.key, required this.documentID});

  @override
  State<CafeCategoryAddForm> createState() => _CafeCategoryAddFormState();
}

class _CafeCategoryAddFormState extends State<CafeCategoryAddForm> {
  TextEditingController controller = TextEditingController();

  var isUsed = true;
  var documentID;

  Future<dynamic> getData(String docID) async {
    var data = await myCafe.getData(
        collection: categoryCollectionName,
        id: docID,
        fieldName: null,
        fieldValue: null);

    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    documentID = widget.documentID;

    if (documentID != null) {
      var data = getData(documentID);
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Add Form"),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                var result = await myCafe.insertData(
                  collection: categoryCollectionName,
                  data: {'categoryName': controller.text, 'isUsed': isUsed},
                );

                if (result) {
                  Navigator.pop(context, true);
                }
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text("카테고리 이름을 입력 해주세요"),
              border: OutlineInputBorder(),
            ),
            controller: controller,
          ),
          SwitchListTile(
            title: const Text("사용 여부"),
            value: isUsed,
            onChanged: (value) {
              setState(() {
                isUsed = value;
              });
            },
          )
        ],
      ),
    );
  }
}
