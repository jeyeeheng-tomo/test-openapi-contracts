// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:uuid/uuid.dart';
import '../models/create_order_request.dart';
import '../models/error.dart';
import '../models/order.dart';
import './item/with_order_item_request_builder.dart';
import './orders_get_response.dart';
import './orders_request_builder_get_query_parameters.dart';

/// auto generated
/// Builds and executes requests for operations under \orders
class OrdersRequestBuilder extends BaseRequestBuilder<OrdersRequestBuilder> {
    /// Gets an item from the api_contracts.orders.orders.item collection
    ///  [orderId] Unique identifier of the item
    WithOrderItemRequestBuilder byOrderId(UuidValue orderId) {
        var urlTplParams = Map.of(pathParameters);
        urlTplParams.putIfAbsent('orderId', () => orderId);
        return WithOrderItemRequestBuilder(urlTplParams, requestAdapter);
    }
    /// Clones the requestbuilder.
    @override
    OrdersRequestBuilder clone() {
        return OrdersRequestBuilder(pathParameters, requestAdapter);
    }
    /// Instantiates a new [OrdersRequestBuilder] and sets the default values.
    ///  [pathParameters] Path parameters for the request
    ///  [requestAdapter] The request adapter to use to execute the requests.
    OrdersRequestBuilder(Map<String, dynamic> pathParameters, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders{?page_size*,page_token*,status*}", pathParameters) ;
    /// Instantiates a new [OrdersRequestBuilder] and sets the default values.
    ///  [rawUrl] The raw URL to use for the request builder.
    ///  [requestAdapter] The request adapter to use to execute the requests.
    OrdersRequestBuilder.withUrl(String rawUrl, RequestAdapter requestAdapter) : super(requestAdapter, "{+baseurl}/orders{?page_size*,page_token*,status*}", {RequestInformation.rawUrlKey : rawUrl}) ;
    /// List orders
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<OrdersGetResponse?> getAsync([void Function(RequestConfiguration<OrdersRequestBuilderGetQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toGetRequestInformation(requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '400' :  Error.createFromDiscriminatorValue,
            '401' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<OrdersGetResponse>(requestInfo, OrdersGetResponse.createFromDiscriminatorValue, errorMapping);
    }
    /// Place an order
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    Future<Order?> postAsync(CreateOrderRequest body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) async {
        var requestInfo = toPostRequestInformation(body, requestConfiguration);
        final errorMapping = <String, ParsableFactory<Parsable>>{
            '400' :  Error.createFromDiscriminatorValue,
            '401' :  Error.createFromDiscriminatorValue,
            '409' :  Error.createFromDiscriminatorValue,
        };
        return await requestAdapter.send<Order>(requestInfo, Order.createFromDiscriminatorValue, errorMapping);
    }
    /// List orders
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toGetRequestInformation([void Function(RequestConfiguration<OrdersRequestBuilderGetQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.get, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<OrdersRequestBuilderGetQueryParameters>(requestConfiguration, () => OrdersRequestBuilderGetQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        return requestInfo;
    }
    /// Place an order
    ///  [body] The request body
    ///  [requestConfiguration] Configuration for the request such as headers, query parameters, and middleware options.
    RequestInformation toPostRequestInformation(CreateOrderRequest body, [void Function(RequestConfiguration<DefaultQueryParameters>)? requestConfiguration]) {
        var requestInfo = RequestInformation(httpMethod : HttpMethod.post, urlTemplate : urlTemplate, pathParameters :  pathParameters);
        requestInfo.configure<DefaultQueryParameters>(requestConfiguration, () => DefaultQueryParameters());
        requestInfo.headers.put('Accept', 'application/json');
        requestInfo.setContentFromParsable(requestAdapter, 'application/json', body);
        return requestInfo;
    }
}
