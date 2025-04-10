import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../azlistview/index.dart';
import '../common/github_language_colors.dart';
import '../common/index.dart';

Color hexToColor(String? hexString, {Color defaultColor = Colors.grey}) {
  // 检查 hexString 是否为空或 null
  if (hexString == null || hexString.isEmpty) {
    return defaultColor;
  }

  // 移除 # 符号（如果存在）
  final String hex = hexString.replaceAll('#', '');

  if (hex.length == 6) {
    // 6位十六进制（无透明度）
    return Color(int.parse('FF$hex', radix: 16));
  } else if (hex.length == 8) {
    // 8位十六进制（包含透明度）
    return Color(int.parse(hex, radix: 16));
  } else {
    // 无效的十六进制颜色格式，返回默认颜色
    return defaultColor;
  }
}

class GitHubLanguagePage extends StatefulWidget {
  const GitHubLanguagePage({
    super.key,
    this.fromType,
  });
  final int? fromType;

  @override
  GitHubLanguagePageState createState() => GitHubLanguagePageState();
}

class GitHubLanguagePageState extends State<GitHubLanguagePage> {
  /// Controller to scroll or jump to a particular item.
  final ItemScrollController itemScrollController = ItemScrollController();

  List<Languages> originList = [];
  List<Languages> dataList = [];

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    loadData();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void loadData() async {
    originList = LanguageHelper.getGithubLanguages().map((v) {
      Languages model = Languages.fromJson(v.toJson());
      String tag = model.name.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        model.tagIndex = tag;
      } else {
        model.tagIndex = "#";
      }
      return model;
    }).toList();
    _handleList(originList);
  }

  void _handleList(List<Languages> list) {
    dataList.clear();
    if (ObjectUtil.isEmpty(list)) {
      setState(() {});
      return;
    }
    dataList.addAll(list);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(dataList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(dataList);

    setState(() {});

    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: 0);
    }
  }

  Widget getSusItem(BuildContext context, String tag, {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget getListItem(BuildContext context, Languages model,
      {double susHeight = 40}) {
    return ListTile(
      title: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: hexToColor(model.color),
              borderRadius: BorderRadius.circular(4),
            ),
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 10),
          Text(
            model.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        LogUtil.v("onItemClick : $model");
        Utils.showSnackBar(context, "onItemClick : $model");
      },
    );
  }

  void _search(String text) {
    if (ObjectUtil.isEmpty(text)) {
      _handleList(originList);
    } else {
      List<Languages> list = originList.where((v) {
        return v.name.toLowerCase().contains(text.toLowerCase());
      }).toList();
      _handleList(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('github_language_page'),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(255, 225, 226, 230), width: 0.33),
                  color: Color.fromARGB(255, 239, 240, 244),
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  _search(value);
                },
                controller: textEditingController,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colours.gray_33,
                    ),
                    suffixIcon: Offstage(
                      offstage: textEditingController.text.isEmpty,
                      child: InkWell(
                        onTap: () {
                          textEditingController.clear();
                          _search('');
                        },
                        child: Icon(
                          Icons.cancel,
                          color: Colours.gray_99,
                        ),
                      ),
                    ),
                    border: InputBorder.none,
                    hintText: 'Search language',
                    hintStyle: TextStyle(color: Colours.gray_99)),
              ),
            ),
            Expanded(
              child: AzListView(
                data: dataList,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  Languages model = dataList[index];
                  return getListItem(context, model);
                },
                itemScrollController: itemScrollController,
                susItemBuilder: (BuildContext context, int index) {
                  Languages model = dataList[index];
                  return getSusItem(context, model.getSuspensionTag());
                },
                indexBarOptions: IndexBarOptions(
                  needRebuild: true,
                  hapticFeedback: true,
                  selectTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                  selectItemDecoration: BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFF333333)),
                  indexHintWidth: 96,
                  indexHintHeight: 97,
                  indexHintDecoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          Utils.getImgPath('ic_index_bar_bubble_white')),
                      fit: BoxFit.contain,
                    ),
                  ),
                  indexHintAlignment: Alignment.centerRight,
                  indexHintTextStyle:
                      TextStyle(fontSize: 24.0, color: Colors.black87),
                  indexHintOffset: Offset(-30, 0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
