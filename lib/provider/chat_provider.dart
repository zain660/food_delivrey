import 'dart:async';
import 'package:flutter_restaurant/data/model/response/base/api_response.dart';
import 'package:flutter_restaurant/data/repository/notification_repo.dart';
import 'package:flutter_restaurant/helper/api_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/chat_model.dart';
import 'package:flutter_restaurant/data/repository/chat_repo.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  final NotificationRepo notificationRepo;
  ChatProvider({@required this.chatRepo, @required this.notificationRepo});

  List<bool> _showDate;
  List<XFile> _imageFiles;
  XFile _imageFile;
  bool _isSendButtonActive = false;
  bool _isSeen = false;
  bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  bool get isLoading => _isLoading;

  List<bool> get showDate => _showDate;
  List<XFile> get imageFiles => _imageFiles;
  XFile get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  List<Messages>  _deliveryManMessages = [];
  List<Messages> get deliveryManMessages => _deliveryManMessages;
  List<Messages>  _adminManMessages = [];
  List<Messages> get adminManMessages => _adminManMessages;
  List <XFile>_chatImage = [];
  List<XFile> get chatImage => _chatImage;

  Future<void> getDeliveryManMessages (BuildContext context, int orderId) async {
    ApiResponse apiResponse = await chatRepo.getDeliveryManMessage(orderId,1);
    _deliveryManMessages = [];
    if (apiResponse.response != null&& apiResponse.response.data['messages']!= {} && apiResponse.response.statusCode == 200) {
      _deliveryManMessages.addAll(ChatModel.fromJson(apiResponse.response.data).messages);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getAdminManMessages (BuildContext context, int offset) async {
    ApiResponse apiResponse = await chatRepo.getAdminMessage(1);
    _adminManMessages = [];
    if (apiResponse.response != null&& apiResponse.response.data['messages']!= {} && apiResponse.response.statusCode == 200) {
      _adminManMessages.addAll(ChatModel.fromJson(apiResponse.response.data).messages);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFile = null;
      _chatImage = [];
    }else {
      _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (_imageFile != null) {
        _chatImage.add(_imageFile);
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessageToDeliveryMan(String message, List<XFile> file, int orderId, BuildContext context, String token) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessageToDeliveryMan(message, file, orderId, token);
    if (response.statusCode == 200) {
      _imageFile = null;
      _chatImage = [];
      file =[];
      getDeliveryManMessages(context, orderId);
      _isLoading = false;
    } else {
      print('===${response.statusCode}');
    }
    _imageFile = null;
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  Future<http.StreamedResponse> sendMessageToAdmin(String message, BuildContext context, String token) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessageToAdmin(message, _chatImage, token);
    if (response.statusCode == 200) {
      print('======Message =======>${message.toString()}');
      _imageFile = null;
      _chatImage = [];
      getAdminManMessages(context,1);
      _isLoading = false;
    } else {
      print('===${response.statusCode}');
    }
    _imageFile = null;
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

}