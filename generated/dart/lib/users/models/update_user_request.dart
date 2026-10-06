// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import './update_user_request_status.dart';

/// auto generated
class UpdateUserRequest implements Parsable {
    ///  The display_name property
    String? displayName;
    ///  The status property
    UpdateUserRequestStatus? status;
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static UpdateUserRequest createFromDiscriminatorValue(ParseNode parseNode) {
        return UpdateUserRequest();
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = <String, void Function(ParseNode)>{};
        deserializerMap['display_name'] = (node) => displayName = node.getStringValue();
        deserializerMap['status'] = (node) => status = node.getEnumValue<UpdateUserRequestStatus>((stringValue) => UpdateUserRequestStatus.values.where((enumVal) => enumVal.value == stringValue).firstOrNull);
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        writer.writeStringValue('display_name', displayName);
        writer.writeEnumValue<UpdateUserRequestStatus>('status', status, (e) => e?.value);
    }
}
