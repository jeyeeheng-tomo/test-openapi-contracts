// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import '../models/user.dart';

/// auto generated
class UsersGetResponse implements AdditionalDataHolder, Parsable {
    ///  Stores additional data not described in the OpenAPI description found when deserializing. Can be used for serialization as well.
    @override
    Map<String, Object?> additionalData;
    ///  The data property
    Iterable<User>? data;
    ///  Pass as `page_token` to fetch the next page. Absent on the last page.
    String? nextPageToken;
    /// Instantiates a new [UsersGetResponse] and sets the default values.
    UsersGetResponse() :  
        additionalData = {};
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static UsersGetResponse createFromDiscriminatorValue(ParseNode parseNode) {
        return UsersGetResponse();
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = <String, void Function(ParseNode)>{};
        deserializerMap['data'] = (node) => data = node.getCollectionOfObjectValues<User>(User.createFromDiscriminatorValue);
        deserializerMap['next_page_token'] = (node) => nextPageToken = node.getStringValue();
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        writer.writeCollectionOfObjectValues<User>('data', data);
        writer.writeStringValue('next_page_token', nextPageToken);
        writer.writeAdditionalData(additionalData);
    }
}
