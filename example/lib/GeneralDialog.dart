import 'package:flutter/material.dart';

class GeneralDialog extends Dialog {
  final String title; // 顶部标题
  final String content; // 内容
  final String cancelTxt; // 取消按钮的文本
  final String enterTxt; // 确认按钮的文本
  final Function? callback; // 修改之后的回掉函数

  GeneralDialog({
    this.title = "",
    this.content = "", // 根据content来，判断显示哪种类型
    this.cancelTxt = "取消",
    this.enterTxt = "确定",
    this.callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // 点击遮罩层隐藏弹框
        child: Material(
            type: MaterialType.transparency, // 配置透明度
            child: Center(
                child: GestureDetector( // 点击遮罩层关闭弹框，并且点击非遮罩区域禁止关闭
                    onTap: () {
                      //保持dialog显示状态
                    },
                    child: Container(
                        width: 315,
                        height: 175,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: <Widget>[
                              Visibility(
                                  visible: title.isNotEmpty,
                                  child: Positioned(
                                      top: 0,
                                      child: Container(
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                                          child: Text(
                                              title,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600
                                              )
                                          )
                                      )
                                  )
                              ),
                              Container(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  alignment: Alignment.center,
                                  child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 42),
                                      alignment: Alignment.center,
                                      child: Text(
                                          content,
                                          style: const TextStyle(
                                              color: Color(0xFF8E8E93),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400
                                          )
                                      )
                                  )
                              ),
                              Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                      border: Border(top: BorderSide(width: 1,color: Color(0xFFEAEAEA)))
                                  ),
                                  child: Row(
                                      children: <Widget>[
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                    height: double.infinity,
                                                    alignment: Alignment.center,
                                                    decoration: const BoxDecoration(
                                                        border: Border(right: BorderSide(width: 1,color: Color(0xFFEAEAEA)))
                                                    ),
                                                    child: Text(cancelTxt,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400
                                                        )
                                                    )
                                                ),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                }
                                            )
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: GestureDetector(
                                                behavior: HitTestBehavior.opaque,
                                                child: Container(
                                                    height: double.infinity, // 继承父级的高度
                                                    alignment: Alignment.center,
                                                    child: Text(enterTxt,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w400
                                                        )
                                                    )
                                                ),
                                                onTap: () {
                                                  callback?.call();
                                                  Navigator.pop(context); // 关闭dialog
                                                }
                                            )
                                        )
                                      ]
                                  )
                              )
                            ]
                        )
                    )
                )
            )
        ),
        onTap: () {
          Navigator.pop(context);
        }
    );
  }
}