import 'dart:convert';
import 'package:contactsapp/constants/constant_key.dart';
import 'package:contactsapp/usermodel/model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // CREATE USER =>>>------------------------------------------------------

  Future<void> createUser(String firstName, String lastName, String phoneNumber,
      String imagePath) async {
    String apiUrl = '${ConstantKey.apiUrls}';

    try {
      var requestBody = jsonEncode(UserInfo(
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phoneNumber,
              profileImageUrl: imagePath)
          .toMap());

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'ApiKey': ConstantKey.apiKey,
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData =
            jsonDecode(response.body) as Map<String, dynamic>;

        String? newUserId = responseData['id'] as String?;
        String? newFirstName = responseData['firstName'] as String?;
        String? newLastName = responseData['lastName'] as String?;
        String? newPhoneNumber = responseData['phoneNumber'] as String?;
        String? newProfileImageUrl = responseData['profileImageUrl'] as String?;

        print('Yeni kullanıcı oluşturuldu:');
        print('ID: ${newUserId ?? 'N/A'}');
        print('Ad: ${newFirstName ?? 'N/A'}');
        print('Soyad: ${newLastName ?? 'N/A'}');
        print('Telefon Numarası: ${newPhoneNumber ?? 'N/A'}');
        print('Profil Resmi URL: ${newProfileImageUrl ?? 'N/A'}');
      } else {
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

// GET USER =>>-------------------------------------------------

  Future<List<UserInfo>> getUsers() async {
    String apiUrl = '${ConstantKey.apiUrls}?skip=0&take=10';

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'accept': 'text/plain',
          'ApiKey': ConstantKey.apiKey
        },
      );

      // Başarılı bir şekilde oluşturulduysa
      if (response.statusCode == 200) {
        List<UserInfo> userList = [];

        // API'den gelen yanıtı alma ve işleme alma
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // JSON'dan veri çekiliyor
        var usersData = responseData['data']['users'];

        // Her bir kullanıcı için işlem yapılabilir
        for (var userData in usersData) {
          var user = UserInfo.fromMap(userData);
          userList.add(user);
        }

        return userList;
      } else {
        // Başarısız istek durumunda kullanıcıya bir hata mesajı verme
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print("${e} hata");
      return [];
    }
  }

  // UPLOAD IMAGE =>>-------------------------------------------------

  Future<String> uploadImage(String imagePath) async {
    // API endpoint
    var apiUrl = Uri.parse('${ConstantKey.apiUrls}/UploadImage');

    try {
      // HTTP Multipart request
      var request = http.MultipartRequest('POST', apiUrl);

      // Dosya ekleme
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Sunucuda beklenen dosya alanı adı
        imagePath,
        contentType: MediaType('image', 'jpg'), // Dosya türü
      ));

      // Başlıklar ekleme
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'accept': 'application/json',
        'ApiKey': ConstantKey.apiKey,
      });

      // İstek gönderme
      var response = await request.send();

      // Yanıt işleme
      if (response.statusCode == 200) {
        var responseData = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responseData.body);

        // JSON'dan veri çekiliyor
        var usersImage = jsonResponse['data']['imageUrl'];
        print(usersImage);
        return usersImage;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');

        return '';
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  // DELETE USER =>>-------------------------------------------------

  Future<void> deleteUser(String userId) async {
    String apiUrl = '${ConstantKey.apiUrls}/$userId';

    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'ApiKey': ConstantKey.apiKey,
        },
      );

      if (response.statusCode == 200) {
        print('Kullanıcı başarıyla silindi.');
      } else {
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  // UPDATE USER =>>-------------------------------------------------

  Future<void> updateUser(String id, String firstName, String lastName,
      String phoneNumber, String imagePath) async {
    String apiUrl = '${ConstantKey.apiUrls}/$id';

    try {
      var requestBody = jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'profileImageUrl': imagePath,
      });

      var response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'ApiKey': ConstantKey.apiKey,
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Kullanıcı başarıyla güncellendi.');

        Map<String, dynamic> responseData = jsonDecode(response.body);
        String? updatedUserId = responseData['id'] as String?;
        String? updatedFirstName = responseData['firstName'] as String?;
        String? updatedLastName = responseData['lastName'] as String?;
        String? updatedPhoneNumber = responseData['phoneNumber'] as String?;
        String? updatedProfileImageUrl =
            responseData['profileImageUrl'] as String?;

        print('Güncellenmiş Kullanıcı Bilgileri:');
        print('ID: ${updatedUserId ?? 'N/A'}');
        print('Ad: ${updatedFirstName ?? 'N/A'}');
        print('Soyad: ${updatedLastName ?? 'N/A'}');
        print('Telefon Numarası: ${updatedPhoneNumber ?? 'N/A'}');
        print('Profil Resmi URL: ${updatedProfileImageUrl ?? 'N/A'}');
      } else {
        throw Exception('API isteği başarısız oldu: ${response.statusCode}');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }
}
