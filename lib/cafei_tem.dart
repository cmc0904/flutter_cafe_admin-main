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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("hi"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CafeCategoryAddForm(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CafeCategoryAddForm extends StatefulWidget {
  const CafeCategoryAddForm({super.key});

  @override
  State<CafeCategoryAddForm> createState() => _CafeCategoryAddFormState();
}

class _CafeCategoryAddFormState extends State<CafeCategoryAddForm> {
  TextEditingController controller = TextEditingController();

  var isUsed = true;

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
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
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
