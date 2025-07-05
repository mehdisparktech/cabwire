# Flutter Clean Architecture API Integration Prompt Template

Generate Dart code for a **[FEATURE_NAME]** feature in a Flutter project that follows Clean Architecture.

## Configuration Instructions:
**Replace the following placeholders with your specific requirements:**

- `[FEATURE_NAME]` - Name of your feature (e.g., "Contact Management", "User Profile Update")
- `[HTTP_METHOD]` - HTTP method (GET, POST, PATCH, DELETE)
- `[API_ENDPOINT]` - Your API endpoint (e.g., "api/contact", "api/users/profile")
- `[REQUEST_MODEL_NAME]` - Name for request model (e.g., "CreateContactModel", "UpdateProfileModel")
- `[RESPONSE_MODEL_NAME]` - Name for response model (e.g., "ContactResponseModel", "ProfileResponseModel")
- `[ENTITY_NAME]` - Name for domain entity (e.g., "ContactEntity", "ProfileEntity")
- `[MAPPER_NAME]` - Name for mapper (e.g., "ContactMapper", "ProfileMapper")
- `[DATASOURCE_NAME]` - Name for data source (e.g., "ContactRemoteDataSource", "ProfileRemoteDataSource")
- `[REPOSITORY_NAME]` - Name for repository (e.g., "ContactRepository", "ProfileRepository")
- `[USECASE_NAME]` - Name for use case (e.g., "CreateContactUseCase", "UpdateProfileUseCase")
- `[USECASE_PARAMS]` - Name for use case parameters class (e.g., "CreateContactParams", "UpdateProfileParams")
- `[REQUEST_BODY_JSON]` - Your request body JSON structure
- `[RESPONSE_BODY_JSON]` - Your expected response JSON structure
- `[RETURN_TYPE]` - Use case return type (e.g., "void", "ContactEntity", "ProfileEntity")

---

## Prompt Template:

Generate Dart code for a **[FEATURE_NAME]** feature in a Flutter project that follows Clean Architecture.

Here are the detailed requirements:

### 1. **Objective:** 
Implement an API call to [DESCRIBE_THE_FEATURE_PURPOSE].

### 2. **API Details:**
- **Method:** [HTTP_METHOD]
- **Example URL:** `[API_ENDPOINT]`
- **Request Body (JSON):**
  ```json
  [REQUEST_BODY_JSON]
  ```
- **Response:** Assume the API returns a 200 OK status on success.
- **Response Body (JSON):**
  ```json
  [RESPONSE_BODY_JSON]
  ```

### 3. **Project Flow & Folder Structure:**
- **API Endpoint Constant:** `lib/core/config/api/api_end_point.dart`
- **Data Layer:**
  - **Request Model:** Create `[REQUEST_MODEL_NAME]` in `lib/data/models/` for the request body.
  - **Response Model:** Create `[RESPONSE_MODEL_NAME]` in `lib/data/models/` for the response body.
  - **Mapper:** Create `[MAPPER_NAME]` in `lib/data/mappers/` to convert between domain entities and data models.
  - **Remote Data Source:** Create `[DATASOURCE_NAME]` (abstract) and `[DATASOURCE_NAME]Impl` (implementation) in `lib/data/datasources/remote/`. The implementation should use the ApiService for the [HTTP_METHOD] request.
  - **Repository Implementation:** Create `[REPOSITORY_NAME]Impl` in `lib/data/repositories/` which implements the domain repository. It should call the data source and handle errors using the Result type.
- **Domain Layer:**
  - **Entity:** Create `[ENTITY_NAME]` in `lib/domain/entities/`. This is the core business object that contains only the essential business logic and properties.
  - **Repository Interface:** Create an abstract class `[REPOSITORY_NAME]` in `lib/domain/repositories/`. The method should return `Future<Result<[RETURN_TYPE]>>` for robust error handling (where Result is Either<String, T> from fpdart).
  - **UseCase:** Create `[USECASE_NAME]` in `lib/domain/usecases/`. It should depend on `[REPOSITORY_NAME]`. Create a `[USECASE_PARAMS]` class to pass parameters to the use case.
- **Presentation Layer:**
  - **Presenter:** Create a presenter class `[FEATURE_NAME]Presenter` in the appropriate module's presenter folder that will handle the business logic.
  - **UI State:** Create a UI state class `[FEATURE_NAME]UiState` that extends BaseUiState to represent the UI state.
  - **UI:** Provide a simple example of how a screen would inject the presenter and handle the state changes.

### 4. **Error Handling:**
- Use the `Result` type (which is an alias for `Either<String, T>` from the `fpdart` package) for functional error handling.
- Handle common HTTP errors (400, 401, 403, 404, 500, etc.).
- Include proper exception handling for network errors.
- Use the existing error handling infrastructure in the ApiService.

### 5. **Additional Requirements:**
- Follow Dart naming conventions and best practices.
- Include proper imports and class definitions.
- Add comprehensive error handling.
- Ensure type safety throughout the implementation.

Please generate all the necessary Dart code files with proper imports and class definitions according to this Clean Architecture structure.

---

## Example Usage:

### For a Contact Creation Feature:
```
[FEATURE_NAME] = Contact Management
[HTTP_METHOD] = POST
[API_ENDPOINT] = api/contact
[REQUEST_MODEL_NAME] = CreateContactModel
[RESPONSE_MODEL_NAME] = ContactResponseModel
[ENTITY_NAME] = ContactEntity
[MAPPER_NAME] = ContactMapper
[DATASOURCE_NAME] = ContactRemoteDataSource
[REPOSITORY_NAME] = ContactRepository
[USECASE_NAME] = CreateContactUseCase
[USECASE_PARAMS] = CreateContactParams
[RETURN_TYPE] = void
```

### For a Profile Update Feature:
```
[FEATURE_NAME] = User Profile Update
[HTTP_METHOD] = PATCH
[API_ENDPOINT] = api/users/profile
[REQUEST_MODEL_NAME] = UpdateProfileModel
[RESPONSE_MODEL_NAME] = ProfileResponseModel
[ENTITY_NAME] = ProfileEntity
[MAPPER_NAME] = ProfileMapper
[DATASOURCE_NAME] = ProfileRemoteDataSource
[REPOSITORY_NAME] = ProfileRepository
[USECASE_NAME] = UpdateProfileUseCase
[USECASE_PARAMS] = UpdateProfileParams
[RETURN_TYPE] = String
```

### For a Data Retrieval Feature:
```
[FEATURE_NAME] = User List Retrieval
[HTTP_METHOD] = GET
[API_ENDPOINT] = api/users
[REQUEST_MODEL_NAME] = N/A (for GET requests)
[RESPONSE_MODEL_NAME] = UserListResponseModel
[ENTITY_NAME] = UserEntity
[MAPPER_NAME] = UserMapper
[DATASOURCE_NAME] = UserRemoteDataSource
[REPOSITORY_NAME] = UserRepository
[USECASE_NAME] = GetUsersUseCase
[USECASE_PARAMS] = GetUsersParams
[RETURN_TYPE] = List<UserEntity>
```

### For a Data Deletion Feature:
```
[FEATURE_NAME] = User Account Deletion
[HTTP_METHOD] = DELETE
[API_ENDPOINT] = api/users/{id}
[REQUEST_MODEL_NAME] = N/A (for DELETE requests)
[RESPONSE_MODEL_NAME] = DeleteResponseModel
[ENTITY_NAME] = N/A
[MAPPER_NAME] = N/A
[DATASOURCE_NAME] = UserRemoteDataSource
[REPOSITORY_NAME] = UserRepository
[USECASE_NAME] = DeleteUserUseCase
[USECASE_PARAMS] = DeleteUserParams
[RETURN_TYPE] = String
```

---

## Notes:
- Replace all placeholders with your actual values before using the prompt.
- Adjust the return type based on whether you need to return data or just confirm success.
- For GET requests, you may not need a request model.
- For DELETE requests, you typically only need an ID parameter.
- Customize the JSON structures according to your API specifications.
