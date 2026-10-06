// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import '../models/order_status.dart';

/// auto generated
/// List orders
class OrdersRequestBuilderGetQueryParameters implements AbstractQueryParameters {
    ///  Maximum number of items to return.
    /// @QueryParameter('page_size')
    int? pageSize;
    ///  Opaque cursor returned by a previous call as `next_page_token`.
    /// @QueryParameter('page_token')
    String? pageToken;
    ///  Filter by order status.
    OrderStatus? status;
    /// Extracts the query parameters into a map for the URI template parsing.
    @override
    Map<String, dynamic> toMap() {
        return {
            'page_size' : pageSize,
            'page_token' : pageToken,
            'status' : status,
        };
    }
}
