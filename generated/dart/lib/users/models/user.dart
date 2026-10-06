// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:uuid/uuid.dart';
import './timestamps.dart';
import './user_status.dart';

/// auto generated
class User extends Timestamps implements Parsable {
    ///  The display_name property
    String? displayName;
    ///  The email property
    String? email;
    ///  The id property
    UuidValue? id;
    ///  The status property
    UserStatus? status;
    /// Instantiates a new [User] and sets the default values.
    User() : super() ;
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static User createFromDiscriminatorValue(ParseNode parseNode) {
        return User();
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = super.getFieldDeserializers();
        deserializerMap['display_name'] = (node) => displayName = node.getStringValue();
        deserializerMap['email'] = (node) => email = node.getStringValue();
        deserializerMap['id'] = (node) => id = node.getGuidValue();
        deserializerMap['status'] = (node) => status = node.getEnumValue<UserStatus>((stringValue) => UserStatus.values.where((enumVal) => enumVal.value == stringValue).firstOrNull);
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        super.serialize(writer);
        writer.writeStringValue('display_name', displayName);
        writer.writeStringValue('email', email);
        writer.writeUuidValue('id', id);
        writer.writeEnumValue<UserStatus>('status', status, (e) => e?.value);
    }
}
