import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TweetRepo {
  Future<bool> createTweetWImages(
      String body, List<File> images, String accessToken) async {
    // API endpoint
    final uri = Uri.parse("https://l0wk3ycracks.pythonanywhere.com/tweets/");

    // Create a Multipart request
    var request = http.MultipartRequest('POST', uri);

    try {
      // Add headers
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';

      // Add tweet body field
      request.fields['body'] = body;

      // Attach image files
      for (var image in images) {
        debugPrint(image.path);
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Matches the "images" field in your API serializer
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        debugPrint(
            "Error creating tweet with images: ${response.statusCode} - $responseBody");
        debugPrint("Tweet created successfully with images.");
        return true;
      } else {
        // Read the error message from the response stream
        final responseBody = await response.stream.bytesToString();
        debugPrint(
            "Error creating tweet with images: ${response.statusCode} - $responseBody");
        return false;
      }
    } catch (e) {
      debugPrint("Error creating tweet with images: $e");
      return false;
    }
  }

  Future<bool> createTweet(String body, String accessToken) async {
    final uri = Uri.parse("https://l0wk3ycracks.pythonanywhere.com/tweets/");
    var request = http.MultipartRequest('POST', uri);

    // Set the authorization header
    request.headers["Authorization"] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add the tweet body to the request
    request.fields["body"] = body;
    // Send the request and get the response
    final response = await request.send();

    // Get the response body (useful for debugging)
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      debugPrint("Response Body: $responseBody");
      return true;
    } else {
      debugPrint("Response Body: $responseBody");
      return false;
    }
  }

  Future<bool> createReplyWImages(String body, List<File> images,
      String accessToken, String tweetid) async {
    // API endpoint
    final uri = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/$tweetid/replies");

    // Create a Multipart request
    var request = http.MultipartRequest('POST', uri);

    try {
      // Add headers
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';

      // Add tweet body field
      request.fields['body'] = body;

      // Attach image files
      for (var image in images) {
        debugPrint(image.path);
        request.files.add(await http.MultipartFile.fromPath(
          'images', // Matches the "images" field in your API serializer
          image.path,
        ));
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        debugPrint(
            "Error creating tweet with images: ${response.statusCode} - $responseBody");
        debugPrint("Tweet created successfully with images.");
        return true;
      } else {
        // Read the error message from the response stream
        final responseBody = await response.stream.bytesToString();
        debugPrint(
            "Error creating tweet with images: ${response.statusCode} - $responseBody");
        return false;
      }
    } catch (e) {
      debugPrint("Error creating tweet with images: $e");
      return false;
    }
  }

  Future<bool> createReply(
      String body, String accessToken, String tweetid) async {
    final uri = Uri.parse(
        "https://l0wk3ycracks.pythonanywhere.com/tweets/$tweetid/replies");
    var request = http.MultipartRequest('POST', uri);

    // Set the authorization header
    request.headers["Authorization"] = 'Bearer $accessToken';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add the tweet body to the request
    request.fields["body"] = body;
    // Send the request and get the response
    final response = await request.send();

    // Get the response body (useful for debugging)
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      debugPrint("Response Body: $responseBody");
      return true;
    } else {
      debugPrint("Response Body: $responseBody");
      return false;
    }
  }
}
