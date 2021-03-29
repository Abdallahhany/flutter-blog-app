import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandling{
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();
  Future get(String url)async{
    String token = await storage.read(key: "token");
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/$url');
    var response = await http.get(baseUrl,headers: {"Authorization":"Bearer $token"});
    if(response.statusCode == 200 || response.statusCode ==201){
      log.i(response.body);
      return jsonDecode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }
  Future<http.Response> post (String url,Map<String,String>body)async{
    String token = await storage.read(key: "token");
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/$url',);
    var response = await http.post(baseUrl,body: jsonEncode(body),
      headers: {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
      },
    );
      return response;
  }
  Future<http.Response> postBlog (String url,var body)async{
    String token = await storage.read(key: "token");
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/$url',);
    var response = await http.post(baseUrl,body: jsonEncode(body),
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return response;
  }
  Future<http.StreamedResponse> patchImage (String url,String filePath )async{
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/$url',);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', baseUrl);
    request.files.add(await http.MultipartFile.fromPath("img", filePath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    });
    var response = request.send();
    return response;
  }
  NetworkImage getImage(String imageName){
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/uploads//$imageName.jpg',);
    return NetworkImage(baseUrl.toString());
  }

  Future<http.Response> patch(String url,Map<String,String>body )async{
    var baseUrl = Uri.parse('https://mighty-beyond-87908.herokuapp.com/$url',);
    String token = await storage.read(key: "token");
    var response = http.patch(baseUrl,body:jsonEncode(body),headers:  {
      "Content-type": "application/json",
      "Authorization": "Bearer $token"
    }, );
    return response;
  }
}