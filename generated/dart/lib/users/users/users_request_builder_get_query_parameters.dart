// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';

/// auto generated
/// List users
class UsersRequestBuilderGetQueryParameters implements AbstractQueryParameters {
    ///  Filter to the single user with this exact email address.
    String? email;
    ///  Maximum number of items to return.
    /// @QueryParameter('page_size')
    int? pageSize;
    ///  Opaque cursor returned by a previous call as `next_page_token`.
    /// @QueryParameter('page_token')
    String? pageToken;
    /// Extracts the query parameters into a map for the URI template parsing.
    @override
    Map<String, dynamic> toMap() {
        return {
            'email' : email,
            'page_size' : pageSize,
            'page_token' : pageToken,
        };
    }
}
