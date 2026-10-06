// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import 'package:uuid/uuid.dart';
import './money.dart';
import './order_item.dart';
import './order_status.dart';
import './timestamps.dart';

/// auto generated
class Order extends Timestamps implements Parsable {
    ///  The id property
    UuidValue? id;
    ///  The items property
    Iterable<OrderItem>? items;
    ///  The status property
    OrderStatus? status;
    ///  The total property
    Money? total;
    ///  References `User.id` in the Users API.
    UuidValue? userId;
    /// Instantiates a new [Order] and sets the default values.
    Order() : super() ;
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static Order createFromDiscriminatorValue(ParseNode parseNode) {
        return Order();
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = super.getFieldDeserializers();
        deserializerMap['id'] = (node) => id = node.getGuidValue();
        deserializerMap['items'] = (node) => items = node.getCollectionOfObjectValues<OrderItem>(OrderItem.createFromDiscriminatorValue);
        deserializerMap['status'] = (node) => status = node.getEnumValue<OrderStatus>((stringValue) => OrderStatus.values.where((enumVal) => enumVal.value == stringValue).firstOrNull);
        deserializerMap['total'] = (node) => total = node.getObjectValue<Money>(Money.createFromDiscriminatorValue);
        deserializerMap['user_id'] = (node) => userId = node.getGuidValue();
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        super.serialize(writer);
        writer.writeUuidValue('id', id);
        writer.writeCollectionOfObjectValues<OrderItem>('items', items);
        writer.writeEnumValue<OrderStatus>('status', status, (e) => e?.value);
        writer.writeObjectValue<Money>('total', total);
        writer.writeUuidValue('user_id', userId);
    }
}
