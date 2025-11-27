

class MockApiService {
  Future<List<Map<String, dynamic>>> getPosts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {
        "id": 1,
        "title": 'Post 1',
        "body": 'This is the body of post 1',
        "authorId": 1,
      },
      {
        "id": 2,
        "title": 'Post 2',
        "body": 'This is the body of post 2',
        "authorId": 2,
      },
    ];
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return  {
      "id": "1",
      "name": 'John Doe',
      "email": 'john.doe@example.com',
      "phoneNumber": '123-456-7890',
    };
  }
}
// This is a mock API service that simulates fetching posts and user profile data.