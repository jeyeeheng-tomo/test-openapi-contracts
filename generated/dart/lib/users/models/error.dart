// ignore_for_file: type=lint
import 'package:microsoft_kiota_abstractions/microsoft_kiota_abstractions.dart';
import './error_details.dart';

/// auto generated
class Error extends ApiException implements AdditionalDataHolder, Parsable {
    ///  Stores additional data not described in the OpenAPI description found when deserializing. Can be used for serialization as well.
    @override
    Map<String, Object?> additionalData;
    ///  Stable, machine-readable error code.
    String? code;
    ///  Optional structured context for the error.
    ErrorDetails? details;
    /// Instantiates a new [Error] and sets the default values.
    Error( {
        super.message,
        super.statusCode,
        super.responseHeaders,
        super.innerExceptions,
        required this.additionalData,
        this.code,
        this.details,
    });
    /// Creates a copy of the object.
    @override
    Error copyWith({int? statusCode, String? message, Map<String, List<String>>? responseHeaders, Iterable<Object?>? innerExceptions, Map<String, Object?>? additionalData, String? code, ErrorDetails? details }){
        return Error(
        message : message ?? this.message, 
        statusCode : statusCode ?? this.statusCode, 
        responseHeaders : responseHeaders ?? this.responseHeaders, 
        innerExceptions : innerExceptions ?? this.innerExceptions, 
        additionalData : additionalData ?? this.additionalData, 
        code : code ?? this.code, 
        details : details ?? this.details, 
        );
    }
    /// Creates a new instance of the appropriate class based on discriminator value
    ///  [parseNode] The parse node to use to read the discriminator value and create the object
    static Error createFromDiscriminatorValue(ParseNode parseNode) {
        return Error(additionalData: {});
    }
    /// The deserialization information for the current model
    @override
    Map<String, void Function(ParseNode)> getFieldDeserializers() {
        var deserializerMap = <String, void Function(ParseNode)>{};
        deserializerMap['code'] = (node) => code = node.getStringValue();
        deserializerMap['details'] = (node) => details = node.getObjectValue<ErrorDetails>(ErrorDetails.createFromDiscriminatorValue);
        return deserializerMap;
    }
    /// Serializes information the current object
    ///  [writer] Serialization writer to use to serialize this model
    @override
    void serialize(SerializationWriter writer) {
        writer.writeStringValue('code', code);
        writer.writeObjectValue<ErrorDetails>('details', details);
        writer.writeAdditionalData(additionalData);
    }
}
