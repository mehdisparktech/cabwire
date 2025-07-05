[FEATURE_NAME] = Passenger Email Verification
[HTTP_METHOD] = POST
[API_ENDPOINT] = api/auth/verify-email
[REQUEST_MODEL_NAME] = VerifyEmailModel
[RESPONSE_MODEL_NAME] = VerifyEmailResponseModel
[ENTITY_NAME] = VerifyEmailEntity
[MAPPER_NAME] = VerifyEmailMapper
[DATASOURCE_NAME] = VerifyEmailRemoteDataSource
[REPOSITORY_NAME] = VerifyEmailRepository
[USECASE_NAME] = VerifyEmailUseCase
[USECASE_PARAMS] = VerifyEmailParams
[RETURN_TYPE] = void



Generate Dart code for a **[FEATURE_NAME]** feature in a Flutter project that follows Clean Architecture.

Here are the detailed requirements:

### **1. Objective:**

Implement an API call to [DESCRIBE_THE_FEATURE_PURPOSE].

### **2. API Details:**

- **Method:** [HTTP_METHOD]
- **Example URL:** `[API_ENDPOINT]`
- **Request Body (JSON):**
    
    ```json
    [REQUEST_BODY_JSON]
   {
    "email": "zn.rabby@gmail.com",
    "oneTimeCode": 1305 }
    ```
    
- **Response:** Assume the API returns a 200 OK status on success.
- **Response Body (JSON):**
    
    ```json
    [RESPONSE_BODY_JSON]
    {
    "success": true,
    "message": "Email verify successfully",
    "data": {}}
    ```

### **3. Project Flow & Folder Structure:**

- **API Endpoint Constant:** `lib/core/config/api/api_end_point.dart`
- **Data Layer:**
    - **Request Model:** Create `[REQUEST_MODEL_NAME]` in `lib/data/models/` for the request body.
    - **Response Model:** Create `[RESPONSE_MODEL_NAME]` in `lib/data/models/` for the response body.
    - **Mapper:** Create `[MAPPER_NAME]` in `lib/data/mappers/` to convert between domain entities and data models.
    - **Remote Data Source:** Create `[DATASOURCE_NAME]` (abstract) and `[DATASOURCE_NAME]Impl` (implementation) in `lib/data/datasources/remote/`. The implementation should use the ApiService for the [HTTP_METHOD] request.
    - **Repository Implementation:** Create `[REPOSITORY_NAME]Impl` in `lib/data/repositories/` which implements the domain repository. It should call the data source and handle errors using the Result type.
- **Domain Layer:**
    - **Entity:** Create `[ENTITY_NAME]` in `lib/domain/entities/`. This is the core business object that contains only the essential business logic and properties.
    - **Repository Interface:** Create an abstract class `[REPOSITORY_NAME]` in `lib/domain/repositories/`. The method should return `Future<Result<[RETURN_TYPE]>>` for robust error handling (where Result is Either<String, T> from fpdart).
    - **UseCase:** Create `[USECASE_NAME]` in `lib/domain/usecases/`. It should depend on `[REPOSITORY_NAME]`. Create a `[USECASE_PARAMS]` class to pass parameters to the use case.
- **Presentation Layer:**
    - **Presenter:** Create a presenter class `[FEATURE_NAME]Presenter` in the appropriate module's presenter folder that will handle the business logic.
    - **UI State:** Create a UI state class `[FEATURE_NAME]UiState` that extends BaseUiState to represent the UI state.
    - **UI:** Provide a simple example of how a screen would inject the presenter and handle the state changes.

### **4. Error Handling:**

- Use the `Result` type (which is an alias for `Either<String, T>` from the `fpdart` package) for functional error handling.
- Handle common HTTP errors (400, 401, 403, 404, 500, etc.).
- Include proper exception handling for network errors.
- Use the existing error handling infrastructure in the ApiService.

### **5. Additional Requirements:**

- Follow Dart naming conventions and best practices.
- Include proper imports and class definitions.
- Add comprehensive error handling.
- Ensure type safety throughout the implementation.

Please generate all the necessary Dart code files with proper imports and class definitions according to this Clean Architecture structure.