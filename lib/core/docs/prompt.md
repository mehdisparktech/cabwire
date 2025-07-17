[FEATURE_NAME] = Get Ride History
[HTTP_METHOD] = GET
[API_ENDPOINT] = api/ride/ride

[RESPONSE_MODEL_NAME] = RideHistoryResponseModel
[ENTITY_NAME] = RideEntity
[USER_ENTITY_NAME] = RideUserEntity
[DRIVER_ENTITY_NAME] = RideDriverEntity
[RESPONSE_LIST_MODEL] = List<RideModel>
[MAPPER_NAME] = RideHistoryMapper
[DATASOURCE_NAME] = RideHistoryRemoteDataSource
[REPOSITORY_NAME] = RideHistoryRepository
[USECASE_NAME] = GetRideHistoryUseCase
[USECASE_PARAMS] = NoParams
[RETURN_TYPE] = List<RideEntity>



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
   

    ```
- **Response:** Assume the API returns a 200 OK status on success.
- **Response Body (JSON):**
    ```json
    [RESPONSE_BODY_JSON]
  {
    "success": true,
    "message": "Rides retrieved successfully",
    "data": [
        {
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
            "_id": "6871ed4b4edb4c02519a40ed",
            "userId": {
                "geoLocation": {
                    "type": "Point",
                    "coordinates": [
                        0,
                        0
                    ]
                },
                "action": "request",
                "driverTotalEarn": 0,
                "adminRevenue": 0,
                "_id": "685a7b2a2e8c8fd76a0ed8fc",
                "name": "John Doe",
                "role": "USER",
                "email": "user@gmail.com",
                "image": "https://i.ibb.co/z5YHLV9/profile.png",
                "status": "active",
                "verified": true,
                "isOnline": false,
                "isDeleted": false,
                "createdAt": "2025-06-24T10:17:14.295Z",
                "updatedAt": "2025-07-15T06:17:22.812Z",
                "__v": 0,
                "totalAmountSpend": 5014.53,
                "totalTrip": 18
            },
            "service": "686e0b71153fae6071f36f35",
            "category": "686ca5bcbf07c6afc6bf8747",
            "distance": 6.795114946577798,
            "duration": 30,
            "fare": 351.93,
            "rideStatus": "completed",
            "paymentMethod": "stripe",
            "paymentStatus": "paid",
            "rejectedDrivers": [],
            "createdAt": "2025-07-12T05:06:19.400Z",
            "updatedAt": "2025-07-12T05:07:06.138Z",
            "__v": 0,
            "driverId": {
                "geoLocation": {
                    "type": "Point",
                    "coordinates": [
                        90.4125,
                        23.8103
                    ]
                },
                "action": "request",
                "adminRevenue": 0,
                "totalAmountSpend": 0,
                "_id": "68528df7a19352787ce298c9",
                "name": "Zulkar Naeem Rabby",
                "role": "DRIVER",
                "email": "zn.rabby@gmail.com",
                "image": "/image/images-1752296000345.jpg",
                "status": "active",
                "verified": true,
                "isOnline": true,
                "isDeleted": false,
                "createdAt": "2025-06-18T09:59:19.528Z",
                "updatedAt": "2025-07-15T06:17:22.654Z",
                "__v": 0,
                "stripeAccountId": "acct_1RdA4sPNNI1vZYZl",
                "driverLicense": {
                    "licenseNumber": 123456789,
                    "licenseExpiryDate": "2030-12-31T00:00:00.000Z",
                    "uploadDriversLicense": "/image/images-1752294386281.jpg"
                },
                "driverVehicles": {
                    "vehiclesMake": "Toyota",
                    "vehiclesModel": "Corolla",
                    "vehiclesYear": "2018-01-01T00:00:00.000Z",
                    "vehiclesRegistrationNumber": 987654321,
                    "vehiclesInsuranceNumber": 123456789,
                    "vehiclesPicture": "https://example.com/license.jpg",
                    "vehiclesCategory": "Hatchback"
                },
                "driverTotalEarn": 4513.099999999999,
                "totalTrip": 1,
                "contact": "01712340000"
            }
        },]}
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