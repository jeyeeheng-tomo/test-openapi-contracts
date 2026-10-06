// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:uuid/uuid.dart';
import './order_item.dart';

/// auto generated
class CreateOrderRequest implements Parsable {
    ///  The items property
    Iterable<OrderItem>? items;
    ///  The user_id property
    UuidValue? userId;
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static CreateOrderRequest createFromDiscriminatorValue(ParseNode parseNode) {
        return CreateOrderRequest();
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = <String, void Function(ParseNode)>{};
        deserializerMap['items'] = (node) => items = node.getCollectionOfObjectValues<OrderItem>(OrderItem.createFromDiscriminatorValue);
        deserializerMap['user_id'] = (node) => userId = node.getGuidValue();
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        writer.writeCollectionOfObjectValues<OrderItem>('items', items);
        writer.writeUuidValue('user_id', userId);
    }
}
