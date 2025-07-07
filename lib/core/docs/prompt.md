[FEATURE_NAME] = Passenger Service List Retrieval
[HTTP_METHOD] = GET
[API_ENDPOINT] = api/passenger/services

[REQUEST_MODEL_NAME] = N/A
[RESPONSE_MODEL_NAME] = PassengerServiceListResponseModel
[ENTITY_NAME] = PassengerServiceEntity
[MAPPER_NAME] = PassengerServiceMapper
[DATASOURCE_NAME] = PassengerServiceRemoteDataSource
[REPOSITORY_NAME] = PassengerServiceRepository
[USECASE_NAME] = GetPassengerServicesUseCase
[USECASE_PARAMS] = GetPassengerServicesParams
[RETURN_TYPE] = List<PassengerServiceEntity>




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
   N/A
    ```
    
- **Response:** Assume the API returns a 200 OK status on success.
- **Response Body (JSON):**
    
    ```json
    [RESPONSE_BODY_JSON]
    {
    "success": true,
    "message": "Service retrieved successfully",
    "data": [
        {
            "_id": "68691d6cb297b47bf772acd2",
            "serviceName": "package",
            "image": "/image/package-1751860027893.jpg",
            "baseFare": 50,
            "status": "active",
            "createdAt": "2025-07-05T12:41:16.883Z",
            "updatedAt": "2025-07-07T03:47:07.939Z",
            "__v": 0
        },
        {
            "_id": "68692c8d43a90930ff01d1cd",
            "serviceName": "rental-car",
            "image": "/image/car-1751860148471.png",
            "baseFare": 50,
            "status": "active",
            "createdAt": "2025-07-05T13:45:49.518Z",
            "updatedAt": "2025-07-07T03:49:08.520Z",
            "__v": 0
        },
        {
            "_id": "68692d75ab14ba0851a37c55",
            "serviceName": "emergency-car",
            "image": "/image/car-1751860193361.png",
            "baseFare": 400,
            "status": "active",
            "createdAt": "2025-07-05T13:49:41.716Z",
            "updatedAt": "2025-07-07T03:49:53.405Z",
            "__v": 0
        },
        {
            "_id": "686b425f8543d3c4a6701c32",
            "serviceName": "car",
            "image": "/image/car-1751859807910.png",
            "baseFare": 50,
            "status": "active",
            "createdAt": "2025-07-07T03:43:27.955Z",
            "updatedAt": "2025-07-07T03:43:27.955Z",
            "__v": 0
        }
    ]}
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