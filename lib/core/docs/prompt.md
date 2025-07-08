[FEATURE_NAME] = Ride Request Creation
[HTTP_METHOD] = POST
[API_ENDPOINT] = api/ride/create-ride

[REQUEST_MODEL_NAME] = CreateRideRequestModel
[RESPONSE_MODEL_NAME] = RideResponseModel
[ENTITY_NAME] = RideEntity
[MAPPER_NAME] = RideMapper
[DATASOURCE_NAME] = RideRemoteDataSource
[REPOSITORY_NAME] = RideRepository
[USECASE_NAME] = CreateRideRequestUseCase
[USECASE_PARAMS] = CreateRideRequestParams
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
    "service": "6852d20476efad465ae5578a",
    "category": "683db540aa2a9734dbc067bc",
    "pickupLocation": {
        "lat": 23.8103,
        "lng": 90.4125,
        "address": "Dhaka, Bangladesh"
    },
    "dropoffLocation": {
        "lat": 23.7522,
        "lng": 90.3918,
        "address": "Mirpur, Dhaka"
    },
    // "distance": 12.5,
    "paymentMethod": "stripe"}
    ```
    
- **Response:** Assume the API returns a 200 OK status on success.
- **Response Body (JSON):**
    
    ```json
    [RESPONSE_BODY_JSON]
    {
    "success": true,
    "message": "Ride created successfully",
    "data": {
        "userId": "685a7b2a2e8c8fd76a0ed8fc",
        "service": "6852d20476efad465ae5578a",
        "category": "683db540aa2a9734dbc067bc",
        "pickupLocation": {
            "lat": 23.8103,
            "lng": 90.4125,
            "address": "Dhaka, Bangladesh"
        },
        "dropoffLocation": {
            "lat": 23.7522,
            "lng": 90.3918,
            "address": "Mirpur, Dhaka"
        },
        "distance": 6.795114946577798,
        "duration": 30,
        "fare": 212.88,
        "rideStatus": "requested",
        "paymentMethod": "stripe",
        "paymentStatus": "pending",
        "rideType": "Car",
        "_id": "685a7bdd2e8c8fd76a0ed912",
        "createdAt": "2025-06-24T10:20:13.472Z",
        "updatedAt": "2025-06-24T10:20:13.472Z",
        "__v": 0
    }}
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